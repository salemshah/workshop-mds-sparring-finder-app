import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final storage = FlutterSecureStorage();

Future<bool> isTokenExpired() async {
  final token = await getAccessToken();
  return JwtDecoder.isExpired(token!);
}

Future<String?> getAccessToken() async {
  final token = await storage.read(key: 'accessTokenUser');
  return token;
}


Future<String?> getToken(String key) async {
  return await storage.read(key: key);
}
