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
  final _codeController = TextEditingController();
  OtpArguments? _args;
  bool _initialized = false;
  bool _loading = false;
  bool _resending = false;
  int _cooldown = 30;
  Timer? _cooldownTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is OtpArguments) {
      _args = arguments;
      _startCooldown();
    }
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    _cooldown = 30;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_cooldown <= 1) {
        timer.cancel();
        setState(() => _cooldown = 0);
        return;
      }
      setState(() => _cooldown--);
    });
  }

  Future<void> _completeCredential(PhoneAuthCredential credential) async {
    if (_loading) return;
    setState(() => _loading = true);

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
      showAuthMessage(
        context,
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verifyCode() async {
    final args = _args;
    if (args == null || _loading) return;

    final code = _codeController.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      showAuthMessage(
        context,
        'Enter the 6-digit verification code.',
        isError: true,
      );
      return;
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: args.verificationId,
      smsCode: code,
    );

    await _completeCredential(credential);
  }

  Future<void> _resendCode() async {
    final args = _args;
    if (args == null || _resending || _cooldown > 0) return;

    setState(() => _resending = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: args.phoneNumber,
        timeout: const Duration(seconds: 60),
        forceResendingToken: args.resendToken,
        verificationCompleted: (credential) async {
          await _completeCredential(credential);
        },
        verificationFailed: (exception) {
          if (!mounted) return;
          showAuthMessage(
            context,
            exception.message ?? 'Unable to resend the code.',
            isError: true,
          );
        },
        codeSent: (verificationId, resendToken) {
          if (!mounted) return;
          setState(() {
            _args = OtpArguments(
              verificationId: verificationId,
              phoneNumber: args.phoneNumber,
              resendToken: resendToken,
            );
            _resending = false;
            _codeController.clear();
          });
          _startCooldown();
          showAuthMessage(context, 'A new SMS code has been sent.');
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (_) {
      if (!mounted) return;
      showAuthMessage(
        context,
        'Unable to resend the code. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = _args;

    if (args == null) {
      return AuthPageShell(
        child: Column(
          children: [
            const AuthLogo(size: 76),
            const SizedBox(height: 20),
            Text(
              'Verification session expired',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Request a fresh SMS code to continue.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.5),
            ),
            const SizedBox(height: 22),
            AuthPrimaryButton(
              label: 'Verify Phone Number',
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.phoneVerification,
                );
              },
            ),
          ],
        ),
      );
    }

    return AuthPageShell(
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
              'Enter verification code',
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
              'We sent a 6-digit SMS code to ${args.phoneNumber}.',
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            enabled: !_loading,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 10,
            ),
            decoration: authInputDecoration(
              hint: '000000',
              icon: Icons.password_rounded,
            ).copyWith(counterText: ''),
            onSubmitted: (_) => _verifyCode(),
          ),
          const SizedBox(height: 22),
          AuthPrimaryButton(
            label: 'Verify & Continue',
            loading: _loading,
            onPressed: _verifyCode,
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: _cooldown == 0 && !_resending && !_loading
                ? _resendCode
                : null,
            child: Text(
              _resending
                  ? 'Sending...'
                  : _cooldown > 0
                  ? 'Resend code in ${_cooldown}s'
                  : 'Resend verification code',
              style: GoogleFonts.poppins(
                color: _cooldown == 0 ? AuthUi.purple : Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: _loading
                ? null
                : () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.phoneVerification,
                    );
                  },
            child: Text(
              'Change phone number',
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }
}
