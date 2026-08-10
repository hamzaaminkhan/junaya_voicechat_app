import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/auth_ui.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter your email.';

    const pattern = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
    if (!RegExp(pattern).hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  Future<void> _recoverPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_loading || !_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await AuthService.instance.resetPassword(_emailController.text.trim());

      if (!mounted) return;
      setState(() => _sent = true);
    } catch (e) {
      if (!mounted) return;
      showAuthMessage(
        context,
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _backToLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
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
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  _backToLogin();
                }
              },
            ),
            const SizedBox(height: 4),
            const AuthLogo(size: 76),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _sent ? 'Check your inbox' : 'Reset your password',
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
                _sent
                    ? 'We sent password reset instructions to your email.'
                    : "Enter your registered email and we'll send you a reset link.",
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_sent) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AuthUi.success.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AuthUi.success.withValues(alpha: .28),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.mark_email_read_outlined,
                      color: AuthUi.success,
                      size: 23,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _emailController.text.trim(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Open the link in that email to choose a new password. Check spam if you do not see it.',
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 11,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AuthPrimaryButton(
                label: 'Back to Sign In',
                onPressed: _backToLogin,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _loading ? null : _recoverPassword,
                child: Text(
                  _loading ? 'Sending...' : 'Send the link again',
                  style: GoogleFonts.poppins(
                    color: AuthUi.purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ] else ...[
              TextFormField(
                controller: _emailController,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                enabled: !_loading,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.5),
                decoration: authInputDecoration(
                  hint: 'Email address',
                  icon: Icons.mail_outline_rounded,
                ),
                onFieldSubmitted: (_) => _recoverPassword(),
              ),
              const SizedBox(height: 20),
              AuthPrimaryButton(
                label: 'Send Reset Link',
                loading: _loading,
                onPressed: _recoverPassword,
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _loading ? null : _backToLogin,
                icon: const Icon(Icons.arrow_back_rounded, size: 17),
                label: Text(
                  'Back to Sign In',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(foregroundColor: Colors.white60),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
