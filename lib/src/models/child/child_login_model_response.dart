import 'package:sparring_finder/src/models/child/child_model.dart';

class ChildLoginResponse {
  final ChildModel child;
  final String accessToken;
  final String refreshToken;

  ChildLoginResponse({
    required this.child,
    required this.accessToken,
    required this.refreshToken,
  });

  factory ChildLoginResponse.fromJson(Map<String, dynamic> json) {
    return ChildLoginResponse(
      child: ChildModel.fromJson(json['child']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'child': child.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
