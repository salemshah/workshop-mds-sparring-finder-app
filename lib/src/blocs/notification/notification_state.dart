import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}
class NotificationReady   extends NotificationState {}
class NotificationError   extends NotificationState {
  final String error;
  const NotificationError(this.error);
  @override
  List<Object?> get props => [error];
}
