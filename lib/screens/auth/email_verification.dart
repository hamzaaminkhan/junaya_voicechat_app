import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes/app_routes.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() =>
      _VerifyEmailScreenState();
}

class _VerifyEmailScreenState
    extends State<VerifyEmailScreen> {

bool loading = false;
bool resendLoading = false;

bool canResend = false;
int cooldown = 60;

Timer? _verificationTimer;
Timer? _cooldownTimer;

@override
void initState() {
super.initState();

startCooldown();
startVerificationCheck();
}

void startVerificationCheck() {
_verificationTimer = Timer.periodic(
const Duration(seconds: 3),
(_) async {
await FirebaseAuth.instance.currentUser?.reload();

final user = FirebaseAuth.instance.currentUser;

if (user != null && user.emailVerified) {
_verificationTimer?.cancel();

if (!mounted) return;

Navigator.pushNamedAndRemoveUntil(
context,
AppRoutes.home,
(route) => false,
);
}
},
);
}

void startCooldown() {
cooldown = 60;
canResend = false;

_cooldownTimer?.cancel();

_cooldownTimer = Timer.periodic(
const Duration(seconds: 1),
(timer) {
if (!mounted) {
timer.cancel();
return;
}

if (cooldown <= 0) {
timer.cancel();

setState(() {
canResend = true;
});

return;
}

setState(() {
cooldown--;
});
},
);
}

Future<void> checkVerification() async {
setState(() => loading = true);

try {
await FirebaseAuth.instance.currentUser?.reload();

final user = FirebaseAuth.instance.currentUser;

if (!mounted) return;

if (user != null && user.emailVerified) {
Navigator.pushNamedAndRemoveUntil(
context,
AppRoutes.home,
(route) => false,
);
} else {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
"Your email has not been verified yet.",
),
),
);
}
} finally {
if (mounted) {
setState(() => loading = false);
}
}
}
Future<void> resendVerificationEmail() async {
if (!canResend) return;

setState(() => resendLoading = true);

try {
await FirebaseAuth.instance.currentUser
?.sendEmailVerification();

startCooldown();

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
"Verification email sent successfully.",
),
),
);
} on FirebaseAuthException catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
e.message ??
"Unable to send verification email.",
),
),
);
} finally {
if (mounted) {
setState(() => resendLoading = false);
}
}
}

Future<void> openEmailApp() async {
final uri = Uri(
scheme: "mailto",
);

if (await canLaunchUrl(uri)) {
await launchUrl(uri);
} else {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
"No email application found.",
),
),
);
}
}

Future<void> logout() async {
await FirebaseAuth.instance.signOut();

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
final email =
FirebaseAuth.instance.currentUser?.email ??
"No email found";

return Scaffold(
backgroundColor: const Color(0xFF050816),
body: SafeArea(
child: LayoutBuilder(
builder: (context, constraints) {
return SingleChildScrollView(
child: ConstrainedBox(
constraints: BoxConstraints(
minHeight: constraints.maxHeight,
),
child: IntrinsicHeight(
child: Column(
children: [
  const SizedBox(height: 40),
  
  Image.asset(
  "assets/logo.png",
  height: 120,
  ),
  
  const SizedBox(height: 35),
  
  const Text(
  "Verify Your Email",
  textAlign: TextAlign.center,
  style: TextStyle(
  color: Colors.white,
  fontSize: 30,
  fontWeight: FontWeight.bold,
  ),
  ),
  
  const SizedBox(height: 20),
  
  const Text(
  "We've sent a verification email to",
  textAlign: TextAlign.center,
  style: TextStyle(
  color: Colors.white70,
  fontSize: 16,
  ),
  ),
  
  const SizedBox(height: 10),
  
  Text(
  email,
  textAlign: TextAlign.center,
  style: const TextStyle(
  color: Colors.amber,
  fontSize: 18,
  fontWeight: FontWeight.w600,
  ),
  ),
  
  const SizedBox(height: 25),
  
  const Text(
  "Open your email, click the verification link, then return to the app. We'll automatically detect when your account has been verified.",
  textAlign: TextAlign.center,
  style: TextStyle(
  color: Colors.white60,
  fontSize: 15,
  height: 1.5,
  ),
  ),
  
  const Spacer(),
    SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Colors.amber,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: openEmailApp,
        icon: const Icon(
          Icons.email_outlined,
          color: Colors.amber,
        ),
        label: const Text(
          "Open Email App",
          style: TextStyle(
            color: Colors.amber,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  
    const SizedBox(height: 16),
  
    SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF21B72),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: loading
            ? null
            : checkVerification,
        child: loading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white,
          ),
        )
            : const Text(
          "I've Verified",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  
    const SizedBox(height: 16),
  
    SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Colors.amber,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: (!canResend || resendLoading)
            ? null
            : resendVerificationEmail,
        child: resendLoading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.amber,
          ),
        )
            : Text(
          canResend
              ? "Resend Email"
              : "Resend in ${cooldown}s",
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  
    const SizedBox(height: 20),
  
    TextButton.icon(
      onPressed: logout,
      icon: const Icon(
        Icons.logout,
        color: Colors.redAccent,
      ),
      label: const Text(
        "Logout",
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  
    const SizedBox(height: 35),
],
),
),
),
);
},
),
),
);
}
}