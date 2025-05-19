import 'package:equatable/equatable.dart';

import 'favorite_relation_to_profile_model.dart';
import 'profile_model.dart';

/// Root‑level DTO returned by the API when requesting several profiles.
///
/// The backend may optionally attach a flattened `favorites` array. Each entry
/// describes a *relation* between two users (who favourited whom). If your
/// endpoint does **not** provide such an array you can either ignore it or
/// remove the field entirely.
class ProfileResponse extends Equatable {
  final List<Profile> profiles;
  final List<Favorite> favorites;

  const ProfileResponse({
    required this.profiles,
    this.favorites = const [],
  });

  /// Throws [FormatException] on malformed data so callers can decide how to
  /// handle errors at the repository layer.
  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    final profilesJson = json['profiles'] as List?;
    if (profilesJson == null) {
      throw const FormatException('Key "profiles" missing in response');
    }

    final profiles = Profile.listFromJson(profilesJson);

    final favoritesJson = json['favorites'] as List? ?? const <dynamic>[];
    final favorites = favoritesJson
        .map((e) => Favorite.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    return ProfileResponse(profiles: profiles, favorites: favorites);
  }

  Map<String, dynamic> toJson() => {
    'profiles': profiles.map((p) => p.toJson()).toList(growable: false),
    if (favorites.isNotEmpty)
      'favorites': favorites.map((f) => f.toJson()).toList(growable: false),
  };

  @override
  List<Object?> get props => [profiles, favorites];
}
