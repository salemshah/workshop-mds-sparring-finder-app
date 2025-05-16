class ParentModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final bool status;
  final DateTime? birthDate;
  final String? phoneNumber;
  final String? addressPostal;
  final DateTime createdAt;
  final DateTime updatedAt;

  ParentModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.status,
    this.birthDate,
    this.phoneNumber,
    this.addressPostal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      status: json['status'] as bool,
      birthDate: json['birthDate'] != null ? DateTime.tryParse(json['birthDate'] as String) : null,
      phoneNumber: json['phoneNumber'] as String?,
      addressPostal: json['addressPostal'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'status': status,
      'birthDate': birthDate,
      'phoneNumber': phoneNumber,
      'addressPostal': addressPostal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
