import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const _storage = FlutterSecureStorage();

  static const _keyLastFcmToken = 'last_fcm_token';
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyHasSeenOnboarding = 'has_seen_onboarding';

  // 🔹 LAST FCM TOKEN
  static Future<void> saveLastFcmToken(String token) async {
    await _storage.write(key: _keyLastFcmToken, value: token);
  }

  static Future<String?> getLastFcmToken() async {
    return await _storage.read(key: _keyLastFcmToken);
  }

  static Future<void> deleteLastFcmToken() async {
    await _storage.delete(key: _keyLastFcmToken);
  }

  // 🔹 ACCESS TOKEN
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _keyAccessToken, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  static Future<void> deleteAccessToken() async {
    await _storage.delete(key: _keyAccessToken);
  }

  // 🔹 REFRESH TOKEN
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
  }

  // 🔹 ONBOARDING
  static Future<void> markOnboardingSeen() async {
    await _storage.write(key: _keyHasSeenOnboarding, value: 'true');
  }

  static Future<bool> hasSeenOnboarding() async {
    final result = await _storage.read(key: _keyHasSeenOnboarding);
    return result == 'true';
  }

  // 🔹 CLEAR ALL (e.g., on logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
