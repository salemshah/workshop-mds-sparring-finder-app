import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/onboarding/onboarding_event.dart';
import 'package:sparring_finder/src/blocs/onboarding/onboarding_state.dart';


class OnBoardBloc extends Bloc<OnBoardEvent, OnBoardState> {
  OnBoardBloc() : super(OnBoardInitial()) {
    on<OnBoardLastPageChanged>(_onLastPageChanged);
  }

  void _onLastPageChanged(
      OnBoardLastPageChanged event,
      Emitter<OnBoardState> emit,
      ) {
    emit(OnBoardLastPageState(isLastPage: event.isLastPage));
  }
}
