import 'package:flutter/material.dart';

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
import '../screens/splash/welcome_screen.dart';
import '../screens/vip/vip_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String intro = '/';
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

  static final Map<String, WidgetBuilder> routes = {
    intro: (_) => const IntroScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    phoneVerification: (_) => const PhoneVerificationScreen(),
    otp: (_) => const OtpScreen(),
    emailVerification: (_) => const VerifyEmailScreen(),

    home: (_) => const MainScreen(),
    room: (_) => const RoomScreen(),
    chat: (_) => const ChatListScreen(),
    profile: (_) => const ProfileScreen(),
    vip: (_) => const VipScreen(),
    main: (_) => const MainScreen(),

    wallet: (_) => const WalletScreen(),
    store: (_) => const GiftsScreen(),
    inviteFriends: (_) => const FriendsScreen(),
    joinAgency: (_) => const JoinAgencyScreen(),
    level: (_) => const LevelScreen(),
    medal: (_) => const MedalScreen(),
    cpZone: (_) => const CpZoneScreen(),
    settings: (_) => const SettingsScreen(),
    language: (_) => const LanguageScreen(),
    helpCenter: (_) => const HelpCenterScreen(),
  };
}