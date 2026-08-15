import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/auth_ui.dart';

import '../../routes/app_routes.dart';
import '../../services/backend_auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final BackendAuthService _authService =
      BackendAuthService.instance;

  bool _loading = false;
  bool _agree = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ==========================================
  // USERNAME VALIDATION
  // ==========================================

  String? _validateUsername(String? value) {
    final username = value?.trim() ?? '';

    if (username.isEmpty) {
      return 'Please choose a username.';
    }

    if (username.length < 4) {
      return 'Use at least 4 characters.';
    }

    if (username.length > 20) {
      return 'Use 20 characters or fewer.';
    }

    if (!RegExp(
      r'^[a-zA-Z0-9_.]+$',
    ).hasMatch(username)) {
      return 'Use letters, numbers, _ or . only.';
    }

    return null;
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
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please create a password.';
    }

    if (password.length < 8) {
      return 'Use at least 8 characters.';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Add at least one uppercase letter.';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Add at least one lowercase letter.';
    }

    if (!RegExp(r'\d').hasMatch(password)) {
      return 'Add at least one number.';
    }

    if (!RegExp(
      r'''[!@#$%^&*(),.?":{}|<>]''',
    ).hasMatch(password)) {
      return 'Add at least one special character.';
    }

    return null;
  }

  // ==========================================
  // CONFIRM PASSWORD
  // ==========================================

  String? _validateConfirmPassword(
      String? value,
      ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }

    return null;
  }

  // ==========================================
  // BACKEND SIGN UP
  // ==========================================

  Future<void> _signUp() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    if (_loading) return;

    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    if (!_agree) {
      showAuthMessage(
        context,
        'Please accept the Terms & Conditions and Privacy Policy.',
        isError: true,
      );

      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      // ======================================
      // CREATE POSTGRESQL USER
      // ======================================

      await _authService.register(
        username:
        _usernameController.text.trim(),
        email:
        _emailController.text.trim(),
        password:
        _passwordController.text,
      );

      if (!mounted) return;

      // ======================================
      // AUTO LOGIN
      //
      // Register currently does not return JWT
      // tokens, so log in immediately afterward.
      // ======================================

      await _authService.login(
        email:
        _emailController.text.trim(),
        password:
        _passwordController.text,
        rememberMe: true,
      );

      if (!mounted) return;

      showAuthMessage(
        context,
        'Account created successfully.',
      );

      // ======================================
      // CURRENT TEMPORARY FLOW
      //
      // Email verification backend endpoints
      // are not implemented yet.
      //
      // Once verification APIs are ready,
      // change AppRoutes.main below to:
      //
      // AppRoutes.emailVerification
      // ======================================

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.main,
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
          _loading = false;
        });
      }
    }
  }

  // ==========================================
  // UI
  // ==========================================

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
              // ==================================
              // BACK
              // ==================================

              AuthBackButton(
                enabled: !_loading,
                onPressed: () {
                  if (Navigator.canPop(
                    context,
                  )) {
                    Navigator.pop(context);
                  } else {
                    Navigator
                        .pushReplacementNamed(
                      context,
                      AppRoutes.login,
                    );
                  }
                },
              ),

              const SizedBox(height: 2),

              const AuthLogo(
                size: 76,
              ),

              const SizedBox(height: 18),

              // ==================================
              // TITLE
              // ==================================

              Align(
                alignment:
                Alignment.centerLeft,
                child: Text(
                  'Create your account',
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

              const SizedBox(height: 6),

              Align(
                alignment:
                Alignment.centerLeft,
                child: Text(
                  'Choose your Junaya identity and get started.',
                  style:
                  GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12.5,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ==================================
              // USERNAME
              // ==================================

              TextFormField(
                controller:
                _usernameController,

                validator:
                _validateUsername,

                textInputAction:
                TextInputAction.next,

                textCapitalization:
                TextCapitalization.none,

                autocorrect: false,

                enabled: !_loading,

                style:
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.5,
                ),

                decoration:
                authInputDecoration(
                  hint: 'Username',
                  icon: Icons
                      .alternate_email_rounded,
                ),
              ),

              const SizedBox(height: 12),

              // ==================================
              // EMAIL
              // ==================================

              TextFormField(
                controller:
                _emailController,

                validator:
                _validateEmail,

                keyboardType:
                TextInputType
                    .emailAddress,

                textInputAction:
                TextInputAction.next,

                textCapitalization:
                TextCapitalization.none,

                autofillHints: const [
                  AutofillHints.email,
                ],

                autocorrect: false,

                enabled: !_loading,

                style:
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.5,
                ),

                decoration:
                authInputDecoration(
                  hint: 'Email address',
                  icon: Icons
                      .mail_outline_rounded,
                ),
              ),

              const SizedBox(height: 12),

              // ==================================
              // PASSWORD
              // ==================================

              TextFormField(
                controller:
                _passwordController,

                validator:
                _validatePassword,

                obscureText:
                _hidePassword,

                textInputAction:
                TextInputAction.next,

                autofillHints: const [
                  AutofillHints.newPassword,
                ],

                enabled: !_loading,

                style:
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.5,
                ),

                decoration:
                authInputDecoration(
                  hint: 'Create password',
                  icon:
                  Icons.lock_outline_rounded,

                  suffixIcon:
                  IconButton(
                    tooltip: _hidePassword
                        ? 'Show password'
                        : 'Hide password',

                    onPressed:
                    _loading
                        ? null
                        : () {
                      setState(() {
                        _hidePassword =
                        !_hidePassword;
                      });
                    },

                    icon: Icon(
                      _hidePassword
                          ? Icons
                          .visibility_off_outlined
                          : Icons
                          .visibility_outlined,
                      color:
                      Colors.white38,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 7),

              Align(
                alignment:
                Alignment.centerLeft,
                child: Text(
                  '8+ characters with uppercase, lowercase, number and symbol.',
                  style:
                  GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 10.5,
                    height: 1.35,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==================================
              // CONFIRM PASSWORD
              // ==================================

              TextFormField(
                controller:
                _confirmPasswordController,

                validator:
                _validateConfirmPassword,

                obscureText:
                _hideConfirmPassword,

                textInputAction:
                TextInputAction.done,

                autofillHints: const [
                  AutofillHints.newPassword,
                ],

                enabled: !_loading,

                style:
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.5,
                ),

                decoration:
                authInputDecoration(
                  hint: 'Confirm password',
                  icon: Icons
                      .verified_user_outlined,

                  suffixIcon:
                  IconButton(
                    tooltip:
                    _hideConfirmPassword
                        ? 'Show password'
                        : 'Hide password',

                    onPressed:
                    _loading
                        ? null
                        : () {
                      setState(() {
                        _hideConfirmPassword =
                        !_hideConfirmPassword;
                      });
                    },

                    icon: Icon(
                      _hideConfirmPassword
                          ? Icons
                          .visibility_off_outlined
                          : Icons
                          .visibility_outlined,
                      color:
                      Colors.white38,
                      size: 20,
                    ),
                  ),
                ),

                onFieldSubmitted: (_) {
                  _signUp();
                },
              ),

              const SizedBox(height: 12),

              // ==================================
              // TERMS
              // ==================================

              InkWell(
                borderRadius:
                BorderRadius.circular(12),

                onTap:
                _loading
                    ? null
                    : () {
                  setState(() {
                    _agree =
                    !_agree;
                  });
                },

                child: Padding(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    vertical: 4,
                  ),

                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,

                        child: Checkbox(
                          value: _agree,

                          activeColor:
                          AuthUi.gold,

                          checkColor:
                          Colors.black,

                          side: BorderSide(
                            color: Colors.white
                                .withValues(
                              alpha: .42,
                            ),
                          ),

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(5),
                          ),

                          onChanged:
                          _loading
                              ? null
                              : (value) {
                            setState(
                                  () {
                                _agree =
                                    value ??
                                        false;
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(
                        width: 9,
                      ),

                      Expanded(
                        child: Text(
                          'I agree to the Terms & Conditions and Privacy Policy.',
                          style:
                          GoogleFonts
                              .poppins(
                            color:
                            Colors.white60,
                            fontSize: 11.5,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==================================
              // CREATE ACCOUNT
              // ==================================

              AuthPrimaryButton(
                label: 'Create Account',
                loading: _loading,
                onPressed: _signUp,
              ),

              const SizedBox(height: 20),

              // ==================================
              // LOGIN
              // ==================================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [
                  Text(
                    'Already have an account? ',
                    style:
                    GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12.5,
                    ),
                  ),

                  GestureDetector(
                    onTap:
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
                      'Sign In',
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