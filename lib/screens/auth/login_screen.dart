import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool rememberMe = false;
  bool loading = false;

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email";
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Minimum 8 characters";
    }

    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case "user-not-found":
          message = "No account found with this email.";
          break;

        case "wrong-password":
          message = "Incorrect password.";
          break;

        case "invalid-email":
          message = "Invalid email address.";
          break;

        case "invalid-credential":
          message = "Invalid email or password.";
          break;

        case "network-request-failed":
          message = "No internet connection.";
          break;

        default:
          message = e.message ?? "Login failed.";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF050816),
body: SafeArea(
child: Form(
key: _formKey,
autovalidateMode: AutovalidateMode.onUserInteraction,
child: ListView(
padding: const EdgeInsets.symmetric(
horizontal: 24,
vertical: 20,
),
children: [
const SizedBox(height: 20),

Center(
child: Image.asset(
"assets/logo.png",
height: 90,
),
),

const SizedBox(height: 40),

const Align(
alignment: Alignment.centerLeft,
child: Text(
"Sign In",
style: TextStyle(
color: Colors.white,
fontSize: 32,
fontWeight: FontWeight.bold,
),
),
),

const SizedBox(height: 30),

CustomTextField(
controller: emailController,
hint: "Email Address",
prefixIcon: Icons.email_outlined,
keyboardType: TextInputType.emailAddress,
textInputAction: TextInputAction.next,
validator: validateEmail,
),

const SizedBox(height: 18),

CustomTextField(
controller: passwordController,
hint: "Password",
prefixIcon: Icons.lock_outline,
isPassword: true,
obscureText: hidePassword,
validator: validatePassword,
textInputAction: TextInputAction.done,
onSubmitted: (_) => login(),
onTogglePassword: () {
setState(() {
hidePassword = !hidePassword;
});
},
),

const SizedBox(height: 12),

Row(
children: [
Checkbox(
value: rememberMe,
activeColor: Colors.amber,
onChanged: (value) {
setState(() {
rememberMe = value ?? false;
});
},
),

const Text(
"Remember me",
style: TextStyle(
color: Colors.white,
),
),

const Spacer(),

TextButton(
onPressed: () {
Navigator.pushNamed(
context,
AppRoutes.forgotPassword,
);
},
child: const Text(
"Forgot Password?",
style: TextStyle(
color: Colors.purpleAccent,
),
),
),
],
),

const SizedBox(height: 20),

SizedBox(
width: double.infinity,
height: 55,
child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFF31C79),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(30),
),
),
onPressed: loading ? null : login,
child: loading
? const SizedBox(
height: 24,
width: 24,
child: CircularProgressIndicator(
strokeWidth: 2.5,
color: Colors.white,
),
)
: const Text(
"Sign In",
style: TextStyle(
fontSize: 18,
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
),
),

const SizedBox(height: 35),

  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Don't have an account? ",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.signup,
          );
        },
        child: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.purpleAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),

  const SizedBox(height: 30),
],
),
),
),
);
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final VoidCallback? onTogglePassword;
  final ValueChanged<String>? onSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onTogglePassword,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.amber,
        ),
        suffixIcon: isPassword
            ? IconButton(
          onPressed: onTogglePassword,
          icon: Icon(
            obscureText
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.white54,
          ),
        )
            : null,
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
    );
  }
}