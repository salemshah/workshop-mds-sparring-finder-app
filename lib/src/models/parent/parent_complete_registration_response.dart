import 'parent_model.dart';

class ParentCompleteRegistrationResponse {
  final String message;
  final ParentModel parent;

  ParentCompleteRegistrationResponse({
    required this.message,
    required this.parent,
  });

  factory ParentCompleteRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return ParentCompleteRegistrationResponse(
      message: json['message'] as String,
      parent: ParentModel.fromJson(json['parent'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'parent': parent.toJson(),
    };
  }
}
