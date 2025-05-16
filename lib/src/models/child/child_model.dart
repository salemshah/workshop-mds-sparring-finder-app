class ChildModel {
  final int id;
  final DateTime birthDate;
  final String firstName;
  final String lastName;
  final String gender;
  final String schoolLevel;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? username;
  final String? profilePictureUrl;


  ChildModel({
    required this.id,
    required this.birthDate,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.schoolLevel,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.username,
    this.profilePictureUrl,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] as int,
      birthDate: DateTime.parse(json['birthDate'] as String),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String,
      schoolLevel: json['schoolLevel'] as String,
      status: json['status'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      username: json['username'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'birthDate': birthDate.toIso8601String(),
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'schoolLevel': schoolLevel,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'profilePictureUrl': profilePictureUrl,
      'username': username,
    };
  }
}
