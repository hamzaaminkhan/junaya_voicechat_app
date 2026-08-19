import '../config/app_config.dart';

class ApiEndpoints {
  static final String baseUrl = AppConfig.apiBaseUrl;

  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String me = '/api/auth/me';
  static const String refresh = '/api/auth/refresh';
  static const String logout = '/api/auth/logout';

  static const String profile = '/api/profile';
  static const String profileAvatar = '/api/profile/avatar';
}