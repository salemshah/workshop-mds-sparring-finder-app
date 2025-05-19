import 'package:sparring_finder/src/models/favorite/favorite_model.dart';

class FavoriteResponse {
  final FavoriteModel favorite;

  FavoriteResponse({required this.favorite});

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      favorite: FavoriteModel.fromJson(json['favorite']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favorite': favorite.toJson(),
    };
  }
}
