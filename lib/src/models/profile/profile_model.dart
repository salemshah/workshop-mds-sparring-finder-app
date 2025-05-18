class ProfileModel {
  final int id;
  final int userId;
  final String firstName;
  final String lastName;
  final String bio;
  final String photoUrl;
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

  ProfileModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.photoUrl,
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
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      bio: json['bio'],
      photoUrl: json['photo_url'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      gender: json['gender'],
      weightClass: json['weight_class'],
      skillLevel: json['skill_level'],
      yearsExperience: json['years_experience'],
      preferredStyles: json['preferred_styles'],
      gymName: json['gym_name'],
      city: json['city'],
      country: json['country'],
      verified: json['verified'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    };
  }
}
