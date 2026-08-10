import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/auth_ui.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import 'otp_screen.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _normalizedPhone() {
    var phone = _phoneController.text.trim().replaceAll(
      RegExp(r'[\s\-()]'),
      '',
    );

    if (phone.startsWith('00')) {
      phone = '+${phone.substring(2)}';
    }

    return phone;
  }

  String? _validatePhone(String? value) {
    final phone = (value ?? '').trim().replaceAll(RegExp(r'[\s\-()]'), '');
    final normalized = phone.startsWith('00')
        ? '+${phone.substring(2)}'
        : phone;

    if (normalized.isEmpty) {
      return 'Please enter your phone number.';
    }

    if (!RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(normalized)) {
      return 'Use international format, for example +923001234567.';
    }

    return null;
  }

  Future<void> _completeAutomaticVerification(
    PhoneAuthCredential credential,
  ) async {
    try {
      await AuthService.instance.signInWithPhoneCredential(credential);
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.main,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      showAuthMessage(
        context,
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    }
  }

  Future<void> _sendCode() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_loading || !_formKey.currentState!.validate()) return;

    if (kIsWeb) {
      showAuthMessage(
        context,
        'Phone sign-in on web requires the Firebase reCAPTCHA flow. Use email sign-in on web for now.',
        isError: true,
      );
      return;
    }

    setState(() => _loading = true);
    final phone = _normalizedPhone();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) async {
          await _completeAutomaticVerification(credential);
        },
        verificationFailed: (exception) {
          if (!mounted) return;
          setState(() => _loading = false);
          showAuthMessage(
            context,
            exception.message ?? 'Unable to verify this phone number.',
            isError: true,
          );
        },
        codeSent: (verificationId, resendToken) {
          if (!mounted) return;
          setState(() => _loading = false);

          Navigator.pushNamed(
            context,
            AppRoutes.otp,
            arguments: OtpArguments(
              verificationId: verificationId,
              phoneNumber: phone,
              resendToken: resendToken,
            ),
          );
        },
        codeAutoRetrievalTimeout: (_) {
          if (mounted) {
            setState(() => _loading = false);
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      showAuthMessage(
        context,
        e.message ?? 'Unable to send the verification code.',
        isError: true,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      showAuthMessage(
        context,
        'Unable to send the verification code. Please try again.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            AuthBackButton(
              enabled: !_loading,
              onPressed: () => Navigator.maybePop(context),
            ),
            const SizedBox(height: 4),
            const AuthLogo(size: 76),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Continue with phone',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ),
            const SizedBox(height: 7),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter your mobile number with country code. We will send a one-time SMS code.',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _phoneController,
              validator: _validatePhone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumber],
              enabled: !_loading,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.5),
              decoration: authInputDecoration(
                hint: '+923001234567',
                label: 'Phone number',
                icon: Icons.phone_outlined,
              ),
              onFieldSubmitted: (_) => _sendCode(),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'We will only use this number for secure account verification. Standard SMS rates may apply.',
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 10.5,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 22),
            AuthPrimaryButton(
              label: 'Send Verification Code',
              loading: _loading,
              onPressed: _sendCode,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _loading
                  ? null
                  : () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
              child: Text(
                'Use email instead',
                style: GoogleFonts.poppins(
                  color: AuthUi.purple,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
