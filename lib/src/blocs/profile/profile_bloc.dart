import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../models/profile/favorite_relation_to_profile_model.dart';
import '../../models/profile/profile_response.dart';
import '../../repositories/profile_rpository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(const ProfileInitial()) {
    on<ProfileExistenceRequested>(_onProfileExistenceRequested);
    on<ProfileRequested>(_onProfileRequested);
    on<ProfileCreated>(_onProfileCreated);
    on<ProfileUpdated>(_onProfileUpdated);
    on<ProfilePhotoUpdated>(_onProfilePhotoUpdated);
    on<ProfileDeleted>(_onProfileDeleted);
    on<ProfilesFetchedAll>(_onProfilesFetchedAll);
    on<ProfilesSearched>(_onProfilesSearched);
    on<ProfilesFiltered>(_onProfilesFiltered);
    on<FavoriteToggled>(_onFavoriteToggled);
  }

  // ---------------------------------------------------------------------------
  // Event Handlers
  // ---------------------------------------------------------------------------

  Future<void> _onProfileExistenceRequested(
      ProfileExistenceRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoadInProgress());
    try {
      final exists = await repository.hasProfile();
      emit(ProfileExistenceSuccess(exists));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileRequested(
      ProfileRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoadInProgress());
    try {
      final ProfileResponse response = await repository.getProfile();
      emit(ProfileLoadSuccess(response.profiles.first));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileCreated(
      ProfileCreated event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoadInProgress());
    try {
      final ProfileResponse response =
      await repository.createProfile(event.data, photo: event.photo);
      emit(ProfileLoadSuccess(response.profiles.first));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileUpdated(
      ProfileUpdated event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoadInProgress());
    try {
      final ProfileResponse response =
      await repository.updateProfile(event.data);
      emit(ProfileLoadSuccess(response.profiles.first));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfilePhotoUpdated(
      ProfilePhotoUpdated event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoadInProgress());
    try {
      final ProfileResponse response =
      await repository.updateProfilePhoto(event.photo);
      emit(ProfileLoadSuccess(response.profiles.first));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileDeleted(
      ProfileDeleted event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoadInProgress());
    try {
      final message = await repository.deleteProfile();
      emit(ProfileOperationSuccess(message));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfilesFetchedAll(
      ProfilesFetchedAll event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoadInProgress());
    try {
      final profiles = await repository.getAllProfiles();
      emit(ProfileListLoadSuccess(profiles));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfilesSearched(
      ProfilesSearched event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoadInProgress());
    try {
      final profiles = await repository.searchProfiles(event.query);
      emit(ProfileListLoadSuccess(profiles));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfilesFiltered(
      ProfilesFiltered event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoadInProgress());
    try {
      final profiles = await repository.filterProfiles(
        level: event.level,
        country: event.country,
        city: event.city,
        gender: event.gender,
        maxWeight: event.maxWeight,
        minWeight: event.minWeight,
      );
      emit(ProfileListLoadSuccess(profiles));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onFavoriteToggled(
      FavoriteToggled event,
      Emitter<ProfileState> emit,
      ) async {
    // ------------------- Optimistic update for single profile ------------ //
    if (state is ProfileLoadSuccess) {
      final current = (state as ProfileLoadSuccess).profile;
      final alreadyFav = current.favorites
          .any((f) => f.favoritedUserId == event.targetUserId);

      final updatedFavorites = alreadyFav
          ? current.favorites
          .where((f) => f.favoritedUserId != event.targetUserId)
          .toList()
          : [
        ...current.favorites,
        Favorite(
          userId: event.currentUserId,
          favoritedUserId: event.targetUserId,
        ),
      ];
      emit(ProfileLoadSuccess(current.copyWith(favorites: updatedFavorites)));
    }

    // ------------------- Optimistic update for list ---------------------- //
    if (state is ProfileListLoadSuccess) {
      final profiles = (state as ProfileListLoadSuccess).profiles;

      final updatedProfiles = profiles.map((p) {
        if (p.userId == event.currentUserId) {
          final alreadyFav =
          p.favorites.any((f) => f.favoritedUserId == event.targetUserId);
          final updatedFavs = alreadyFav
              ? p.favorites
              .where((f) => f.favoritedUserId != event.targetUserId)
              .toList()
              : [
            ...p.favorites,
            Favorite(
              userId: event.currentUserId,
              favoritedUserId: event.targetUserId,
            ),
          ];
          return p.copyWith(favorites: updatedFavs);
        }
        return p;
      }).toList();

      emit(ProfileListLoadSuccess(updatedProfiles));
    }

    // ------------------- API call --------------------------------------- //
    try {
      await repository.toggleFavorite(targetUserId: event.targetUserId);
    } catch (e) {
      emit(ProfileFailure('Failed to toggle favorite: $e'));
    }
  }
}
