import 'package:equatable/equatable.dart';

abstract class OnBoardEvent extends Equatable {
  const OnBoardEvent();

  @override
  List<Object?> get props => [];
}

class OnBoardLastPageChanged extends OnBoardEvent {
  final bool isLastPage;

  const OnBoardLastPageChanged({required this.isLastPage});

  @override
  List<Object?> get props => [isLastPage];
}
