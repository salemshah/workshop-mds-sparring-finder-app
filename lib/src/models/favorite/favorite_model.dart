class FavoriteModel {
  final int id;
  final int userId;
  final int favoritedUserId;
  final String? note;
  final DateTime createdAt;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.favoritedUserId,
    this.note,
    required this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      userId: json['user_id'],
      favoritedUserId: json['favorited_user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'favorited_user_id': favoritedUserId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
