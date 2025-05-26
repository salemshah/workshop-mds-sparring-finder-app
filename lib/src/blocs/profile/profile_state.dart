import 'package:equatable/equatable.dart';
import '../../models/profile/profile_model.dart';

// ---------------------------------------------------------------------------
// States related to the current user's own profile
// ---------------------------------------------------------------------------

abstract class MyProfileState extends Equatable {
  const MyProfileState();

  @override
  List<Object?> get props => [];
}

class MyProfileInitial extends MyProfileState {
  const MyProfileInitial();
}

class MyProfileLoadInProgress extends MyProfileState {
  const MyProfileLoadInProgress();
}

class MyProfileFailure extends MyProfileState {
  final String error;

  const MyProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class MyProfileLoadSuccess extends MyProfileState {
  final Profile profile;

  const MyProfileLoadSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class MyProfileExistenceSuccess extends MyProfileState {
  final bool isProfileExist;

  const MyProfileExistenceSuccess(this.isProfileExist);

  @override
  List<Object?> get props => [isProfileExist];
}

class MyProfileOperationSuccess extends MyProfileState {
  final String message;

  const MyProfileOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}