import 'parent_model.dart';

class ParentLoginResponse {
  final String message;
  final String accessToken;
  final String refreshToken;
  final ParentModel parent;

  ParentLoginResponse({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.parent,
  });

  factory ParentLoginResponse.fromJson(Map<String, dynamic> json) {
    return ParentLoginResponse(
      message: json['message'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      parent: ParentModel.fromJson(json['parent'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'parent': parent.toJson(),
    };
  }
}
