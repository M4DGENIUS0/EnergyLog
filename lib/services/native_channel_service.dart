import 'dart:async';
import 'package:app/model/battery_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeChannelService {
  static const String _batteryChannelName = 'com.energylog.app/battery_stream';
  static const String _batteryActionsChannelName =
      'com.energylog.app/battery_actions';

  /// Event Channel Here
  static const EventChannel _batteryChannel = EventChannel(_batteryChannelName);

  /// Method Channel Here
  static const MethodChannel _batteryActionsChannel = MethodChannel(
    _batteryActionsChannelName,
  );

  Stream<BatteryInfo> get batteryInfoStream {
    return _batteryChannel.receiveBroadcastStream().map((dynamic event) {
      if (event is Map) {
        return BatteryInfo.fromMap(event);
      }
      return BatteryInfo(
        voltage: 0.0,
        temperature: 0.0,
        health: "Unknown",
        technology: "Unknown",
        currentNow: 0,
        power: 0.0,
        chargeCounter: 0,
        timeRemaining: -1,
        screenTime: -1,
      );
    });
  }

  Future<void> openUsageSettings() async {
    try {
      await _batteryActionsChannel.invokeMethod('openUsageSettings');
    } on PlatformException catch (e) {
      throw Exception("Failed to open usage settings: '${e.message}'");
    }
  }

  Future<List<Map<String, dynamic>>> getTopUsedApps({
    String interval = 'daily',
  }) async {
    try {
      final List<dynamic> result = await _batteryActionsChannel.invokeMethod(
        'getTopUsedApps',
        {'interval': interval},
      );
      return result
          .cast<Map<dynamic, dynamic>>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } on PlatformException catch (e) {
      debugPrint("Failed to get top used apps: ${e.message}");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTodayLogEntries() async {
    try {
      final List<dynamic> result = await _batteryActionsChannel.invokeMethod(
        'getTodayLogEntries',
      );
      return result
          .cast<Map<dynamic, dynamic>>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } on PlatformException catch (e) {
      debugPrint("Failed to get today log entries: ${e.message}");
      return [];
    }
  }

  Future<bool> startLogging({int intervalMinutes = 15}) async {
    try {
      final bool? result = await _batteryActionsChannel.invokeMethod(
        'startLogging',
        {'intervalMinutes': intervalMinutes},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint("Failed to start logging: ${e.message}");
      return false;
    }
  }

  Future<bool> stopLogging() async {
    try {
      final bool? result = await _batteryActionsChannel.invokeMethod(
        'stopLogging',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint("Failed to stop logging: ${e.message}");
      return false;
    }
  }
}
