import 'package:sparring_finder/src/repositories/base_repository.dart';

class FavoriteRepository extends BaseRepository {
  FavoriteRepository({required super.apiService});

  /// POST /favorite - Add a favorite
  Future<String> addFavorite(int favoritedUserId, {String? note}) async {
    final response = await apiService.post('/favorite', {
      'favorited_user_id': favoritedUserId,
      if (note != null) 'note': note,
    });

    return response['message'] ?? 'Favorite added';
  }

  /// DELETE /favorite/:id - Remove a favorite
  Future<String> removeFavorite(int favoritedUserId) async {
    final response = await apiService.delete('/favorite/$favoritedUserId');
    return response['message'] ?? 'Favorite removed';
  }

  // /// GET /favorite - Get all favorites
  // Future<List<ProfileModel>> getFavorites() async {
  //   final response = await apiService.get('/favorite');
  //   final list = response['favorites'] as List;
  //   return list.map((e) => ProfileModel.fromJson(e)).toList();
  // }
}
