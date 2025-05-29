import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserRegisterRequested extends UserEvent {
  final String email;
  final String password;

  const UserRegisterRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class UserLoginRequested extends UserEvent {
  final String email;
  final String password;

  const UserLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class UserVerifyEmailRequested extends UserEvent {
  final String code;

  const UserVerifyEmailRequested({required this.code});

  @override
  List<Object> get props => [code];
}

class UserResendVerificationRequested extends UserEvent {
  final String email;

  const UserResendVerificationRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class UserForgotPasswordRequested extends UserEvent {
  final String email;

  const UserForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class UserResetPasswordRequested extends UserEvent {
  final String code;
  final String newPassword;

  const UserResetPasswordRequested({required this.code, required this.newPassword});

  @override
  List<Object> get props => [code, newPassword];
}

class UserLogoutRequested extends UserEvent {
  const UserLogoutRequested();
}
