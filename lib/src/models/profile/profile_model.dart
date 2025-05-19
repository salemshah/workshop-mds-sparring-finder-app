import 'package:equatable/equatable.dart';

import 'favorite_relation_to_profile_model.dart';


/// Core domain model for a fighter profile.
class Profile extends Equatable {
  final int id;
  final int userId;
  final String firstName;
  final String lastName;
  final String? bio;
  final String? photoUrl;
  final DateTime dateOfBirth;
  final String gender;
  final String weightClass;
  final String skillLevel;
  final String yearsExperience;
  final String preferredStyles;
  final String gymName;
  final String city;
  final String country;
  final bool? verified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Favorite> favorites;

  const Profile({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.bio,
    this.photoUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.weightClass,
    required this.skillLevel,
    required this.yearsExperience,
    required this.preferredStyles,
    required this.gymName,
    required this.city,
    required this.country,
    this.verified,
    required this.createdAt,
    required this.updatedAt,
    this.favorites = const [],
  });

  /// Builds a [Profile] object from a JSON map returned by the API.
  factory Profile.fromJson(Map<String, dynamic> json) {
    final favoritesJson =
        (json['user']?['favorites'] as List<dynamic>?) ?? const <dynamic>[];

    return Profile(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      bio: json['bio'] as String?,
      photoUrl: json['photo_url'] as String?,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String? ?? '',
      weightClass: json['weight_class'] as String? ?? '',
      skillLevel: json['skill_level'] as String? ?? '',
      yearsExperience: json['years_experience'] as String? ?? '',
      preferredStyles: json['preferred_styles'] as String? ?? '',
      gymName: json['gym_name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      verified: json['verified'] as bool?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      favorites: favoritesJson
          .map((e) => Favorite.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  /// Converts a [Profile] instance back into a JSON map suitable for the API.
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'first_name': firstName,
    'last_name': lastName,
    'bio': bio,
    'photo_url': photoUrl,
    'date_of_birth': dateOfBirth.toIso8601String(),
    'gender': gender,
    'weight_class': weightClass,
    'skill_level': skillLevel,
    'years_experience': yearsExperience,
    'preferred_styles': preferredStyles,
    'gym_name': gymName,
    'city': city,
    'country': country,
    'verified': verified,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'user': {
      'favorites': favorites.map((f) => f.toJson()).toList(growable: false),
    },
  };

  /// Handy utility when your repository receives a list of raw profiles.
  static List<Profile> listFromJson(List<dynamic> data) =>
      data.map((e) => Profile.fromJson(e as Map<String, dynamic>)).toList();

  Profile copyWith({
    int? id,
    int? userId,
    String? firstName,
    String? lastName,
    String? bio,
    String? photoUrl,
    DateTime? dateOfBirth,
    String? gender,
    String? weightClass,
    String? skillLevel,
    String? yearsExperience,
    String? preferredStyles,
    String? gymName,
    String? city,
    String? country,
    bool? verified,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Favorite>? favorites,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      weightClass: weightClass ?? this.weightClass,
      skillLevel: skillLevel ?? this.skillLevel,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      preferredStyles: preferredStyles ?? this.preferredStyles,
      gymName: gymName ?? this.gymName,
      city: city ?? this.city,
      country: country ?? this.country,
      verified: verified ?? this.verified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    firstName,
    lastName,
    bio,
    photoUrl,
    dateOfBirth,
    gender,
    weightClass,
    skillLevel,
    yearsExperience,
    preferredStyles,
    gymName,
    city,
    country,
    verified,
    createdAt,
    updatedAt,
    favorites,
  ];
}
