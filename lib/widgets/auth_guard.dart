import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/screens/auth/email_verification.dart';
import 'package:junaya_voicechat_app/screens/auth/login_screen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user == null) {
          return const LoginScreen();
        }

        if (user.email != null && !user.emailVerified) {
          return const VerifyEmailScreen();
        }

        return child;
      },
    );
  }
}
