import 'package:app/file/hive_storage_files/hive_storage_manager.dart';
import 'package:app/model/performance_history.dart';
import 'package:app/services/notification_service.dart';

class SystemMonitorService {
  static final SystemMonitorService _instance = SystemMonitorService._internal();
  factory SystemMonitorService() => _instance;
  SystemMonitorService._internal();

  // Performance history management
  void logPerformanceHistory({
    required int ramUsed,
    required int ramTotal,
    required int batteryLevel,
  }) {
    final history = HiveStorageManager.readPerformanceHistory();
    history.add({
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'ram_used': ramUsed,
      'ram_total': ramTotal,
      'battery_level': batteryLevel,
    });

    // Keep last 24 hours (24 * 12 = 288 entries at 5-minute intervals)
    if (history.length > 288) {
      history.removeAt(0);
    }
    HiveStorageManager.storePerformanceHistory(history);
  }

  void checkAndNotifyHighMemoryUsage({
    required int usedMemory,
    required int totalMemory,
  }) {
    if (totalMemory > 0) {
      final double usagePercentage = (usedMemory / totalMemory) * 100;

      final bool notificationsEnabled =
          HiveStorageManager.readNotificationEnabled() ?? false;

      final rawFormats = HiveStorageManager.readNotificationFormat();
      List<String> notificationFormat = [];
      if (rawFormats is List) {
        notificationFormat = rawFormats.cast<String>();
      }

      if (usagePercentage > 90 &&
          notificationsEnabled &&
          notificationFormat.contains("high_memory_usage")) {
        NotificationService().showNotification(
          "High Memory Usage",
          "RAM usage is above 90%! (${usagePercentage.toStringAsFixed(1)}%)",
        );
      }
    }
  }

  // Get performance history
  List<PerformanceHistory> getPerformanceHistory() {
    final List<dynamic> rawHistory = HiveStorageManager.readPerformanceHistory();
    return rawHistory
        .map((item) => PerformanceHistory.fromMap(
        Map<String, dynamic>.from(item as Map<dynamic, dynamic>)))
        .toList();
  }

  // Clear old history (older than specified hours)
  void clearOldHistory({int hours = 24}) {
    final cutoffTime = DateTime.now().subtract(Duration(hours: hours));
    final history = HiveStorageManager.readPerformanceHistory();

    history.removeWhere((item) {
      final timestamp = item['timestamp'] as int;
      return DateTime.fromMillisecondsSinceEpoch(timestamp).isBefore(cutoffTime);
    });

    HiveStorageManager.storePerformanceHistory(history);
  }
}