import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/favorite/favorite_event.dart';
import 'package:sparring_finder/src/blocs/favorite/favorite_state.dart';
import 'package:sparring_finder/src/repositories/favorite_repository.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;

  FavoriteBloc({required this.favoriteRepository}) : super(FavoriteInitial()) {
    on<AddFavoriteRequested>(_onAddFavoriteRequested);
    on<RemoveFavoriteRequested>(_onRemoveFavoriteRequested);
    // on<LoadFavoritesRequested>(_onLoadFavoritesRequested);
  }

  Future<void> _onAddFavoriteRequested(
      AddFavoriteRequested event,
      Emitter<FavoriteState> emit,
      ) async {
    emit(FavoriteLoading());
    try {
      await favoriteRepository.addFavorite(event.favoritedUserId, note: event.note);
      emit(FavoriteActionSuccess('Favorite added successfully'));
    } catch (e) {
      emit(FavoriteFailure(error: e.toString()));
    }
  }

  Future<void> _onRemoveFavoriteRequested(
      RemoveFavoriteRequested event,
      Emitter<FavoriteState> emit,
      ) async {
    emit(FavoriteLoading());
    try {
      await favoriteRepository.removeFavorite(event.favoritedUserId);
      emit(FavoriteActionSuccess('Favorite added successfully'));
    } catch (e) {
      emit(FavoriteFailure(error: e.toString()));
    }
  }

  // Future<void> _onLoadFavoritesRequested(
  //     LoadFavoritesRequested event,
  //     Emitter<FavoriteState> emit,
  //     ) async {
  //   emit(FavoriteLoading());
  //   try {
  //     final favorites = await favoriteRepository.getFavorites();
  //     emit(FavoritesLoaded(favorites: favorites));
  //   } catch (e) {
  //     emit(FavoriteFailure(error: e.toString()));
  //   }
  // }
}
