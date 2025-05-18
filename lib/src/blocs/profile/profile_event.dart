import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Load profile (GET /profile)
class ProfileRequested extends ProfileEvent {}

class ProfileListRequested extends ProfileEvent {}

// Check if profile exists (GET /profile/exists)
class ProfileCheckExists extends ProfileEvent {}

// Create a new profile (POST /profile)
class ProfileCreateRequested extends ProfileEvent {
  final Map<String, dynamic> profileData;
  final File? photo;

  const ProfileCreateRequested({required this.profileData, this.photo});

  @override
  List<Object?> get props => [profileData, photo];
}

//️ Update an existing profile (PUT /profile)
class ProfileUpdateRequested extends ProfileEvent {
  final Map<String, dynamic> updateData;

  const ProfileUpdateRequested({required this.updateData});

  @override
  List<Object?> get props => [updateData];
}

// 📸 Update only the profile photo (PATCH /profile/photo)
class ProfilePhotoUpdateRequested extends ProfileEvent {
  final File photo;

  const ProfilePhotoUpdateRequested({required this.photo});

  @override
  List<Object?> get props => [photo];
}

// Delete profile (DELETE /profile)
class ProfileDeleteRequested extends ProfileEvent {}

class ProfileSearchRequested extends ProfileEvent {
  final String query;

  const ProfileSearchRequested({required this.query});

  @override
  List<Object?> get props => [query];
}

