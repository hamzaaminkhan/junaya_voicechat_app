import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  static const String _apiOverride = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const String _socketOverride = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: '',
  );

  /// Backend API base URL.
  ///
  /// Web:
  /// http://localhost:5000
  ///
  /// Android Emulator:
  /// http://10.0.2.2:5000
  ///
  /// Production / physical device:
  /// Pass URL using --dart-define.
  static String get apiBaseUrl {
    if (_apiOverride.isNotEmpty) {
      return _apiOverride;
    }

    if (kIsWeb) {
      return 'http://localhost:5000';
    }

    return 'http://10.0.2.2:5000';
  }

  /// Socket.IO uses the same Node.js server.
  static String get socketBaseUrl {
    if (_socketOverride.isNotEmpty) {
      return _socketOverride;
    }

    if (kIsWeb) {
      return 'http://localhost:5000';
    }

    return 'http://10.0.2.2:5000';
  }

  static String get apiUrl => '$apiBaseUrl/api';

  // Auth
  static String get loginUrl => '$apiUrl/auth/login';

  static String get registerUrl => '$apiUrl/auth/register';

  static String get meUrl => '$apiUrl/auth/me';

  static String get refreshUrl => '$apiUrl/auth/refresh';

  static String get logoutUrl => '$apiUrl/auth/logout';

  static String get verifyEmailUrl => '$apiUrl/auth/verify-email';

  static String get resendVerificationUrl =>
      '$apiUrl/auth/resend-verification';

  static String get forgotPasswordUrl =>
      '$apiUrl/auth/forgot-password';

  static String get resetPasswordUrl =>
      '$apiUrl/auth/reset-password';

  // Profile
  static String get profileUrl => '$apiUrl/profile';
}