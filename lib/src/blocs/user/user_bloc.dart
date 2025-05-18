import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_event.dart';
import 'package:sparring_finder/src/blocs/user/user_state.dart';
import 'package:sparring_finder/src/repositories/user_repository.dart';
import 'package:sparring_finder/src/utils/jwt.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<UserRegisterRequested>(_onRegister);
    on<UserLoginRequested>(_onLogin);
    on<UserVerifyEmailRequested>(_onVerifyEmail);
    on<UserResendVerificationRequested>(_onResendVerification);
    on<UserForgotPasswordRequested>(_onForgotPassword);
    on<UserResetPasswordRequested>(_onResetPassword);
  }

  Future<void> _onRegister(
      UserRegisterRequested event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());
    try {
      final message = await userRepository.registerUser(
        email: event.email,
        password: event.password,
      );
      emit(UserSuccess(message: message));
    } catch (e) {
      emit(UserFailure(error: e.toString()));
    }
  }

  Future<void> _onLogin(
      UserLoginRequested event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());
    try {
      final loginResponse = await userRepository.loginUser(
        email: event.email,
        password: event.password,
      );

      await JwtStorageHelper.saveTokens(accessToken: loginResponse.accessToken, refreshToken: loginResponse.refreshToken);

      emit(UserAuthenticated(response: loginResponse));
    } catch (e) {
      emit(UserFailure(error: e.toString()));
    }
  }

  Future<void> _onVerifyEmail(
      UserVerifyEmailRequested event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());
    try {
      final message = await userRepository.verifyEmail(code: event.code);
      emit(UserSuccess(message: message));
    } catch (e) {
      emit(UserFailure(error: e.toString()));
    }
  }

  Future<void> _onResendVerification(
      UserResendVerificationRequested event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());
    try {
      final message = await userRepository.resendVerification(email: event.email);
      emit(UserSuccess(message: message));
    } catch (e) {
      emit(UserFailure(error: e.toString()));
    }
  }

  Future<void> _onForgotPassword(
      UserForgotPasswordRequested event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());
    try {
      final message = await userRepository.forgotPassword(email: event.email);
      emit(UserSuccess(message: message));
    } catch (e) {
      emit(UserFailure(error: e.toString()));
    }
  }

  Future<void> _onResetPassword(
      UserResetPasswordRequested event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());
    try {
      final message = await userRepository.resetPassword(
        code: event.code,
        newPassword: event.newPassword,
      );
      emit(UserSuccess(message: message));
    } catch (e) {
      emit(UserFailure(error: e.toString()));
    }
  }
}
