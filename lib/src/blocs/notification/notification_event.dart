import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationStarted extends NotificationEvent {
  const NotificationStarted();
}

class NotificationReceived extends NotificationEvent {
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;

  const NotificationReceived({this.title, this.body, this.data});

  @override
  List<Object?> get props => [title, body];
}
