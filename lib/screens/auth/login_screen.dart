import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/space_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ========================
  // Form Key
  // ========================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ========================
  // Controllers
  // ========================

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  // ========================
  // Focus Nodes
  // ========================

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // ========================
  // Services
  // ========================

  final AuthService _authService = AuthService.instance;

  // ========================
  // UI State
  // ========================

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // ========================
  // Lifecycle
  // ========================

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  // ========================
  // Validators
  // ========================

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email.';
    }

    const emailPattern =
        r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$";

    if (!RegExp(emailPattern).hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  }

  // ========================
  // Helper Methods
  // ========================

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  void _showSnackBar(
      String message, {
        Color? backgroundColor,
      }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _goToForgotPassword() {
    Navigator.pushNamed(
      context,
      AppRoutes.forgotPassword,
    );
  }

  void _goToSignup() {
    Navigator.pushNamed(
      context,
      AppRoutes.signup,
    );
  }

  // ========================
  // Login
  // ========================

  Future<void> _login() async {
    _dismissKeyboard();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final user = credential.user;

      if (user == null) {
        _showSnackBar(
          'Unable to sign in.',
          backgroundColor: Colors.red,
        );
        return;
      }

      if (!user.emailVerified) {
        _showSnackBar(
          'Please verify your email before signing in.',
          backgroundColor: Colors.orange,
        );

        Navigator.pushReplacementNamed(
          context,
          AppRoutes.emailVerification,
        );

        return;
      }

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.main,
      );
    } catch (e) {
      _showSnackBar(
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  // ========================
  // Header
  // ========================

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 8),

        Hero(
          tag: 'logo',
          child: Container(
            width: 82,
            height: 82,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.16),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(.11),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

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
      ],
    );
  }

  // ========================
  // Input Fields
  // ========================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        color: Colors.white38,
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFFFFC94D),
        size: 20,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.black.withOpacity(.14),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(.08),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(.10),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFFFC94D),
          width: 1.2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
      errorStyle: GoogleFonts.poppins(
        fontSize: 10.5,
        height: 1.2,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      validator: _validateEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [
        AutofillHints.email,
      ],
      enabled: !_isLoading,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 13.5,
      ),
      decoration: _inputDecoration(
        hint: 'Email address',
        icon: Icons.mail_outline_rounded,
      ),
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(
          _passwordFocusNode,
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      validator: _validatePassword,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [
        AutofillHints.password,
      ],
      enabled: !_isLoading,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 13.5,
      ),
      decoration: _inputDecoration(
        hint: 'Password',
        icon: Icons.lock_outline_rounded,
        suffixIcon: IconButton(
          onPressed: _togglePasswordVisibility,
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
    );
  }

  // ========================
  // Options
  // ========================

  Widget _buildOptionsRow() {
    return Row(
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: _rememberMe,
            activeColor: const Color(0xFFFFC94D),
            checkColor: Colors.black,
            side: BorderSide(
              color: Colors.white.withOpacity(.45),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            materialTapTargetSize:
            MaterialTapTargetSize.shrinkWrap,
            onChanged:
            _isLoading ? null : _toggleRememberMe,
          ),
        ),

        const SizedBox(width: 8),

        Text(
          'Remember me',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),

        const Spacer(),

        TextButton(
          onPressed:
          _isLoading ? null : _goToForgotPassword,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 5,
            ),
            tapTargetSize:
            MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Forgot password?',
            style: GoogleFonts.poppins(
              color: const Color(0xFFE66BFF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ========================
  // Login Button
  // ========================

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.2,
        color: Color(0xFF1D1021),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC83D),
          foregroundColor: const Color(0xFF170D18),
          disabledBackgroundColor:
          const Color(0xFFFFC83D).withOpacity(.65),
          disabledForegroundColor:
          const Color(0xFF170D18),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _isLoading
              ? _buildLoadingIndicator()
              : Text(
            'Sign In',
            key: const ValueKey('login_text'),
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  // ========================
  // Footer
  // ========================

  Widget _buildFooter() {
    return Row(
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
          onTap: _isLoading ? null : _goToSignup,
          child: Text(
            'Sign Up',
            style: GoogleFonts.poppins(
              color: const Color(0xFFFFC94D),
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ========================
  // Build
  // ========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SpaceBackground(
        child: SafeArea(
          child: GestureDetector(
            onTap: _dismissKeyboard,
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                autovalidateMode:
                AutovalidateMode.onUserInteraction,
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      22,
                      16,
                      22,
                      24,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 430,
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(
                          18,
                          18,
                          18,
                          20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.10),
                          borderRadius:
                          BorderRadius.circular(22),
                          border: Border.all(
                            color:
                            Colors.white.withOpacity(.08),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildHeader(),
                            _buildEmailField(),
                            const SizedBox(height: 13),
                            _buildPasswordField(),
                            const SizedBox(height: 12),
                            _buildOptionsRow(),
                            const SizedBox(height: 22),
                            _buildLoginButton(),
                            const SizedBox(height: 22),
                            _buildFooter(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
