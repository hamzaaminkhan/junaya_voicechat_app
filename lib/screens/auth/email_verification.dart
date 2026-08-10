import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/auth_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _checking = false;
  bool _resending = false;
  bool _backgroundCheckRunning = false;
  bool _canResend = false;
  int _cooldown = 60;

  Timer? _verificationTimer;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _startCooldown();
    _startVerificationCheck();
  }

  void _startVerificationCheck() {
    _verificationTimer?.cancel();
    _verificationTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (_backgroundCheckRunning || !mounted) return;
      _backgroundCheckRunning = true;
      try {
        await _checkVerification(silent: true);
      } finally {
        _backgroundCheckRunning = false;
      }
    });
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    _cooldown = 60;
    _canResend = false;

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_cooldown <= 1) {
        timer.cancel();
        setState(() {
          _cooldown = 0;
          _canResend = true;
        });
        return;
      }

      setState(() => _cooldown--);
    });
  }

  Future<void> _checkVerification({bool silent = false}) async {
    if (!silent && _checking) return;

    if (!silent && mounted) {
      setState(() => _checking = true);
    }

    try {
      final user = AuthService.instance.currentUser;
      if (user == null) {
        _verificationTimer?.cancel();
        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
        return;
      }

      final verified = await AuthService.instance.isEmailVerified();
      if (!mounted) return;

      if (verified) {
        _verificationTimer?.cancel();
        _cooldownTimer?.cancel();
        await AuthService.instance.syncCurrentUserState();

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.main,
          (route) => false,
        );
        return;
      }

      if (!silent) {
        showAuthMessage(
          context,
          'Your email is not verified yet. Open the link in your inbox and try again.',
          isError: true,
        );
      }
    } catch (e) {
      if (!silent && mounted) {
        showAuthMessage(
          context,
          e.toString().replaceFirst('Exception: ', ''),
          isError: true,
        );
      }
    } finally {
      if (!silent && mounted) {
        setState(() => _checking = false);
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (!_canResend || _resending) return;

    setState(() => _resending = true);

    try {
      await AuthService.instance.sendEmailVerification();
      if (!mounted) return;

      _startCooldown();
      showAuthMessage(context, 'A new verification email has been sent.');
    } catch (e) {
      if (!mounted) return;
      showAuthMessage(
        context,
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _resending = false);
      }
    }
  }

  Future<void> _openEmailApp() async {
    final uri = Uri(scheme: 'mailto');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!mounted) return;
    showAuthMessage(
      context,
      'No email app could be opened on this device.',
      isError: true,
    );
  }

  Future<void> _logout() async {
    try {
      await AuthService.instance.signOut();
    } catch (e) {
      if (mounted) {
        showAuthMessage(
          context,
          e.toString().replaceFirst('Exception: ', ''),
          isError: true,
        );
      }
      return;
    }

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final email = user?.email ?? 'your email address';

    return AuthPageShell(
      child: Column(
        children: [
          const SizedBox(height: 8),
          const AuthLogo(),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Verify your email',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'One quick step keeps your Junaya account secure.',
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.5),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AuthUi.gold.withValues(alpha: .07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AuthUi.gold.withValues(alpha: .24)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AuthUi.gold.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.mark_email_unread_outlined,
                    color: AuthUi.gold,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verification sent to',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        email,
                        style: GoogleFonts.poppins(
                          color: AuthUi.gold,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Open the verification email, tap the link, then return here. Junaya checks automatically in the background.',
              style: GoogleFonts.poppins(
                color: Colors.white60,
                fontSize: 12,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: 22),
          AuthPrimaryButton(
            label: "I've Verified",
            loading: _checking,
            onPressed: () => _checkVerification(),
          ),
          const SizedBox(height: 12),
          AuthOutlineButton(
            label: 'Open Email App',
            icon: Icons.email_outlined,
            onPressed: _openEmailApp,
          ),
          const SizedBox(height: 12),
          AuthOutlineButton(
            label: _canResend
                ? 'Resend Verification Email'
                : 'Resend in ${_cooldown}s',
            icon: Icons.refresh_rounded,
            loading: _resending,
            onPressed: _canResend ? _resendVerificationEmail : null,
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _resending || _checking ? null : _logout,
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(
              'Use a different account',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(foregroundColor: Colors.white54),
          ),
        ],
      ),
    );
  }
}
