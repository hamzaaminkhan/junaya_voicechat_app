import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/widgets/auth_guard.dart';

import '../screens/auth/email_verification.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/phone_verification_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/chat/chat_list_screen.dart';
import '../screens/friends/friends_screen.dart';
import '../screens/gifts/gifts_screen.dart';
import '../screens/home/profile/profile_screen.dart';
import '../screens/home/profile/sections/cp_zone_screen.dart';
import '../screens/home/profile/sections/help_center_screen.dart';
import '../screens/home/profile/sections/join_agency_screen.dart';
import '../screens/home/profile/sections/language_screen.dart';
import '../screens/home/profile/sections/level_screen.dart';
import '../screens/home/profile/sections/medal_screen.dart';
import '../screens/home/rooms/room_screen.dart';
import '../screens/home/wallet_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/splash/welcome_screen.dart';
import '../screens/vip/vip_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String phoneVerification = '/phoneVerification';
  static const String otp = '/otp';
  static const String emailVerification = '/emailVerification';

  // MAIN APP
  static const String home = '/home';
  static const String room = '/room';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String vip = '/vip';
  static const String main = '/main';

  // PROFILE SECTIONS
  static const String wallet = '/profile/wallet';
  static const String store = '/profile/store';
  static const String inviteFriends = '/profile/invite-friends';
  static const String joinAgency = '/profile/join-agency';
  static const String level = '/profile/level';
  static const String medal = '/profile/medal';
  static const String cpZone = '/profile/cp-zone';
  static const String settings = '/profile/settings';
  static const String language = '/profile/language';
  static const String helpCenter = '/profile/help-center';

  static Widget _protected(Widget child) => AuthGuard(child: child);

  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    intro: (_) => const IntroScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    phoneVerification: (_) => const PhoneVerificationScreen(),
    otp: (_) => const OtpScreen(),
    emailVerification: (_) => const VerifyEmailScreen(),

    home: (_) => _protected(const MainScreen()),
    room: (_) => _protected(const RoomScreen()),
    chat: (_) => _protected(const ChatListScreen()),
    profile: (_) => _protected(const ProfileScreen()),
    vip: (_) => _protected(const VipScreen()),
    main: (_) => _protected(const MainScreen()),

    wallet: (_) => _protected(const WalletScreen()),
    store: (_) => _protected(const GiftsScreen()),
    inviteFriends: (_) => _protected(const FriendsScreen()),
    joinAgency: (_) => _protected(const JoinAgencyScreen()),
    level: (_) => _protected(const LevelScreen()),
    medal: (_) => _protected(const MedalScreen()),
    cpZone: (_) => _protected(const CpZoneScreen()),
    settings: (_) => _protected(const SettingsScreen()),
    language: (_) => _protected(const LanguageScreen()),
    helpCenter: (_) => _protected(const HelpCenterScreen()),
  };
}
