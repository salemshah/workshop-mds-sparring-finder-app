import 'package:equatable/equatable.dart';

import '../../models/notification/notification_model.dart';

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

class NotificationNavigate extends NotificationState {
  final String routeName;
  final Map<String, dynamic>? arguments;

  const NotificationNavigate(this.routeName, {this.arguments});
}

class NotificationLoadInProgress extends NotificationState {
  const NotificationLoadInProgress();
}

class NotificationLoadSuccess extends NotificationState {
  final List<NotificationModel> notifications;

  const NotificationLoadSuccess(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationSingleSuccess extends NotificationState {
  final NotificationModel notification;

  const NotificationSingleSuccess(this.notification);

  @override
  List<Object?> get props => [notification];
}

class NotificationFailure extends NotificationState {
  final String error;

  const NotificationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
