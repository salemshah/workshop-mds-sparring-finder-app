import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final FlutterSecureStorage secureStorage;

  ApiService({
    required this.baseUrl,
    required this.secureStorage,
    Map<String, String>? headers,
  }) : defaultHeaders = headers ?? {"Content-Type": "application/json"};

  /// Retrieves headers by merging the default headers with the Authorization header (if available)
  Future<Map<String, String>> _getHeaders() async {
    final role = await secureStorage.read(key: 'role');
    String? token;

    if (role == 'parent') {
      token = await secureStorage.read(key: 'accessToken_parent');
    } else if (role == 'child') {
      token = await secureStorage.read(key: 'accessToken_child');
    }

    if (token == null || token.isEmpty) {
      return defaultHeaders;
    }

    return {
      ...defaultHeaders,
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
