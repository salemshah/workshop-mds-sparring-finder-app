import 'package:sparring_finder/src/models/user/user_model.dart';

class UserLoginResponse {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  UserLoginResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
      user: UserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
