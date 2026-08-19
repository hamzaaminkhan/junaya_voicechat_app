import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/auth_ui.dart';

import '../../routes/app_routes.dart';
import '../../services/backend_auth_service.dart';

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

  final BackendAuthService _authService =
      BackendAuthService.instance;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  // ==========================================
  // EMAIL VALIDATION
  // ==========================================

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email.';
    }

    const pattern =
        r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

    if (!RegExp(pattern).hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  // ==========================================
  // PASSWORD VALIDATION
  // ==========================================

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }

    return null;
  }

  // ==========================================
  // BACKEND LOGIN
  // ==========================================

  Future<void> _login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_isLoading) return;

    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response =
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      final user = response['user'];

      debugPrint(
        'Backend login successful',
      );

      debugPrint(
        'Logged in user: $user',
      );

      if (!mounted) return;

      final isVerified =
          user is Map &&
              user['emailVerified'] == true;

      showAuthMessage(
        context,
        isVerified
            ? 'Welcome back!'
            : 'Please verify your email to continue.',
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        isVerified
            ? AppRoutes.main
            : AppRoutes.emailVerification,
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      final message = e
          .toString()
          .replaceFirst(
        'Exception: ',
        '',
      );

      showAuthMessage(
        context,
        message,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          autovalidateMode:
          AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 8),

              const AuthLogo(),

              const SizedBox(height: 20),

              // ==================================
              // TITLE
              // ==================================

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

              // ==================================
              // EMAIL
              // ==================================

              TextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                validator: _validateEmail,
                keyboardType:
                TextInputType.emailAddress,
                textInputAction:
                TextInputAction.next,
                autofillHints: const [
                  AutofillHints.email,
                ],
                enabled: !_isLoading,
                autocorrect: false,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.5,
                ),
                decoration:
                authInputDecoration(
                  hint: 'Email address',
                  icon:
                  Icons.mail_outline_rounded,
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context)
                      .requestFocus(
                    _passwordFocusNode,
                  );
                },
              ),

              const SizedBox(height: 13),

              // ==================================
              // PASSWORD
              // ==================================

              TextFormField(
                controller:
                _passwordController,
                focusNode:
                _passwordFocusNode,
                validator:
                _validatePassword,
                obscureText:
                _obscurePassword,
                textInputAction:
                TextInputAction.done,
                autofillHints: const [
                  AutofillHints.password,
                ],
                enabled: !_isLoading,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.5,
                ),
                decoration:
                authInputDecoration(
                  hint: 'Password',
                  icon:
                  Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    tooltip:
                    _obscurePassword
                        ? 'Show password'
                        : 'Hide password',
                    onPressed:
                    _isLoading
                        ? null
                        : () {
                      setState(() {
                        _obscurePassword =
                        !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons
                          .visibility_off_outlined
                          : Icons
                          .visibility_outlined,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                ),
                onFieldSubmitted: (_) {
                  _login();
                },
              ),

              const SizedBox(height: 8),

              // ==================================
              // REMEMBER ME + FORGOT PASSWORD
              // ==================================

              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged:
                      _isLoading
                          ? null
                          : (value) {
                        setState(() {
                          _rememberMe =
                              value ??
                                  false;
                        });
                      },
                      activeColor:
                      AuthUi.purple,
                      side: const BorderSide(
                        color:
                        Colors.white38,
                      ),
                      materialTapTargetSize:
                      MaterialTapTargetSize
                          .shrinkWrap,
                    ),
                  ),

                  const SizedBox(width: 7),

                  GestureDetector(
                    onTap:
                    _isLoading
                        ? null
                        : () {
                      setState(() {
                        _rememberMe =
                        !_rememberMe;
                      });
                    },
                    child: Text(
                      'Remember me',
                      style:
                      GoogleFonts.poppins(
                        color:
                        Colors.white54,
                        fontSize: 11.5,
                      ),
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed:
                    _isLoading
                        ? null
                        : () {
                      Navigator
                          .pushNamed(
                        context,
                        AppRoutes
                            .forgotPassword,
                      );
                    },
                    style:
                    TextButton.styleFrom(
                      minimumSize:
                      Size.zero,
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 4,
                        vertical: 5,
                      ),
                      tapTargetSize:
                      MaterialTapTargetSize
                          .shrinkWrap,
                    ),
                    child: Text(
                      'Forgot password?',
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

              const SizedBox(height: 20),

              // ==================================
              // LOGIN BUTTON
              // ==================================

              AuthPrimaryButton(
                label: 'Sign In',
                loading: _isLoading,
                onPressed: _login,
              ),

              const SizedBox(height: 18),

              // ==================================
              // DIVIDER
              // ==================================

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.white
                          .withValues(
                        alpha: .10,
                      ),
                    ),
                  ),

                  Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      'OR',
                      style:
                      GoogleFonts.poppins(
                        color:
                        Colors.white38,
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Divider(
                      color: Colors.white
                          .withValues(
                        alpha: .10,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ==================================
              // PHONE LOGIN
              // Still uses Firebase flow
              // ==================================

              AuthOutlineButton(
                label: 'Continue with Phone',
                icon: Icons.phone_outlined,
                onPressed:
                _isLoading
                    ? null
                    : () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes
                        .phoneVerification,
                  );
                },
              ),

              const SizedBox(height: 22),

              // ==================================
              // SIGN UP
              // ==================================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style:
                    GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12.5,
                    ),
                  ),

                  GestureDetector(
                    onTap:
                    _isLoading
                        ? null
                        : () {
                      Navigator
                          .pushNamed(
                        context,
                        AppRoutes
                            .signup,
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style:
                      GoogleFonts.poppins(
                        color: AuthUi.gold,
                        fontSize: 12.5,
                        fontWeight:
                        FontWeight.w700,
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