class UserModel {
  final int id;
  final String email;
  final String role;
  final bool isVerified;
  final bool isActive;
  final DateTime? lastLoginAt;
  final String authProvider;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    this.lastLoginAt,
    required this.authProvider,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      isVerified: json['is_verified'],
      isActive: json['is_active'],
      lastLoginAt: json['last_login_at'] != null ? DateTime.parse(json['last_login_at']) : null,
      authProvider: json['auth_provider'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'is_verified': isVerified,
      'is_active': isActive,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'auth_provider': authProvider,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
