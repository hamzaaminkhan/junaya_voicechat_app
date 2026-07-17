import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:junaya_voicechat_app/screens/auth/forgot_password_screen.dart';
import 'package:junaya_voicechat_app/screens/auth/login_screen.dart';
import 'package:junaya_voicechat_app/screens/auth/signup_screen.dart';
import 'package:junaya_voicechat_app/screens/home/home_screen.dart';
import 'package:junaya_voicechat_app/screens/splash/splash_screen.dart';
import 'package:junaya_voicechat_app/screens/splash/welcome_screen.dart';
import 'package:junaya_voicechat_app/screens/auth/email_verification.dart';
import 'package:junaya_voicechat_app/services/firebase_options.dart';
import 'package:junaya_voicechat_app/routes/app_routes.dart';
import 'package:junaya_voicechat_app/theme/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const JunayaApp());
}

class JunayaApp extends StatelessWidget {
  const JunayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      routes: {
        AppRoutes.intro: (_) => const IntroScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.signup: (_) => const SignupScreen(),
        AppRoutes.emailVerification: (_) => const VerifyEmailScreen(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
      },
    );
  }
}