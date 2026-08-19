import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
          'username': username.trim(),
          'password': password,
        },
      );

      final data = Map<String, dynamic>.from(
        response.data as Map,
      );

      // The backend registration contract returns JWT tokens so the
      // unverified user can access /me and resend-verification.
      final accessToken = data['accessToken']?.toString();
      final refreshToken = data['refreshToken']?.toString();

      if (accessToken != null &&
          accessToken.isNotEmpty &&
          refreshToken != null &&
          refreshToken.isNotEmpty) {
        await TokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }

      return data;
    } on DioException catch (e) {
      debugPrint(
        'REGISTER ${e.response?.statusCode}: ${e.response?.data}',
      );

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

  Future<Map<String, dynamic>>
  getCurrentUser() async {
    try {
      final response = await _dio.get(
        '/api/auth/me',
      );

      final data =
      Map<String, dynamic>.from(
        response.data as Map,
      );

      final user = data['user'];

      if (user is! Map) {
        throw Exception(
          'Invalid user response from server.',
        );
      }

      return Map<String, dynamic>.from(
        user,
      );
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
  // CHECK LOGIN
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
      return false;
    }
  }

  // ==========================================
  // CHECK EMAIL VERIFICATION
  // ==========================================

  Future<bool> isEmailVerified() async {
    final user = await getCurrentUser();

    return user['emailVerified'] == true;
  }

  // ==========================================
  // RESEND EMAIL VERIFICATION
  // ==========================================

  Future<void>
  resendVerificationEmail() async {
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
          'email':
          email.trim().toLowerCase(),
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
  // RESET PASSWORD
  // ==========================================

  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    final cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      throw Exception(
        'Password reset token is missing.',
      );
    }

    if (password.length < 8) {
      throw Exception(
        'Password must be at least 8 characters.',
      );
    }

    try {
      await _dio.post(
        '/api/auth/reset-password',
        data: {
          'token': cleanToken,
          'password': password,
        },
      );
    } on DioException catch (e) {
      throw Exception(
        _extractMessage(
          e,
          'Unable to reset password.',
        ),
      );
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
            'refreshToken':
            refreshToken,
          },
        );
      }
    } catch (_) {
      // Local logout must still succeed
      // if backend is unavailable.
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
      final message =
          data['message'] ??
              data['error'] ??
              data['detail'];

      if (message != null &&
          message
              .toString()
              .trim()
              .isNotEmpty) {
        return message.toString();
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      final clean = data.trim();

      // Avoid dumping an entire HTML error page into the UI.
      if (!clean.toLowerCase().contains('<html') &&
          !clean.toLowerCase().contains('<!doctype')) {
        return clean.length > 220
            ? '${clean.substring(0, 220)}...'
            : clean;
      }
    }

    if (error.type ==
        DioExceptionType
            .connectionTimeout ||
        error.type ==
            DioExceptionType
                .receiveTimeout ||
        error.type ==
            DioExceptionType
                .sendTimeout) {
      return 'Connection timed out. Please try again.';
    }

    if (error.type ==
        DioExceptionType.connectionError) {
      return 'Unable to connect to the server.';
    }

    return fallback;
  }
}