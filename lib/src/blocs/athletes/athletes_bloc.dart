// -------------------------------------------------------------------------
// BLoC for managing athletes (public profiles)
// -------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/profile/favorite_relation_to_profile_model.dart';
import '../../repositories/profile_rpository.dart';
import 'athletes_event.dart';
import 'athletes_state.dart';

class AthletesBloc extends Bloc<AthletesEvent, AthletesState> {
  final ProfileRepository repository;

  AthletesBloc({required this.repository}) : super(const AthletesInitial()) {
    on<AthletesFetched>(_onAthletesFetched);
    on<AthletesSearched>(_onAthletesSearched);
    on<AthletesFiltered>(_onAthletesFiltered);
    on<FavoriteToggledForAthlete>(_onFavoriteToggledForAthlete);
  }

  // -------------------------------------------------------------------------
  // GET /profiles — fetch all athlete profiles
  // -------------------------------------------------------------------------
  Future<void> _onAthletesFetched(AthletesFetched event, Emitter<AthletesState> emit) async {
    emit(const AthletesLoadInProgress());
    try {
      final profiles = await repository.getAllProfiles();
      emit(AthletesLoadSuccess(profiles));
    } catch (e) {
      emit(AthletesFailure(e.toString()));
    }
  }

  Future<void> _onAthletesSearched(AthletesSearched event, Emitter<AthletesState> emit) async {
    emit(const AthletesLoadInProgress());
    try {
      final profiles = await repository.searchProfiles(event.query);
      emit(AthletesLoadSuccess(profiles));
    } catch (e) {
      emit(AthletesFailure(e.toString()));
    }
  }

  Future<void> _onAthletesFiltered(AthletesFiltered event, Emitter<AthletesState> emit) async {
    emit(const AthletesLoadInProgress());
    try {
      final profiles = await repository.filterProfiles(
        level: event.level,
        country: event.country,
        city: event.city,
        gender: event.gender,
        maxWeight: event.maxWeight,
        minWeight: event.minWeight,
      );
      emit(AthletesLoadSuccess(profiles));
    } catch (e) {
      emit(AthletesFailure(e.toString()));
    }
  }

  Future<void> _onFavoriteToggledForAthlete(FavoriteToggledForAthlete event, Emitter<AthletesState> emit) async {
    if (state is AthletesLoadSuccess) {
      final profiles = (state as AthletesLoadSuccess).profiles;

      final updatedProfiles = profiles.map((p) {
        if (p.userId == event.currentUserId) {
          final alreadyFav = p.favorites.any((f) => f.favoritedUserId == event.targetUserId);
          final updatedFavs = alreadyFav
              ? p.favorites.where((f) => f.favoritedUserId != event.targetUserId).toList()
              : [...p.favorites, Favorite(userId: event.currentUserId, favoritedUserId: event.targetUserId)];
          return p.copyWith(favorites: updatedFavs);
        }
        return p;
      }).toList();

      emit(AthletesLoadSuccess(updatedProfiles));
    }

    try {
      await repository.toggleFavorite(targetUserId: event.targetUserId);
    } catch (e) {
      emit(AthletesFailure('Failed to toggle favorite: $e'));
    }
  }
}
