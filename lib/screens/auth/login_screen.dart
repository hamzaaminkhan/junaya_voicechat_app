import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/auth_ui.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final AuthService _authService = AuthService.instance;

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    return null;
  }

  Future<void> _login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_isLoading || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final credential = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Unable to sign in. Please try again.');
      }

      if (user.email != null && !user.emailVerified) {
        if (!mounted) return;

        showAuthMessage(context, 'Verify your email to finish signing in.');

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.emailVerification,
          (route) => false,
        );
        return;
      }

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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 8),
              const AuthLogo(),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome back',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign in to continue to Junaya.',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                enabled: !_isLoading,
                autocorrect: false,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.5),
                decoration: authInputDecoration(
                  hint: 'Email address',
                  icon: Icons.mail_outline_rounded,
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              const SizedBox(height: 13),
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                validator: _validatePassword,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                enabled: !_isLoading,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.5),
                decoration: authInputDecoration(
                  hint: 'Password',
                  icon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword
                        ? 'Show password'
                        : 'Hide password',
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                ),
                onFieldSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.forgotPassword,
                          );
                        },
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 5,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: GoogleFonts.poppins(
                      color: AuthUi.purple,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AuthPrimaryButton(
                label: 'Sign In',
                loading: _isLoading,
                onPressed: _login,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.white.withValues(alpha: .10)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'OR',
                      style: GoogleFonts.poppins(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.white.withValues(alpha: .10)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AuthOutlineButton(
                label: 'Continue with Phone',
                icon: Icons.phone_outlined,
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.phoneVerification,
                        );
                      },
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () {
                            Navigator.pushNamed(context, AppRoutes.signup);
                          },
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                        color: AuthUi.gold,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
