import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../services/notification_service.dart';
import '../../repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService service;
  final NotificationRepository repo;
  StreamSubscription<RemoteMessage>? _sub;

  NotificationBloc(this.service, this.repo) : super(NotificationInitial()) {
    // Triggered when app starts and push logic is set up
    on<NotificationStarted>(_onStart);

    // Add this: handle push received event
    on<NotificationReceived>(_onReceived);
  }

  /// Called when NotificationStarted is dispatched
  Future<void> _onStart(
      NotificationStarted event, Emitter<NotificationState> emit) async {
    try {
      await service.init();

      // Listen for notification taps (when app opens from background)
      _sub = FirebaseMessaging.onMessageOpenedApp.listen((msg) {
        add(NotificationReceived(
          title: msg.notification?.title,
          body: msg.notification?.body,
        ));
      });

      emit(NotificationReady());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  /// Called when notification is received (tapped or pushed to UI)
  void _onReceived(NotificationReceived event, Emitter<NotificationState> emit) {
    // For now, just print or handle as needed
    print("Notification received: notification_bloc.dart");
    print("Title: ${event.title}");
    print("Body: ${event.body}");
    print("data: ${event.data}");

    // Optionally emit a new state (e.g., to show a badge)
    // emit(NotificationUnread(event.title, event.body));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
