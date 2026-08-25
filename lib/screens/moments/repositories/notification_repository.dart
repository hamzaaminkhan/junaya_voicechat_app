import '../data/notification_model.dart';

abstract class NotificationRepository {
  Future<List<MomentNotification>> getNotifications();
}
