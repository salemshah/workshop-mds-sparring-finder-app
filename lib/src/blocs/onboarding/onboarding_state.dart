import 'package:equatable/equatable.dart';

abstract class OnBoardState extends Equatable {
  const OnBoardState();

  @override
  List<Object?> get props => [];
}

class OnBoardInitial extends OnBoardState {}

class OnBoardLastPageState extends OnBoardState {
  final bool isLastPage;

  const OnBoardLastPageState({required this.isLastPage});

  @override
  List<Object?> get props => [isLastPage];
}
