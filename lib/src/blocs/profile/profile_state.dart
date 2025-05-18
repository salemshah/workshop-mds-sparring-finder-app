import 'package:equatable/equatable.dart';
import '../../models/profile/profile_model.dart';
import '../../models/profile/profile_response.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final bool isProfileExist;
  const ProfileSuccess({required this.isProfileExist});
  @override
  List<Object?> get props => [isProfileExist];
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ProfileLoaded extends ProfileState {
  final ProfileResponse response;

  const ProfileLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class ProfilesLoaded extends ProfileState {
  final List<ProfileModel> profiles;

  const ProfilesLoaded({required this.profiles});

  @override
  List<Object?> get props => [profiles];
}

class ProfileSearchSuccess extends ProfileState {
  final List<ProfileModel> results;

  const ProfileSearchSuccess(this.results);

  @override
  List<Object?> get props => [results];
}