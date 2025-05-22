import 'dart:io';

import 'package:equatable/equatable.dart';

/// Base class for all profile‑related events consumed by [ProfileBloc].
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Check whether the authenticated user already created a profile.
class ProfileExistenceRequested extends ProfileEvent {
  const ProfileExistenceRequested();
}

/// Fetch the authenticated user's profile.
class ProfileRequested extends ProfileEvent {
  const ProfileRequested();
}

/// Create a new profile; optionally uploads a photo.
class ProfileCreated extends ProfileEvent {
  final Map<String, dynamic> data;
  final File? photo;

  const ProfileCreated({required this.data, this.photo});

  @override
  List<Object?> get props => [data, photo];
}

/// Update profile fields (no photo).
class ProfileUpdated extends ProfileEvent {
  final Map<String, dynamic> data;

  const ProfileUpdated(this.data);

  @override
  List<Object?> get props => [data];
}

/// Update or upload a profile picture.
class ProfilePhotoUpdated extends ProfileEvent {
  final File photo;

  const ProfilePhotoUpdated({required this.photo});

  @override
  List<Object?> get props => [photo];
}

/// Delete the authenticated user's profile.
class ProfileDeleted extends ProfileEvent {
  const ProfileDeleted();
}

// ---------------------------------------------------------------------------
// Collections Flow
// ---------------------------------------------------------------------------

/// Fetch all profiles (e.g. for discovery screen).
class ProfilesFetchedAll extends ProfileEvent {
  const ProfilesFetchedAll();
}

/// Full‑text search.
class ProfilesSearched extends ProfileEvent {
  final String query;

  const ProfilesSearched(this.query);

  @override
  List<Object?> get props => [query];
}

/// Parameterised filter search.
class ProfilesFiltered extends ProfileEvent {
  final String? level;
  final String? country;
  final String? city;
  final String? gender;
  final double? maxWeight;
  final double? minWeight;

  const ProfilesFiltered({
    this.level,
    this.country,
    this.city,
    this.gender,
    this.maxWeight,
    this.minWeight,
  });

  @override
  List<Object?> get props => [
    level,
    country,
    city,
    gender,
    maxWeight,
    minWeight,
  ];
}

class ProfileRequestedById extends ProfileEvent {
  final int userId;
  const ProfileRequestedById(this.userId);
}


// ---------------------------------------------------------------------------
// Favorites
// ---------------------------------------------------------------------------

/// Toggle favorite relation with [targetUserId].
class FavoriteToggled extends ProfileEvent {
  final int targetUserId;
  final int currentUserId;

  const FavoriteToggled({
    required this.targetUserId,
    required this.currentUserId,
  });

  @override
  List<Object?> get props => [targetUserId, currentUserId];
}