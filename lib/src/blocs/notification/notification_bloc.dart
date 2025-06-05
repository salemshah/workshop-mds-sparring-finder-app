import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../config/app_routes.dart';
import '../../services/notification_service.dart';
import '../../repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService service;
  final NotificationRepository repository;
  StreamSubscription<RemoteMessage>? _sub;

  NotificationBloc(this.service, this.repository)
      : super(NotificationInitial()) {
    // Triggered when app starts and push logic is set up
    on<NotificationStarted>(_onStart);

    // Add this: handle push received event
    on<NotificationReceived>(_onReceived);
    on<LoadNotifications>(_onLoadAll);
    on<LoadNotificationById>(_onLoadOne);
    on<DeleteNotification>(_onDelete);
  }

  /// Called when NotificationStarted is dispatched
  Future<void> _onStart(
      NotificationStarted event, Emitter<NotificationState> emit) async {
    try {
      await service.init();
      emit(NotificationReady());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  /// Called when notification is received (tapped or pushed to UI)
  void _onReceived(
      NotificationReceived event, Emitter<NotificationState> emit) {
    final screen = event.data?["screen"];


    if (screen != null) {
      emit(NotificationNavigate(screen, arguments: event.data));
    }

    // if (screen == "notification") {
    //   emit(NotificationNavigate(AppRoutes.notificationScreen));
    // }else if(screen == "chat"){
    // }
    // emit(NotificationUnread(event.title, event.body));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  // -------------------------------------------------------------------------
  // GET /notifications — get all notifications
  // -------------------------------------------------------------------------
  Future<void> _onLoadAll(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(const NotificationLoadInProgress());
    try {
      final list = await repository.getNotifications();
      emit(NotificationLoadSuccess(list));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  // -------------------------------------------------------------------------
  // GET /notifications/:id — get single notification
  // -------------------------------------------------------------------------
  Future<void> _onLoadOne(
      LoadNotificationById event, Emitter<NotificationState> emit) async {
    emit(const NotificationLoadInProgress());
    try {
      final notification = await repository.getNotificationById(event.id);
      emit(NotificationSingleSuccess(notification));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  // -------------------------------------------------------------------------
  // DELETE /notifications/:id — delete a notification
  // -------------------------------------------------------------------------
  Future<void> _onDelete(
      DeleteNotification event, Emitter<NotificationState> emit) async {
    emit(const NotificationLoadInProgress());
    try {
      await repository.deleteNotification(event.id);
      final list = await repository.getNotifications();
      emit(NotificationLoadSuccess(list));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }
}
