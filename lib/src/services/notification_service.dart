import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sparring_finder/src/config/repository_provider.dart';
import '../blocs/notification/notification_bloc.dart';
import '../blocs/notification/notification_event.dart';
import '../utils/secure_storage_helper.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  // Notification channel for Android
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'default_channel',
    'Default Notifications',
    description: 'Used for basic push notifications',
    importance: Importance.high,
  );

  /// Initializes FCM, notification channels, permissions, and foreground listeners
  Future<void> init() async {
    // Request permission for push notifications (iOS & Android 13+)
    await _fcm.requestPermission();

    // Create the Android notification channel
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Set up local notification initialization (for displaying foreground notifications)
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _local.initialize(settings);

    // Handle foreground push notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      if (notification != null && !Platform.isMacOS) {
        // Define notification details
        final details = NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        );

        // Show the notification as a local popup
        await _local.show(
          notification.hashCode,
          notification.title,
          notification.body,
          details,
        );
      }
    });

    // Register the token with your backend (only if it's new)
    await registerTokenWithBackend();
  }

  /// Get the current FCM token
  Future<String?> getToken() => _fcm.getToken();

  /// Sends the FCM token to your backend, only if it's not already saved
  Future<void> registerTokenWithBackend() async {
    final token = await _fcm.getToken();
    if (token == null) return;

    final lastSavedToken = await SecureStorageHelper.getLastFcmToken();

    if (token != lastSavedToken) {
      await RepositoryProviders.apiService.put('/user/save-token', {
        'fcm_token': token,
      });
      await SecureStorageHelper.saveLastFcmToken(token);
    }

    _fcm.onTokenRefresh.listen((newToken) async {
      await RepositoryProviders.apiService.put('/user/save-token', {
        'fcm_token': newToken,
      });
      await SecureStorageHelper.saveLastFcmToken(newToken);
    });
  }

  /// Call this ONCE at app start to handle background tap events
  static void handleNotificationTap(NotificationBloc bloc) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final notification = message.notification;
      final data = message.data;

      bloc.add(NotificationReceived(
        title: notification?.title ?? '',
        body: notification?.body ?? '',
        data: data,
      ));
    });
  }
}
