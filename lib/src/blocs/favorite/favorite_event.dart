import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class AddFavoriteRequested extends FavoriteEvent {
  final int userId;
  final int favoritedUserId;
  final String? note;

  const AddFavoriteRequested({
    required this.userId,
    required this.favoritedUserId,
    this.note,
  });

  @override
  List<Object?> get props => [userId, favoritedUserId, note];
}

class RemoveFavoriteRequested extends FavoriteEvent {
  final int userId;
  final int favoritedUserId;

  const RemoveFavoriteRequested({
    required this.userId,
    required this.favoritedUserId,
  });

  @override
  List<Object?> get props => [userId, favoritedUserId];
}

class LoadFavoritesRequested extends FavoriteEvent {
  final int userId;

  const LoadFavoritesRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}
