import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sparring_finder/src/config/repository_provider.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'default_channel',
    'Default Notifications',
    description: 'Used for basic push notifications',
    importance: Importance.high,
  );

  /// Initialize FCM + permissions + listeners
  Future<void> init() async {
    await _fcm.requestPermission();

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _local.initialize(settings);

    // Foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      if (notification != null && !Platform.isMacOS) {
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
        await _local.show(
          notification.hashCode,
          notification.title,
          notification.body,
          details,
        );
      }
    });

    await registerTokenWithBackend();
  }

  /// Returns the device token
  Future<String?> getToken() => _fcm.getToken();

  /// Sends the FCM token to the backend
  Future<void> registerTokenWithBackend() async {
    final token = await _fcm.getToken();
    if (token != null) {
      await RepositoryProviders.apiService.post('/user/save-token', {
        'fcm_token': token,
      });
    }

    _fcm.onTokenRefresh.listen((newToken) async {
      await RepositoryProviders.apiService.post('/user/save-token', {
        'fcm_token': newToken,
      });
    });
  }
}
