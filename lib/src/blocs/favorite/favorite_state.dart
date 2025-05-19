import 'package:equatable/equatable.dart';
import '../../models/favorite/favorite_model.dart';
import '../../models/profile/profile_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteFailure extends FavoriteState {
  final String error;

  const FavoriteFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

// class FavoritesLoaded extends FavoriteState {
//   final List<ProfileModel> favorites;
//
//   const FavoritesLoaded({required this.favorites});
//
//   @override
//   List<Object?> get props => [favorites];
// }

class FavoriteActionSuccess extends FavoriteState {
  final String message;

  const FavoriteActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
