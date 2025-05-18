import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sparring_finder/src/utils/jwt.dart';

class ApiService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiService({
    required this.baseUrl,
    Map<String, String>? headers,
  }) : defaultHeaders = headers ?? {"Content-Type": "application/json"};

  /// Unified header resolver
  Future<Map<String, String>> _getHeaders() async {
    final token = await JwtStorageHelper.getAccessToken();

    return {
      ...defaultHeaders,
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> getAuthHeaders() async {
    return await _getHeaders();
  }

  /// GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);
    return _handleResponse(response);
  }

  /// POST request
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

  /// PUT request
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

  /// DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);
    return _handleResponse(response);
  }

  /// Multipart handler
  Future<Map<String, dynamic>> handleMultipartResponse(http.StreamedResponse response) async {
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(responseBody);
      } catch (_) {
        throw Exception('Failed to parse JSON from multipart response');
      }
    } else {
      try {
        final errorData = jsonDecode(responseBody);
        final message = errorData['message'] ?? 'Unknown error';
        throw Exception('Error ${response.statusCode}: $message');
      } catch (_) {
        throw Exception('Error ${response.statusCode}: $responseBody');
      }
    }
  }

  /// JSON response handler
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
