import 'package:flutter/material.dart';

import '../screens/intro_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/phone_verification_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/home_screen.dart';


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