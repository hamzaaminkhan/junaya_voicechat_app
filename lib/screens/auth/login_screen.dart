import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//========================
// Form Key
//========================

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//========================
// Controllers
//========================

final TextEditingController _emailController =
TextEditingController();

final TextEditingController _passwordController =
TextEditingController();

//========================
// Focus Nodes
//========================

final FocusNode _emailFocusNode = FocusNode();

final FocusNode _passwordFocusNode = FocusNode();

//========================
// Services
//========================

final AuthService _authService = AuthService.instance;

//========================
// UI State
//========================

bool _isLoading = false;

bool _obscurePassword = true;

bool _rememberMe = false;

//========================
// Lifecycle
//========================

@override
void dispose() {
_emailController.dispose();
_passwordController.dispose();

_emailFocusNode.dispose();
_passwordFocusNode.dispose();

super.dispose();
}
//========================
// Validators
//========================

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

//========================
// Helper Methods
//========================

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

//========================
// Login
//========================

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
AppRoutes.home,
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

//========================
// Header Widgets
//========================

Widget _buildLogo() {
return Center(
child: Image.asset(
'assets/logo.png',
height: 90,
fit: BoxFit.contain,
),
);
}

Widget _buildTitle() {
return const Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Welcome Back',
style: TextStyle(
color: Colors.white,
fontSize: 32,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 8),
Text(
'Sign in to continue to JUNAYA.',
style: TextStyle(
color: Colors.white70,
fontSize: 15,
),
),
],
);
}

Widget _buildHeader() {
return Column(
children: [
const SizedBox(height: 20),

_buildLogo(),

const SizedBox(height: 40),

Align(
alignment: Alignment.centerLeft,
child: _buildTitle(),
),

const SizedBox(height: 32),
],
);
}

//========================
// Input Fields
//========================

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
style: const TextStyle(
color: Colors.white,
),
decoration: InputDecoration(
hintText: 'Email Address',
hintStyle: const TextStyle(
color: Colors.white54,
),
prefixIcon: const Icon(
Icons.email_outlined,
color: Colors.amber,
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
borderSide: const BorderSide(
color: Colors.amber,
width: 2,
),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
borderSide: const BorderSide(
color: Colors.amber,
width: 2,
),
),
errorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
borderSide: const BorderSide(
color: Colors.red,
width: 2,
),
),
focusedErrorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
borderSide: const BorderSide(
color: Colors.red,
width: 2,
),
),
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
style: const TextStyle(
color: Colors.white,
),
decoration: InputDecoration(
hintText: 'Password',
hintStyle: const TextStyle(
color: Colors.white54,
),
prefixIcon: const Icon(
Icons.lock_outline,
color: Colors.amber,
),
suffixIcon: IconButton(
onPressed: _togglePasswordVisibility,
icon: Icon(
_obscurePassword
? Icons.visibility_off
: Icons.visibility,
color: Colors.white54,
),
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
borderSide: const BorderSide(
color: Colors.amber,
width: 2,
),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
borderSide: const BorderSide(
color: Colors.amber,
width: 2,
),
),
errorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
borderSide: const BorderSide(
color: Colors.red,
width: 2,
),
),
focusedErrorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
borderSide: const BorderSide(
color: Colors.red,
width: 2,
),
),
),
onFieldSubmitted: (_) => _login(),
);
}
//========================
// Options
//========================

Widget _buildRememberMeSection() {
return Row(
children: [
Checkbox(
value: _rememberMe,
activeColor: Colors.amber,
materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
onChanged: _isLoading ? null : _toggleRememberMe,
),
const Text(
'Remember me',
style: TextStyle(
color: Colors.white,
fontSize: 15,
),
),
],
);
}

Widget _buildForgotPasswordButton() {
return TextButton(
onPressed: _isLoading ? null : _goToForgotPassword,
child: const Text(
'Forgot Password?',
style: TextStyle(
color: Colors.purpleAccent,
fontWeight: FontWeight.w600,
),
),
);
}

Widget _buildOptionsRow() {
return Row(
children: [
Expanded(
child: _buildRememberMeSection(),
),
_buildForgotPasswordButton(),
],
);
}

//========================
// Login Button
//========================

Widget _buildLoadingIndicator() {
return const SizedBox(
height: 22,
width: 22,
child: CircularProgressIndicator(
strokeWidth: 2.5,
color: Colors.white,
),
);
}

Widget _buildLoginButton() {
return SizedBox(
width: double.infinity,
height: 56,
child: ElevatedButton(
onPressed: _isLoading ? null : _login,
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFF31C79),
foregroundColor: Colors.white,
disabledBackgroundColor: const Color(0xFFF31C79),
disabledForegroundColor: Colors.white,
elevation: 0,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(30),
),
),
child: AnimatedSwitcher(
duration: const Duration(milliseconds: 250),
child: _isLoading
? _buildLoadingIndicator()
: const Text(
'Sign In',
key: ValueKey('login_text'),
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.w600,
),
),
),
),
);
}
  //========================
  // Footer
  //========================

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        GestureDetector(
          onTap: _isLoading ? null : _goToSignup,
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  //========================
  // Build
  //========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: SafeArea(
        child: AutofillGroup(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              children: [
                _buildHeader(),

                _buildEmailField(),

                const SizedBox(height: 18),

                _buildPasswordField(),

                const SizedBox(height: 12),

                _buildOptionsRow(),

                const SizedBox(height: 24),

                _buildLoginButton(),

                const SizedBox(height: 36),

                _buildFooter(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}