import 'dart:convert';

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

/// Tries to extract a meaningful error message from an exception.
String parseErrorMessage(Object error) {
  // Convert the error to string.
  final errorStr = error.toString();

  // Find the start of a JSON structure.
  final jsonStart = errorStr.indexOf('{');
  if (jsonStart != -1) {
    try {
      final jsonString = errorStr.substring(jsonStart);
      final Map<String, dynamic> errorJson = jsonDecode(jsonString);
      // Return the 'message' field if available.
      if (errorJson.containsKey('message')) {
        return errorJson['message'];
      }
    } catch (_) {
      // If parsing fails, just fall back to errorStr.
    }
  }
  // Fallback: return the original error string.
  return errorStr;
}