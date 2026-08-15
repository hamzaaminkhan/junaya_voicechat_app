import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage._();

  static const FlutterSecureStorage _storage =
  FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // ==========================================
  // SAVE TOKENS
  // ==========================================

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(
      key: _accessTokenKey,
      value: accessToken,
    );

    await _storage.write(
      key: _refreshTokenKey,
      value: refreshToken,
    );
  }

  // ==========================================
  // SAVE ACCESS TOKEN
  // ==========================================

  static Future<void> saveAccessToken(
      String accessToken,
      ) async {
    await _storage.write(
      key: _accessTokenKey,
      value: accessToken,
    );
  }

  // ==========================================
  // SAVE REFRESH TOKEN
  // ==========================================

  static Future<void> saveRefreshToken(
      String refreshToken,
      ) async {
    await _storage.write(
      key: _refreshTokenKey,
      value: refreshToken,
    );
  }

  // ==========================================
  // GET ACCESS TOKEN
  // ==========================================

  static Future<String?> getAccessToken() async {
    return _storage.read(
      key: _accessTokenKey,
    );
  }

  // ==========================================
  // GET REFRESH TOKEN
  // ==========================================

  static Future<String?> getRefreshToken() async {
    return _storage.read(
      key: _refreshTokenKey,
    );
  }

  // ==========================================
  // CLEAR TOKENS
  // ==========================================

  static Future<void> clearTokens() async {
    await _storage.delete(
      key: _accessTokenKey,
    );

    await _storage.delete(
      key: _refreshTokenKey,
    );
  }

  // ==========================================
  // CHECK LOGIN
  // ==========================================

  static Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    return accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;
  }
}