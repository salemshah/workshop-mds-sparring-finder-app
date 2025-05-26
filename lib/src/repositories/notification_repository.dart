import 'package:sparring_finder/src/services/api_service.dart';

class NotificationRepository {
  final ApiService api;

  NotificationRepository(this.api);

  /// Optional: Send a manual push from frontend (e.g., test button)
  Future<void> sendAppointmentNotification({
    required int recipientUserId,
    required int appointmentId,
  }) async {
    await api.post('/notify-appointment', {
      'recipientUserId': recipientUserId,
      'appointmentId': appointmentId,
    });
  }
}
