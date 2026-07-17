import 'package:flutter/material.dart';

import '../screens/auth/email_verification.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/phone_verification_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/splash/welcome_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String intro = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String phoneVerification = '/phoneVerification';
  static const String otp = '/otp';
  static const String emailVerification = '/emailVerification';
  static const String home = '/home';

  static final Map<String, WidgetBuilder> routes = {
    intro: (_) => const IntroScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    phoneVerification: (_) => const PhoneVerificationScreen(),
    otp: (_) => const OtpScreen(),
    emailVerification: (_) => const VerifyEmailScreen(),
    home: (_) => const HomeScreen(),
  };
}