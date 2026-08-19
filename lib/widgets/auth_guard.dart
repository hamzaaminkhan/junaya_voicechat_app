import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth/email_verification.dart';
import '../screens/auth/login_screen.dart';
import '../services/backend_auth_service.dart';
import '../core/storage/token_storage.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  State<AuthGuard> createState() =>
      _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  late Future<_GuardState> _guardFuture;

  @override
  void initState() {
    super.initState();
    _guardFuture = _resolve();
  }

  Future<_GuardState> _resolve() async {
    final hasBackendTokens =
    await TokenStorage.hasTokens();

    if (hasBackendTokens) {
      try {
        final user = await BackendAuthService
            .instance
            .getCurrentUser();

        return user['emailVerified'] == true
            ? _GuardState.allowed
            : _GuardState.emailVerification;
      } catch (_) {
        return _GuardState.login;
      }
    }

    // Temporary compatibility for the existing Firebase phone-login flow.
    // Remove this fallback after phone auth is exchanged for backend JWTs.
    final firebaseUser =
        FirebaseAuth.instance.currentUser;

    if (firebaseUser != null &&
        (firebaseUser.phoneNumber?.isNotEmpty ??
            false)) {
      return _GuardState.allowed;
    }

    return _GuardState.login;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_GuardState>(
      future: _guardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState !=
            ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        switch (snapshot.data) {
          case _GuardState.allowed:
            return widget.child;
          case _GuardState.emailVerification:
            return const VerifyEmailScreen();
          case _GuardState.login:
          case null:
            return const LoginScreen();
        }
      },
    );
  }
}

enum _GuardState {
  allowed,
  emailVerification,
  login,
}
