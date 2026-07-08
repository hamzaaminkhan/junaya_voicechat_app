import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../screens/splash/intro_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/phone_verification_screen.dart';
import '../screens/auth/otp_screen.dart';


class AppRoutes {
  static const intro = "/";
  static const login = "/login";
  static const signup = "/signup";
  static const forgotPassword = "/forgotPassword";
  static const phoneVerification = "/phoneVerification";
  static const otp = "/otp";
  static const home = "/home";

  static Map<String, WidgetBuilder> routes = {
    intro: (_) => const IntroScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    phoneVerification: (_) => const PhoneVerificationScreen(),
    otp: (_) => const OtpScreen(),
    home: (_) => const HomeScreen(),
  };
}