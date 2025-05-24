import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtStorageHelper {
  static final _storage = FlutterSecureStorage();

  static const accessTokenKey = 'accessTokenUser';
  static const refreshTokenKey = 'refreshTokenUser';

  /// Save access & refresh tokens and user role to secure storage
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: accessTokenKey, value: accessToken);
    await _storage.write(key: refreshTokenKey, value: refreshToken);
  }

  /// Get the access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: accessTokenKey);
  }

  /// Get the refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: refreshTokenKey);
  }

  static Future<Map<String, dynamic>> getDecodedAccessToken() async {
    final token = await getAccessToken();
    if (token == null) throw Exception('No access token found');
    return JwtDecoder.decode(token);
  }

  /// Check if the stored access token is expired
  static Future<bool> isTokenExpired() async {
    final token = await getAccessToken();
    if (token == null) return true;
    return JwtDecoder.isExpired(token);
  }

  /// Generic getter by key
  static Future<String?> getToken(String key) async {
    return await _storage.read(key: key);
  }

  /// Optional: clear all tokens
  static Future<void> clearTokens() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
  }
}
