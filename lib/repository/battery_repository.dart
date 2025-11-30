import 'dart:async';
import 'package:app/model/battery_info.dart';
import 'package:app/services/native_channel_service.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryRepository {
  final Battery _battery = Battery();
  final NativeChannelService _channelService = NativeChannelService();

  // Stream<int> get batteryLevelStream => _battery.onBatteryLevelChanged;

  Stream<BatteryState> get batteryStateStream => _battery.onBatteryStateChanged;

  Stream<BatteryInfo> get batteryInfoStream => _channelService.batteryInfoStream;

  Future<int> getCurrentBatteryLevel() => _battery.batteryLevel;

  Future<void> openUsageSettings() => _channelService.openUsageSettings();
}