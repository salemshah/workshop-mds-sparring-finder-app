import 'package:sparring_finder/src/models/profile/profile_model.dart';

class ProfileResponse {
  final ProfileModel profile;

  ProfileResponse({required this.profile});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      profile: ProfileModel.fromJson(json['profile']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile': profile.toJson(),
    };
  }
}
