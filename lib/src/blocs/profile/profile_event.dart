import 'dart:io';
import 'package:equatable/equatable.dart';

// ---------------------------------------------------------------------------
// Events for managing the current user's own profile
// ---------------------------------------------------------------------------

abstract class MyProfileEvent extends Equatable {
  const MyProfileEvent();

  @override
  List<Object?> get props => [];
}

class MyProfileExistenceChecked extends MyProfileEvent {
  const MyProfileExistenceChecked();
}

class MyProfileRequested extends MyProfileEvent {
  const MyProfileRequested();
}

class MyProfileCreated extends MyProfileEvent {
  final Map<String, dynamic> data;
  final File? photo;

  const MyProfileCreated({required this.data, this.photo});

  @override
  List<Object?> get props => [data, photo];
}

class MyProfileUpdated extends MyProfileEvent {
  final Map<String, dynamic> data;

  const MyProfileUpdated(this.data);

  @override
  List<Object?> get props => [data];
}

class MyProfilePhotoUpdated extends MyProfileEvent {
  final File photo;

  const MyProfilePhotoUpdated({required this.photo});

  @override
  List<Object?> get props => [photo];
}

class MyProfileDeleted extends MyProfileEvent {
  const MyProfileDeleted();
}