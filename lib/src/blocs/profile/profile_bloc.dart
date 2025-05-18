import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/profile/profile_event.dart';
import 'package:sparring_finder/src/blocs/profile/profile_state.dart';
import '../../repositories/profile_rpository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
    on<ProfileCheckExists>(_onProfileCheckExists);
    on<ProfileCreateRequested>(_onProfileCreateRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfilePhotoUpdateRequested>(_onProfilePhotoUpdateRequested);
    on<ProfileDeleteRequested>(_onProfileDeleteRequested);
    on<ProfileListRequested>(_onProfileListRequested);
    on<ProfileSearchRequested>(_onProfileSearchRequested);
  }


  Future<void> _onProfileListRequested(
      ProfileListRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final profiles = await profileRepository.getAllProfiles();
      emit(ProfilesLoaded(profiles: profiles));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileRequested(
      ProfileRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final response = await profileRepository.getProfile();
      emit(ProfileLoaded(response: response));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileCheckExists(
      ProfileCheckExists event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final exists = await profileRepository.hasProfile();
      emit(ProfileSuccess(isProfileExist: exists));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileCreateRequested(
      ProfileCreateRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final response = await profileRepository.createProfile(event.profileData, photo: event.photo);
      emit(ProfileLoaded(response: response));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileUpdateRequested(
      ProfileUpdateRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final response = await profileRepository.updateProfile(event.updateData);
      emit(ProfileLoaded(response: response));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfilePhotoUpdateRequested(
      ProfilePhotoUpdateRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final response = await profileRepository.updateProfilePhoto(event.photo);
      emit(ProfileLoaded(response: response));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }

  Future<void> _onProfileDeleteRequested(
      ProfileDeleteRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      await profileRepository.deleteProfile();
      // emit(ProfileSuccess(isExist: true));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }


  Future<void> _onProfileSearchRequested(
      ProfileSearchRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final results = await profileRepository.searchProfiles(event.query);
      emit(ProfileSearchSuccess(results));
    } catch (e) {
      emit(ProfileFailure(error: e.toString()));
    }
  }
}
