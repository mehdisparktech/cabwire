// notification_service_impl.dart
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cabwire/domain/services/notification_service.dart';

class NotificationServiceImpl implements NotificationService {
  static NotificationServiceImpl? _instance;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Singleton pattern
  static NotificationServiceImpl get instance {
    _instance ??= NotificationServiceImpl._();
    return _instance!;
  }

  NotificationServiceImpl._() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  @override
  Future<void> initLocalNotification() async {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    var androidInitializationSettings = const AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        // Handle notification response
        _onNotificationTapped(payload);
      },
    );
  }

  @override
  Future<void> showNotification(dynamic message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      "High Importance Notification",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: "your channel Description",
          importance: Importance.high,
          priority: Priority.high,
          ticker: "ticker",
        );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message['message'],
        message['type'],
        notificationDetails,
      );
    });
  }

  // Private method to handle notification tap
  void _onNotificationTapped(NotificationResponse payload) {
    // Add your navigation logic here
    // print("Route");
    // Get.toNamed(AppRoute.notification);
  }

  // Additional utility methods
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
