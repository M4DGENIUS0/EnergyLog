import 'dart:async';
import 'package:app/model/battery_info.dart';
import 'package:flutter/services.dart';

class NativeChannelService {
  static const String _batteryChannelName = 'com.energylog.app/battery_stream';
  static const String _batteryActionsChannelName = 'com.energylog.app/battery_actions';

  /// Event Channel Here
  static const EventChannel _batteryChannel = EventChannel(_batteryChannelName);

  /// Method Channel Here
  static const MethodChannel _batteryActionsChannel = MethodChannel(_batteryActionsChannelName);

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
}