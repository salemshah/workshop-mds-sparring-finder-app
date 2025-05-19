

import 'package:equatable/equatable.dart';

/// Represents one entry in the nested `user → favorites` array.
class Favorite extends Equatable {
  final int userId;
  final int favoritedUserId;

  const Favorite({
    required this.userId,
    required this.favoritedUserId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
    userId: json['user_id'] as int,
    favoritedUserId: json['favorited_user_id'] as int,
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'favorited_user_id': favoritedUserId,
  };

  @override
  List<Object?> get props => [userId, favoritedUserId];
}
