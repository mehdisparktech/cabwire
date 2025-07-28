abstract class NotificationService {
  Future<void> initLocalNotification();
  Future<void> showNotification(dynamic message);
}
