import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/profile/profile_event.dart';
import 'package:sparring_finder/src/blocs/profile/profile_state.dart';
import '../../models/profile/profile_response.dart';
import '../../repositories/profile_rpository.dart';


class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final ProfileRepository repository;

  MyProfileBloc({required this.repository}) : super(const MyProfileInitial()) {
    on<MyProfileExistenceChecked>(_onProfileExistenceChecked);
    on<MyProfileRequested>(_onProfileRequested);
    on<MyProfileCreated>(_onProfileCreated);
    on<MyProfileUpdated>(_onProfileUpdated);
    on<MyProfilePhotoUpdated>(_onProfilePhotoUpdated);
    on<MyProfileDeleted>(_onProfileDeleted);
  }

  // -------------------------------------------------------------------------
  // GET /profile — get current user's profile
  // -------------------------------------------------------------------------
  Future<void> _onProfileRequested(MyProfileRequested event, Emitter<MyProfileState> emit) async {
    emit(const MyProfileLoadInProgress());
    try {
      final ProfileResponse response = await repository.getProfile();
      emit(MyProfileLoadSuccess(response.profiles.first));
    } catch (e) {
      emit(MyProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileExistenceChecked(MyProfileExistenceChecked event, Emitter<MyProfileState> emit) async {
    emit(const MyProfileLoadInProgress());
    try {
      final exists = await repository.hasProfile();
      emit(MyProfileExistenceSuccess(exists));
    } catch (e) {
      emit(MyProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileCreated(MyProfileCreated event, Emitter<MyProfileState> emit) async {
    emit(const MyProfileLoadInProgress());
    try {
      final response = await repository.createProfile(event.data, photo: event.photo);
      emit(MyProfileLoadSuccess(response.profiles.first));
    } catch (e) {
      emit(MyProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileUpdated(MyProfileUpdated event, Emitter<MyProfileState> emit) async {
    emit(const MyProfileLoadInProgress());
    try {
      final response = await repository.updateProfile(event.data);
      emit(MyProfileLoadSuccess(response.profiles.first));
    } catch (e) {
      emit(MyProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfilePhotoUpdated(MyProfilePhotoUpdated event, Emitter<MyProfileState> emit) async {
    emit(const MyProfileLoadInProgress());
    try {
      final response = await repository.updateProfilePhoto(event.photo);
      emit(MyProfileLoadSuccess(response.profiles.first));
    } catch (e) {
      emit(MyProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileDeleted(MyProfileDeleted event, Emitter<MyProfileState> emit) async {
    emit(const MyProfileLoadInProgress());
    try {
      final message = await repository.deleteProfile();
      emit(MyProfileOperationSuccess(message));
    } catch (e) {
      emit(MyProfileFailure(e.toString()));
    }
  }
}