import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  late final Dio dio;

  bool _isRefreshing = false;

  Future<void>? _refreshFuture;

  void initialize() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(

        // ======================================
        // BEFORE REQUEST
        // ======================================

        onRequest: (
            RequestOptions options,
            RequestInterceptorHandler handler,
            ) async {
          final accessToken =
          await TokenStorage.getAccessToken();

          if (accessToken != null &&
              accessToken.isNotEmpty) {
            options.headers['Authorization'] =
            'Bearer $accessToken';
          }

          handler.next(options);
        },

        // ======================================
        // RESPONSE
        // ======================================

        onResponse: (
            Response response,
            ResponseInterceptorHandler handler,
            ) {
          handler.next(response);
        },

        // ======================================
        // ERROR
        // ======================================

        onError: (
            DioException error,
            ErrorInterceptorHandler handler,
            ) async {
          final statusCode =
              error.response?.statusCode;

          final requestOptions =
              error.requestOptions;

          // Prevent infinite retry loop
          final alreadyRetried =
              requestOptions.extra['retried'] ==
                  true;

          if (statusCode != 401 ||
              alreadyRetried) {
            return handler.next(error);
          }

          final refreshToken =
          await TokenStorage.getRefreshToken();

          if (refreshToken == null ||
              refreshToken.isEmpty) {
            await TokenStorage.clearTokens();

            return handler.next(error);
          }

          try {
            await _refreshAccessToken();

            final newAccessToken =
            await TokenStorage.getAccessToken();

            if (newAccessToken == null ||
                newAccessToken.isEmpty) {
              await TokenStorage.clearTokens();

              return handler.next(error);
            }

            requestOptions.extra['retried'] =
            true;

            requestOptions.headers[
            'Authorization'] =
            'Bearer $newAccessToken';

            final response =
            await dio.fetch(
              requestOptions,
            );

            return handler.resolve(response);
          } catch (_) {
            await TokenStorage.clearTokens();

            return handler.next(error);
          }
        },
      ),
    );
  }

  // ==========================================
  // REFRESH ACCESS TOKEN
  // ==========================================

  Future<void> _refreshAccessToken() async {
    if (_isRefreshing) {
      if (_refreshFuture != null) {
        await _refreshFuture;
      }

      return;
    }

    _isRefreshing = true;

    _refreshFuture = _performRefresh();

    try {
      await _refreshFuture;
    } finally {
      _isRefreshing = false;
      _refreshFuture = null;
    }
  }

  // ==========================================
  // PERFORM REFRESH
  // ==========================================

  Future<void> _performRefresh() async {
    final refreshToken =
    await TokenStorage.getRefreshToken();

    if (refreshToken == null ||
        refreshToken.isEmpty) {
      throw Exception(
        'Refresh token not found',
      );
    }

    // Separate Dio prevents interceptor loop
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout:
        const Duration(seconds: 15),
        receiveTimeout:
        const Duration(seconds: 15),
        headers: {
          'Content-Type':
          'application/json',
          'Accept':
          'application/json',
        },
      ),
    );

    final response = await refreshDio.post(
      '/api/auth/refresh',
      data: {
        'refreshToken': refreshToken,
      },
    );

    final data = response.data;

    if (data == null) {
      throw Exception(
        'Invalid refresh response',
      );
    }

    final newAccessToken =
    data['accessToken'];

    final newRefreshToken =
    data['refreshToken'];

    if (newAccessToken == null ||
        newRefreshToken == null) {
      throw Exception(
        'New tokens missing',
      );
    }

    await TokenStorage.saveTokens(
      accessToken:
      newAccessToken.toString(),
      refreshToken:
      newRefreshToken.toString(),
    );
  }
}