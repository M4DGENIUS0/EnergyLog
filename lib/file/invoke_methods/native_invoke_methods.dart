// import 'package:app/file/utility_methods/enum_utilz.dart';
// import 'package:app/model/app_usage.dart';
// import 'package:app/model/battery_info.dart';
// import 'package:app/model/cpu_info.dart';
// import 'package:app/model/export_result.dart';
// import 'package:app/model/log_file.dart';
// import 'package:app/model/network_info.dart';
// import 'package:app/model/performance_stats.dart';
// import 'package:app/model/ram_info.dart';
// import 'package:app/model/storage_info.dart';
// import 'package:flutter/services.dart';
//
// class PowerMonitorService {
//   static const MethodChannel _channel = MethodChannel('power.monitor');
//
//   /// Battery Information Methods
//
//   /// Get complete battery information
//   static Future<BatteryInfo> getBatteryInfo() async {
//     try {
//       final Map<dynamic, dynamic> result =
//           await _channel.invokeMethod('getBatteryInfo');
//       return BatteryInfo.fromMap(Map<String, dynamic>.from(result));
//     } on PlatformException catch (e) {
//       throw PowerMonitorException('Failed to get battery info: ${e.message}');
//     }
//   }
//
//   /// Get battery level as percentage (0-100)
//   static Future<int> getBatteryLevel() async {
//     final info = await getBatteryInfo();
//     return info.level;
//   }
//
//   /// Get battery charging status
//   static Future<String> getBatteryStatus() async {
//     final info = await getBatteryInfo();
//     return info.status;
//   }
//
//   /// Performance Monitoring Methods
//
//   /// Get complete performance statistics
//   static Future<PerformanceStats> getPerformanceStats() async {
//     try {
//       final Map<dynamic, dynamic> result =
//           await _channel.invokeMethod('getPerformanceStats');
//       return PerformanceStats.fromMap(Map<String, dynamic>.from(result));
//     } on PlatformException catch (e) {
//       throw PowerMonitorException('Failed to get performance stats: ${e.message}');
//     }
//   }
//
//   /// Get CPU usage information
//   static Future<CPUInfo> getCPUUsage() async {
//     final stats = await getPerformanceStats();
//     return stats.cpu;
//   }
//
//   /// Get RAM/memory information
//   static Future<RAMInfo> getRAMInfo() async {
//     final stats = await getPerformanceStats();
//     return stats.ram;
//   }
//
//   /// Get storage information
//   static Future<StorageInfo> getStorageInfo() async {
//     final stats = await getPerformanceStats();
//     return stats.storage;
//   }
//
//   /// Get network usage information
//   static Future<NetworkInfo> getNetworkUsage() async {
//     final stats = await getPerformanceStats();
//     return stats.network;
//   }
//
//   /// App Usage Statistics Methods
//
//   /// Get top used apps for a specific interval
//   static Future<List<AppUsage>> getTopUsedApps({UsageInterval interval = UsageInterval.daily}) async {
//     try {
//       final List<dynamic> result = await _channel.invokeMethod(
//         'getTopUsedApps',
//         {'interval': interval.name},
//       );
//       return result.map((item) => AppUsage.fromMap(Map<String, dynamic>.from(item))).toList();
//     } on PlatformException catch (e) {
//       throw PowerMonitorException('Failed to get app usage: ${e.message}');
//     }
//   }
//
//   /// Get usage statistics for a specific app
//   static Future<AppUsage?> getAppUsage(String packageName, {int days = 1}) async {
//     try {
//       final Map<dynamic, dynamic> result = await _channel.invokeMethod(
//         'getAppUsage',
//         {'packageName': packageName, 'days': days},
//       );
//       return result.isEmpty ? null : AppUsage.fromMap(Map<String, dynamic>.from(result));
//     } on PlatformException catch (e) {
//       throw PowerMonitorException('Failed to get app usage: ${e.message}');
//     }
//   }
//
//   /// Permission Management Methods
//
//   /// Check if usage access permission is granted
//   static Future<bool> hasUsageAccessPermission() async {
//     try {
//       final bool result = await _channel.invokeMethod('hasUsageAccessPermission');
//       return result;
//     } on PlatformException catch (e) {
//       return false;
//     }
//   }
//
//   /// Open usage access settings
//   static Future<void> openUsageAccessSettings() async {
//     try {
//       await _channel.invokeMethod('openUsageAccessSettings');
//     } on PlatformException catch (e) {
//       throw PowerMonitorException('Failed to open settings: ${e.message}');
//     }
//   }
//
//   /// Background Logging Methods
//
//
//
//   /// Stop background logging
//
//
//   /// Data Export Methods
//
//   /// Export logs to JSON format
//   static Future<ExportResult> exportToJSON({int days = 7}) async {
//     try {
//       final Map<dynamic, dynamic> result = await _channel.invokeMethod(
//         'exportToJSON',
//         {'days': days},
//       );
//       return ExportResult.fromMap(Map<String, dynamic>.from(result));
//     } on PlatformException catch (e) {
//       throw PowerMonitorException('Failed to export JSON: ${e.message}');
//     }
//   }
//
//   /// Export logs to CSV format
//   static Future<ExportResult> exportToCSV({int days = 7}) async {
//     try {
//       final Map<dynamic, dynamic> result = await _channel.invokeMethod(
//         'exportToCSV',
//         {'days': days},
//       );
//       return ExportResult.fromMap(Map<String, dynamic>.from(result));
//     } on PlatformException catch (e) {
//       throw PowerMonitorException('Failed to export CSV: ${e.message}');
//     }
//   }
//   // Add these new methods to your PowerMonitorService class:
//
//   /// Log current data immediately
//   static Future<Map<String, dynamic>> logCurrentData() async {
//     try {
//       final result = await _channel.invokeMethod('logCurrentData');
//       return Map<String, dynamic>.from(result);
//     } on PlatformException catch (e) {
//       throw PowerMonitorException('Failed to log data: ${e.message}');
//     }
//   }
//
//   /// Start periodic logging
//   static Future<bool> startLogging({int intervalMinutes = 15}) async {
//     try {
//       final result = await _channel.invokeMethod(
//         'startLogging',
//         {'intervalMinutes': intervalMinutes},
//       );
//       return result ?? false;
//     } on PlatformException catch (e) {
//       throw PowerMonitorException('Failed to start logging: ${e.message}');
//     }
//   }
//
//   /// Stop periodic logging
//   static Future<bool> stopLogging() async {
//     try {
//       final result = await _channel.invokeMethod('stopLogging');
//       return result ?? false;
//     } on PlatformException catch (e) {
//       throw PowerMonitorException('Failed to stop logging: ${e.message}');
//     }
//   }
//
//   /// Get list of available log files
//   static Future<List<LogFile>> getAvailableLogs() async {
//     try {
//       final List<dynamic> result = await _channel.invokeMethod('getAvailableLogs');
//       return result.map((item) => LogFile.fromMap(Map<String, dynamic>.from(item))).toList();
//     } on PlatformException catch (e) {
//       throw PowerMonitorException('Failed to get logs: ${e.message}');
//     }
//   }
// }
//
// /// Custom Exceptions
//
// class PowerMonitorException implements Exception {
//   final String message;
//
//   PowerMonitorException(this.message);
//
//   @override
//   String toString() => 'PowerMonitorException: $message';
// }
