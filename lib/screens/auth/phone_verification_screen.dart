import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/auth_ui.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import 'otp_screen.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({
    super.key,
  });

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState
    extends State<PhoneVerificationScreen> {
  final _formKey =
  GlobalKey<FormState>();

  final _phoneController =
  TextEditingController();

  final AuthService _firebaseAuthService =
      AuthService.instance;

  bool _loading = false;

  // ==========================================
  // DISPOSE
  // ==========================================

  @override
  void dispose() {
    _phoneController.dispose();

    super.dispose();
  }

  // ==========================================
  // NORMALIZE PHONE NUMBER
  // ==========================================

  String _normalizedPhone() {
    var phone =
    _phoneController.text
        .trim()
        .replaceAll(
      RegExp(r'[\s\-()]'),
      '',
    );

    if (phone.startsWith('00')) {
      phone =
      '+${phone.substring(2)}';
    }

    return phone;
  }

  // ==========================================
  // PHONE VALIDATION
  // ==========================================

  String? _validatePhone(
      String? value,
      ) {
    final rawPhone =
    (value ?? '')
        .trim()
        .replaceAll(
      RegExp(r'[\s\-()]'),
      '',
    );

    final normalized =
    rawPhone.startsWith('00')
        ? '+${rawPhone.substring(2)}'
        : rawPhone;

    if (normalized.isEmpty) {
      return 'Please enter your phone number.';
    }

    if (!RegExp(
      r'^\+[1-9]\d{7,14}$',
    ).hasMatch(normalized)) {
      return 'Use international format, for example +923001234567.';
    }

    return null;
  }

  // ==========================================
  // AUTOMATIC FIREBASE VERIFICATION
  // ==========================================

  Future<void>
  _completeAutomaticVerification(
      PhoneAuthCredential credential,
      ) async {
    try {
      await _firebaseAuthService
          .signInWithPhoneCredential(
        credential,
      );

      if (!mounted) return;

      showAuthMessage(
        context,
        'Phone number verified successfully.',
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.main,
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      showAuthMessage(
        context,
        _firebasePhoneError(e),
        isError: true,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      showAuthMessage(
        context,
        e
            .toString()
            .replaceFirst(
          'Exception: ',
          '',
        ),
        isError: true,
      );
    }
  }

  // ==========================================
  // SEND SMS CODE
  // ==========================================

  Future<void> _sendCode() async {
    FocusManager.instance
        .primaryFocus
        ?.unfocus();

    if (_loading) return;

    final form =
        _formKey.currentState;

    if (form == null ||
        !form.validate()) {
      return;
    }

    // ======================================
    // WEB
    // ======================================

    if (kIsWeb) {
      showAuthMessage(
        context,
        'Phone sign-in on web requires Firebase reCAPTCHA. Use email sign-in on web for now.',
        isError: true,
      );

      return;
    }

    setState(() {
      _loading = true;
    });

    final phone =
    _normalizedPhone();

    try {
      await FirebaseAuth.instance
          .verifyPhoneNumber(
        phoneNumber: phone,

        timeout:
        const Duration(
          seconds: 60,
        ),

        // ====================================
        // ANDROID AUTOMATIC VERIFICATION
        // ====================================

        verificationCompleted:
            (
            PhoneAuthCredential
            credential,
            ) async {
          await _completeAutomaticVerification(
            credential,
          );
        },

        // ====================================
        // VERIFICATION FAILED
        // ====================================

        verificationFailed:
            (
            FirebaseAuthException
            exception,
            ) {
          if (!mounted) return;

          setState(() {
            _loading = false;
          });

          showAuthMessage(
            context,
            _firebasePhoneError(
              exception,
            ),
            isError: true,
          );
        },

        // ====================================
        // SMS CODE SENT
        // ====================================

        codeSent:
            (
            String verificationId,
            int? resendToken,
            ) {
          if (!mounted) return;

          setState(() {
            _loading = false;
          });

          Navigator.pushNamed(
            context,
            AppRoutes.otp,
            arguments: OtpArguments(
              verificationId:
              verificationId,
              phoneNumber: phone,
              resendToken:
              resendToken,
            ),
          );
        },

        // ====================================
        // AUTO-RETRIEVAL TIMEOUT
        // ====================================

        codeAutoRetrievalTimeout:
            (
            String verificationId,
            ) {
          if (!mounted) return;

          setState(() {
            _loading = false;
          });
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      showAuthMessage(
        context,
        _firebasePhoneError(e),
        isError: true,
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      showAuthMessage(
        context,
        'Unable to send the verification code. Please try again.',
        isError: true,
      );
    }
  }

  // ==========================================
  // FIREBASE PHONE ERRORS
  // ==========================================

  String _firebasePhoneError(
      FirebaseAuthException e,
      ) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'The phone number is invalid.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'quota-exceeded':
        return 'SMS verification quota has been reached. Please try again later.';

      case 'network-request-failed':
        return 'Check your internet connection and try again.';

      case 'operation-not-allowed':
        return 'Phone authentication is not enabled.';

      case 'missing-phone-number':
        return 'Enter your phone number.';

      case 'app-not-authorized':
        return 'This app is not authorized to use Firebase Phone Authentication.';

      case 'captcha-check-failed':
        return 'Phone verification security check failed. Please try again.';

      default:
        return e.message ??
            'Unable to verify this phone number.';
    }
  }

  // ==========================================
  // UI
  // ==========================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return AuthPageShell(
      child: Form(
        key: _formKey,

        autovalidateMode:
        AutovalidateMode
            .onUserInteraction,

        child: Column(
          children: [
            // ==================================
            // BACK
            // ==================================

            AuthBackButton(
              enabled: !_loading,
              onPressed: () {
                if (Navigator.canPop(
                  context,
                )) {
                  Navigator.pop(
                    context,
                  );
                } else {
                  Navigator
                      .pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                        (route) => false,
                  );
                }
              },
            ),

            const SizedBox(
              height: 4,
            ),

            const AuthLogo(
              size: 76,
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================
            // TITLE
            // ==================================

            Align(
              alignment:
              Alignment.centerLeft,
              child: Text(
                'Continue with phone',
                style:
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight:
                  FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ),

            const SizedBox(
              height: 7,
            ),

            Align(
              alignment:
              Alignment.centerLeft,
              child: Text(
                'Enter your mobile number with country code. We will send a one-time SMS code.',
                style:
                GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // ==================================
            // PHONE INPUT
            // ==================================

            TextFormField(
              controller:
              _phoneController,

              validator:
              _validatePhone,

              keyboardType:
              TextInputType.phone,

              textInputAction:
              TextInputAction.done,

              autofillHints: const [
                AutofillHints
                    .telephoneNumber,
              ],

              enabled: !_loading,

              autocorrect: false,

              style:
              GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13.5,
              ),

              decoration:
              authInputDecoration(
                hint:
                '+923001234567',
                label:
                'Phone number',
                icon:
                Icons.phone_outlined,
              ),

              onFieldSubmitted: (_) {
                _sendCode();
              },
            ),

            const SizedBox(
              height: 10,
            ),

            Align(
              alignment:
              Alignment.centerLeft,
              child: Text(
                'Use international format including the country code. Standard SMS rates may apply.',
                style:
                GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 10.5,
                  height: 1.45,
                ),
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            // ==================================
            // SEND CODE
            // ==================================

            AuthPrimaryButton(
              label:
              'Send Verification Code',
              loading:
              _loading,
              onPressed:
              _sendCode,
            ),

            const SizedBox(
              height: 16,
            ),

            // ==================================
            // EMAIL LOGIN
            // ==================================

            TextButton(
              onPressed:
              _loading
                  ? null
                  : () {
                Navigator
                    .pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                      (route) =>
                  false,
                );
              },

              child: Text(
                'Use email instead',
                style:
                GoogleFonts.poppins(
                  color:
                  AuthUi.purple,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}