import 'package:equatable/equatable.dart';

import '../../models/profile/profile_model.dart';

/// Base class for all states emitted by [ProfileBloc].
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

// ---------------------------------------------------------------------------
// Primitive States
// ---------------------------------------------------------------------------

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoadInProgress extends ProfileState {
  const ProfileLoadInProgress();
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// ---------------------------------------------------------------------------
// Success States
// ---------------------------------------------------------------------------

/// Detailed single‑profile payload.
class ProfileLoadSuccess extends ProfileState {
  final Profile profile;

  const ProfileLoadSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Whether the current user already has a profile.
class ProfileExistenceSuccess extends ProfileState {
  final bool isProfileExist;

  const ProfileExistenceSuccess(this.isProfileExist);

  @override
  List<Object?> get props => [isProfileExist];
}

/// A list of profiles returned by discovery/api.
class ProfileListLoadSuccess extends ProfileState {
  final List<Profile> profiles;

  const ProfileListLoadSuccess(this.profiles);

  @override
  List<Object?> get props => [profiles];
}

/// Generic success message (e.g. delete profile).
class ProfileOperationSuccess extends ProfileState {
  final String message;

  const ProfileOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
