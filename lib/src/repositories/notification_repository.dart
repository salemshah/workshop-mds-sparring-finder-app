import '../models/notification/notification_model.dart';
import 'base_repository.dart';

class NotificationRepository extends BaseRepository {
  NotificationRepository({required super.apiService});

  // -------------------------------------------------------------------------
  // GET `/notifications` — get all notifications for authenticated user
  // -------------------------------------------------------------------------
  Future<List<NotificationModel>> getNotifications() async {
    final response = await apiService.get('/notification');
    final list = response['notifications'] as List<dynamic>;
    return NotificationModel.listFromJson(list);
  }

  // -------------------------------------------------------------------------
  // GET `/notifications/:id` — get a single notification by ID
  // -------------------------------------------------------------------------
  Future<NotificationModel> getNotificationById(int id) async {
    final response = await apiService.get('/notification/$id');
    return NotificationModel.fromJson(response['notification']);
  }

  // -------------------------------------------------------------------------
  // DELETE `/notifications/:id` — delete a notification
  // -------------------------------------------------------------------------
  Future<void> deleteNotification(int id) async {
    await apiService.delete('/notification/$id');
  }
}