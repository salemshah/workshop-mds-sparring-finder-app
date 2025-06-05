import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sparring_finder/src/utils/jwt.dart';

class ApiService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiService({
    required this.baseUrl,
    Map<String, String>? headers,
  }) : defaultHeaders = headers ?? {'Content-Type': 'application/json'};

  /// Helper to merge in the authorization token (if present).
  Future<Map<String, String>> _getHeaders() async {
    final token = await JwtStorageHelper.getAccessToken();
    return {
      ...defaultHeaders,
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Expose the auth headers (if you need them manually).
  Future<Map<String, String>> getAuthHeaders() async {
    return await _getHeaders();
  }

  /// GET request → always returns a decoded JSON Map.
  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);
    return _handleResponse(response);
  }

  /// POST request → always returns a decoded JSON Map.
  Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    // If you want to log the raw response body for debugging, uncomment:
    print('POST $endpoint → status ${response.statusCode}, body: ${response.body}');

    return _handleResponse(response);
  }

  /// PUT request → always returns a decoded JSON Map.
  Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    // Uncomment to debug:
    print('PUT $endpoint → status ${response.statusCode}, body: ${response.body}');

    return _handleResponse(response);
  }

  /// DELETE request → always returns a decoded JSON Map.
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);

    // Uncomment to debug:
    print('DELETE $endpoint → status ${response.statusCode}, body: ${response.body}');

    return _handleResponse(response);
  }

  /// For multipart uploads (if you use `http.MultipartRequest` elsewhere).
  Future<Map<String, dynamic>> handleMultipartResponse(
      http.StreamedResponse response) async {
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(responseBody) as Map<String, dynamic>;
      } catch (_) {
        throw Exception('Failed to parse JSON from multipart response');
      }
    } else {
      try {
        final errorData = jsonDecode(responseBody) as Map<String, dynamic>;
        final message = errorData['message'] ?? 'Unknown error';
        throw Exception('Error ${response.statusCode}: $message');
      } catch (_) {
        throw Exception('Error ${response.statusCode}: $responseBody');
      }
    }
  }

  /// Internal helper: decode `http.Response`, throw on non‐2xx.
  Map<String, dynamic> _handleResponse(http.Response response) {
    final status = response.statusCode;
    final bodyString = response.body;

    if (status >= 200 && status < 300) {
      try {
        return jsonDecode(bodyString) as Map<String, dynamic>;
      } catch (_) {
        // If the body was empty or not valid JSON, wrap in an exception
        throw Exception('Invalid JSON response: $bodyString');
      }
    } else {
      // Non‐success code: attempt to decode an error message
      try {
        final decoded = jsonDecode(bodyString) as Map<String, dynamic>;
        final msg = decoded['message'] ?? bodyString;
        throw Exception('Error $status: $msg');
      } catch (_) {
        throw Exception('Error $status: $bodyString');
      }
    }
  }
}
