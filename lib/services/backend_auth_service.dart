import 'package:dio/dio.dart';

import '../core/api/api_client.dart';
import '../core/storage/token_storage.dart';

class BackendAuthService {
  BackendAuthService._();

  static final BackendAuthService instance =
  BackendAuthService._();

  Dio get _dio => ApiClient.instance.dio;

  // ==========================================
  // REGISTER
  // ==========================================

  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: {
          'email': email.trim().toLowerCase(),
          'username': username.trim().toLowerCase(),
          'password': password,
        },
      );

      return Map<String, dynamic>.from(
        response.data as Map,
      );
    } on DioException catch (e) {
      throw Exception(
        _extractMessage(
          e,
          'Registration failed.',
        ),
      );
    }
  }

  // ==========================================
  // LOGIN
  // ==========================================

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
          'rememberMe': rememberMe,
        },
      );

      final data = Map<String, dynamic>.from(
        response.data as Map,
      );

      final accessToken =
      data['accessToken']?.toString();

      final refreshToken =
      data['refreshToken']?.toString();

      if (accessToken == null ||
          accessToken.isEmpty ||
          refreshToken == null ||
          refreshToken.isEmpty) {
        throw Exception(
          'Authentication tokens were not returned by the server.',
        );
      }

      await TokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      return data;
    } on DioException catch (e) {
      throw Exception(
        _extractMessage(
          e,
          'Login failed.',
        ),
      );
    }
  }

  // ==========================================
  // CURRENT USER
  // ==========================================

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get(
        '/api/auth/me',
      );

      final data = Map<String, dynamic>.from(
        response.data as Map,
      );

      final user = data['user'];

      if (user is! Map) {
        throw Exception(
          'Invalid user response from server.',
        );
      }

      return Map<String, dynamic>.from(user);
    } on DioException catch (e) {
      throw Exception(
        _extractMessage(
          e,
          'Unable to load account.',
        ),
      );
    }
  }

  // ==========================================
  // CHECK BACKEND LOGIN
  // ==========================================

  Future<bool> isLoggedIn() async {
    final refreshToken =
    await TokenStorage.getRefreshToken();

    if (refreshToken == null ||
        refreshToken.isEmpty) {
      return false;
    }

    try {
      await getCurrentUser();
      return true;
    } catch (_) {
      // api_client.dart will already attempt
      // token refresh on a 401.
      return false;
    }
  }

  // ==========================================
  // LOGOUT
  // ==========================================

  Future<void> logout() async {
    final refreshToken =
    await TokenStorage.getRefreshToken();

    try {
      if (refreshToken != null &&
          refreshToken.isNotEmpty) {
        await _dio.post(
          '/api/auth/logout',
          data: {
            'refreshToken': refreshToken,
          },
        );
      }
    } catch (_) {
      // Local logout must still succeed even
      // when backend/tunnel is unavailable.
    } finally {
      await TokenStorage.clearTokens();
    }
  }

  // ==========================================
  // ERROR MESSAGE
  // ==========================================

  String _extractMessage(
      DioException error,
      String fallback,
      ) {
    final data = error.response?.data;

    if (data is Map) {
      final message = data['message'];

      if (message != null &&
          message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }

    if (error.type ==
        DioExceptionType.connectionTimeout ||
        error.type ==
            DioExceptionType.receiveTimeout ||
        error.type ==
            DioExceptionType.sendTimeout) {
      return 'Connection timed out. Please try again.';
    }

    if (error.type ==
        DioExceptionType.connectionError) {
      return 'Unable to connect to the server.';
    }

    return fallback;
  }

  // ==========================================
// FORGOT PASSWORD
// ==========================================

  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      await _dio.post(
        '/api/auth/forgot-password',
        data: {
          'email': email.trim().toLowerCase(),
        },
      );
    } on DioException catch (e) {
      throw Exception(
        _extractMessage(
          e,
          'Unable to send password reset instructions.',
        ),
      );
    }
  }

  // ==========================================
// CHECK EMAIL VERIFICATION
// ==========================================

  Future<bool> isEmailVerified() async {
    try {
      final user = await getCurrentUser();

      return user['emailVerified'] == true;
    } on DioException catch (e) {
      throw Exception(
        _extractMessage(
          e,
          'Unable to check email verification.',
        ),
      );
    }
  }

// ==========================================
// RESEND EMAIL VERIFICATION
// ==========================================

  Future<void> resendVerificationEmail() async {
    try {
      await _dio.post(
        '/api/auth/resend-verification',
      );
    } on DioException catch (e) {
      throw Exception(
        _extractMessage(
          e,
          'Unable to resend verification email.',
        ),
      );
    }
  }

}