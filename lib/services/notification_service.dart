import 'package:app/file/hive_storage_files/hive_storage_manager.dart';
import 'package:app/file/hooks_files/hooks_configurations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'battery_monitor_channel',
          'Battery Monitor',
          channelDescription: 'Notifications for battery and system monitoring',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> genericShowNotification(
    String title,
    String body,
    String notificationType,
  ) async {
    List<String>? savedFormats = HiveStorageManager.readNotificationFormat();

    // If no formats are saved, we might want to show everything or nothing.
    // User said: "if user didnt select any his specific notification format then only the selectedNotifications will be going to use"
    // But in notification_format.dart we ensure selectedNotifications is populated with default if empty.
    // So if savedFormats is null, we should probably check default hook or just return.
    // However, in notification_format.dart we save the default if user enters and saves.
    // If user NEVER entered notification_format screen, savedFormats might be null.
    // In that case, we should probably use the default list from hooks.

    if (savedFormats == null || savedFormats.isEmpty) {
      // Fallback to default if not saved yet
      // We can't easily access Hooks here without importing it.
      // Let's assume if null, we allow it? Or we block it?
      // User said: "If user closes the app and come again We will check if the user selected notifications format list available, If yes then we will show it on screen If not the selectedNotifications will show."
      // This implies defaults should apply.
      // Let's import HooksConfigurations to be safe.
      savedFormats =
          HooksConfigurations.defaultSelectedNotificationsFormatsHook?.call() ??
          [];
    }

    if (savedFormats != null && savedFormats.contains(notificationType)) {
      await showNotification(title, body);
    }
  }
}
