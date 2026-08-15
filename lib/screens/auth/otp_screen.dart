import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/auth_ui.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class OtpArguments {
  final String verificationId;
  final String phoneNumber;
  final int? resendToken;

  const OtpArguments({
    required this.verificationId,
    required this.phoneNumber,
    this.resendToken,
  });
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _codeController =
  TextEditingController();

  final AuthService _firebaseAuthService =
      AuthService.instance;

  OtpArguments? _args;

  bool _initialized = false;
  bool _loading = false;
  bool _resending = false;

  int _cooldown = 30;

  Timer? _cooldownTimer;

  // ==========================================
  // INITIALIZE ROUTE ARGUMENTS
  // ==========================================

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;

    _initialized = true;

    final arguments =
        ModalRoute.of(context)?.settings.arguments;

    if (arguments is OtpArguments) {
      _args = arguments;

      _startCooldown();
    }
  }

  // ==========================================
  // DISPOSE
  // ==========================================

  @override
  void dispose() {
    _cooldownTimer?.cancel();

    _codeController.dispose();

    super.dispose();
  }

  // ==========================================
  // RESEND COOLDOWN
  // ==========================================

  void _startCooldown() {
    _cooldownTimer?.cancel();

    if (mounted) {
      setState(() {
        _cooldown = 30;
      });
    } else {
      _cooldown = 30;
    }

    _cooldownTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_cooldown <= 1) {
          timer.cancel();

          setState(() {
            _cooldown = 0;
          });

          return;
        }

        setState(() {
          _cooldown--;
        });
      },
    );
  }

  // ==========================================
  // COMPLETE FIREBASE PHONE LOGIN
  // ==========================================

  Future<void> _completeCredential(
      PhoneAuthCredential credential,
      ) async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    try {
      // Phone authentication remains Firebase-based.
      //
      // AuthService also takes care of creating/updating
      // the Firestore profile for phone users.
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

      showAuthMessage(
        context,
        _firebaseOtpError(e),
        isError: true,
      );
    } catch (e) {
      if (!mounted) return;

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
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // ==========================================
  // VERIFY CODE
  // ==========================================

  Future<void> _verifyCode() async {
    final args = _args;

    if (args == null || _loading) {
      return;
    }

    FocusManager.instance.primaryFocus
        ?.unfocus();

    final code =
    _codeController.text.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      showAuthMessage(
        context,
        'Enter the 6-digit verification code.',
        isError: true,
      );

      return;
    }

    try {
      final credential =
      PhoneAuthProvider.credential(
        verificationId:
        args.verificationId,
        smsCode: code,
      );

      await _completeCredential(
        credential,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      showAuthMessage(
        context,
        _firebaseOtpError(e),
        isError: true,
      );
    }
  }

  // ==========================================
  // RESEND SMS CODE
  // ==========================================

  Future<void> _resendCode() async {
    final args = _args;

    if (args == null ||
        _resending ||
        _loading ||
        _cooldown > 0) {
      return;
    }

    setState(() {
      _resending = true;
    });

    try {
      await FirebaseAuth.instance
          .verifyPhoneNumber(
        phoneNumber: args.phoneNumber,

        timeout:
        const Duration(seconds: 60),

        forceResendingToken:
        args.resendToken,

        // ======================================
        // ANDROID AUTO VERIFICATION
        // ======================================

        verificationCompleted:
            (
            PhoneAuthCredential
            credential,
            ) async {
          if (!mounted) return;

          await _completeCredential(
            credential,
          );
        },

        // ======================================
        // VERIFICATION FAILED
        // ======================================

        verificationFailed:
            (
            FirebaseAuthException
            exception,
            ) {
          if (!mounted) return;

          setState(() {
            _resending = false;
          });

          showAuthMessage(
            context,
            _firebaseOtpError(
              exception,
            ),
            isError: true,
          );
        },

        // ======================================
        // NEW CODE SENT
        // ======================================

        codeSent:
            (
            String verificationId,
            int? resendToken,
            ) {
          if (!mounted) return;

          setState(() {
            _args = OtpArguments(
              verificationId:
              verificationId,
              phoneNumber:
              args.phoneNumber,
              resendToken:
              resendToken,
            );

            _resending = false;

            _codeController.clear();
          });

          _startCooldown();

          showAuthMessage(
            context,
            'A new SMS verification code has been sent.',
          );
        },

        // ======================================
        // AUTO RETRIEVAL TIMEOUT
        // ======================================

        codeAutoRetrievalTimeout:
            (
            String verificationId,
            ) {
          final currentArgs = _args;

          if (!mounted ||
              currentArgs == null) {
            return;
          }

          // Keep newest verification ID.
          setState(() {
            _args = OtpArguments(
              verificationId:
              verificationId,
              phoneNumber:
              currentArgs
                  .phoneNumber,
              resendToken:
              currentArgs
                  .resendToken,
            );
          });
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      showAuthMessage(
        context,
        _firebaseOtpError(e),
        isError: true,
      );
    } catch (_) {
      if (!mounted) return;

      showAuthMessage(
        context,
        'Unable to resend the code. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _resending = false;
        });
      }
    }
  }

  // ==========================================
  // FIREBASE OTP ERRORS
  // ==========================================

  String _firebaseOtpError(
      FirebaseAuthException e,
      ) {
    switch (e.code) {
      case 'invalid-verification-code':
        return 'The verification code is incorrect.';

      case 'session-expired':
        return 'The verification code has expired. Request a new code.';

      case 'missing-verification-code':
        return 'Enter the verification code.';

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

      default:
        return e.message ??
            'Phone verification failed. Please try again.';
    }
  }

  // ==========================================
  // UI
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final args = _args;

    // ==========================================
    // MISSING / EXPIRED OTP SESSION
    // ==========================================

    if (args == null) {
      return AuthPageShell(
        child: Column(
          children: [
            const AuthLogo(
              size: 76,
            ),

            const SizedBox(height: 20),

            Text(
              'Verification session expired',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Request a fresh SMS code to continue.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 12.5,
              ),
            ),

            const SizedBox(height: 22),

            AuthPrimaryButton(
              label:
              'Verify Phone Number',
              onPressed: () {
                Navigator
                    .pushReplacementNamed(
                  context,
                  AppRoutes
                      .phoneVerification,
                );
              },
            ),
          ],
        ),
      );
    }

    // ==========================================
    // OTP SCREEN
    // ==========================================

    return AuthPageShell(
      child: Column(
        children: [
          AuthBackButton(
            enabled:
            !_loading &&
                !_resending,
            onPressed: () {
              Navigator.maybePop(
                context,
              );
            },
          ),

          const SizedBox(height: 4),

          const AuthLogo(
            size: 76,
          ),

          const SizedBox(height: 20),

          Align(
            alignment:
            Alignment.centerLeft,
            child: Text(
              'Enter verification code',
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

          const SizedBox(height: 7),

          Align(
            alignment:
            Alignment.centerLeft,
            child: Text(
              'We sent a 6-digit SMS code to ${args.phoneNumber}.',
              style:
              GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ==================================
          // OTP INPUT
          // ==================================

          TextField(
            controller:
            _codeController,

            keyboardType:
            TextInputType.number,

            textInputAction:
            TextInputAction.done,

            autofillHints: const [
              AutofillHints.oneTimeCode,
            ],

            inputFormatters: [
              FilteringTextInputFormatter
                  .digitsOnly,

              LengthLimitingTextInputFormatter(
                6,
              ),
            ],

            enabled:
            !_loading &&
                !_resending,

            textAlign:
            TextAlign.center,

            style:
            GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight:
              FontWeight.w700,
              letterSpacing: 10,
            ),

            decoration:
            authInputDecoration(
              hint: '000000',
              icon:
              Icons.password_rounded,
            ).copyWith(
              counterText: '',
            ),

            onChanged: (value) {
              // Optional convenience:
              // automatically verify once
              // all 6 digits are entered.
              if (value.length == 6 &&
                  !_loading) {
                _verifyCode();
              }
            },

            onSubmitted: (_) {
              _verifyCode();
            },
          ),

          const SizedBox(height: 22),

          // ==================================
          // VERIFY
          // ==================================

          AuthPrimaryButton(
            label: 'Verify & Continue',
            loading: _loading,
            onPressed: _verifyCode,
          ),

          const SizedBox(height: 14),

          // ==================================
          // RESEND
          // ==================================

          TextButton(
            onPressed:
            _cooldown == 0 &&
                !_resending &&
                !_loading
                ? _resendCode
                : null,
            child: Text(
              _resending
                  ? 'Sending...'
                  : _cooldown > 0
                  ? 'Resend code in ${_cooldown}s'
                  : 'Resend verification code',
              style:
              GoogleFonts.poppins(
                color:
                _cooldown == 0 &&
                    !_resending
                    ? AuthUi.purple
                    : Colors.white38,
                fontSize: 12,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),

          // ==================================
          // CHANGE NUMBER
          // ==================================

          TextButton(
            onPressed:
            _loading ||
                _resending
                ? null
                : () {
              Navigator
                  .pushReplacementNamed(
                context,
                AppRoutes
                    .phoneVerification,
              );
            },
            child: Text(
              'Change phone number',
              style:
              GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}