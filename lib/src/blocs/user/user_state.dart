import 'package:equatable/equatable.dart';
import 'package:sparring_finder/src/models/user/user_login_response.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserUnauthenticated extends UserState {}

class UserSuccess extends UserState {
  final String message;

  const UserSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserFailure extends UserState {
  final String error;

  const UserFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserAuthenticated extends UserState {
  final UserLoginResponse response;

  const UserAuthenticated({required this.response});

  @override
  List<Object?> get props => [response];
}