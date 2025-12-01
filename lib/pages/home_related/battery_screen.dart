import 'dart:async';
import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/model/battery_info.dart';
import 'package:app/repository/battery_repository.dart';
import 'package:app/services/notification_service.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:app/widgets/generic_graph_widgets/generic_pie_graph_widget.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app/file/hive_storage_files/hive_storage_manager.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  final BatteryRepository _batteryRepository = BatteryRepository();

  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  BatteryInfo _batteryInfo = BatteryInfo(
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

  // StreamSubscription<int>? _batteryLevelSubscription;
  StreamSubscription<BatteryState>? _batteryStateSubscription;
  StreamSubscription<BatteryInfo>? _batteryInfoSubscription;

  // Graph Data
  final List<FlSpot> _batteryHistory = [];
  Timer? _graphTimer;

  bool get isCelsius => HiveStorageManager.readChangeTempretureUnit() ?? false;
  bool get isWatts => HiveStorageManager.readPowerUnit() ?? false;
  var rawFormats = HiveStorageManager.readNotificationFormat();
  List<String> notificationFormat = [];

  double get displayTemp => isCelsius
      ? _batteryInfo.temperature
      : (_batteryInfo.temperature * 9 / 5) + 32;

  double get displayPower =>
      isWatts ? _batteryInfo.power : _batteryInfo.power * 1000;

  @override
  void initState() {
    super.initState();
    _initializeBatteryListeners();
    _startGraphTracking();
  }

  void _initializeBatteryListeners() {
    // Get initial battery level
    _batteryRepository.getCurrentBatteryLevel().then((level) {
      if (mounted) {
        setState(() {
          _batteryLevel = level;
        });
      }
    });

    // Listen to battery level changes
    // _batteryLevelSubscription = _batteryRepository.batteryLevelStream.listen((level) {
    //   if (mounted) {
    //     setState(() {
    //       _batteryLevel = level;
    //     });
    //   }
    // });

    // Listen to battery state changes
    _batteryStateSubscription = _batteryRepository.batteryStateStream.listen((
      state,
    ) {
      if (mounted) {
        setState(() {
          _batteryState = state;
        });
      }
    });

    // Listen to detailed battery info
    _batteryInfoSubscription = _batteryRepository.batteryInfoStream.listen(
      (batteryInfo) {
        if (mounted) {
          setState(() {
            _batteryInfo = batteryInfo;
            // Update level from native if available
            if (batteryInfo.level != null) {
              _batteryLevel = batteryInfo.level!;
            }
          });
          _checkBatteryNotifications();
        }
      },
      onError: (error) {
        debugPrint("Error receiving battery stats: $error");
      },
    );
  }

  void _startGraphTracking() {
    _addToHistory();
    _graphTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _addToHistory();
    });
  }

  void _addToHistory() {
    if (!mounted) return;
    setState(() {
      double xValue = _batteryHistory.length.toDouble();
      _batteryHistory.add(FlSpot(xValue, _batteryLevel.toDouble()));
    });
  }

  Future<void> _openUsageSettings() async {
    try {
      await _batteryRepository.openUsageSettings();
    } catch (e) {
      debugPrint("Failed to open usage settings: $e");
    }
  }

  void _checkBatteryNotifications() {
    bool notificationsEnabled =
        HiveStorageManager.readNotificationEnabled() ?? false;
    if (!notificationsEnabled) return;

    var rawFormats = HiveStorageManager.readNotificationFormat();
    List<String> notificationFormat = [];
    if (rawFormats is List) {
      notificationFormat = rawFormats.cast<String>();
    }

    // Battery Full
    if (_batteryLevel == 100 &&
        (_batteryState == BatteryState.charging ||
            _batteryState == BatteryState.full) &&
        notificationFormat.contains("battery_full_charged")) {
      NotificationService().showNotification(
        "Battery Full",
        "Your battery is fully charged. Unplug to save energy.",
      );
    }

    // Low Battery
    if (_batteryLevel <= 20 &&
        _batteryState == BatteryState.discharging &&
        notificationFormat.contains("battery_low_power")) {
      NotificationService().showNotification(
        "Low Battery",
        "Battery is low ($_batteryLevel%). Please charge soon.",
      );
    }

    // High Temperature
    if (_batteryInfo.temperature > 45 &&
        notificationFormat.contains("temperature_high_alert")) {
      NotificationService().showNotification(
        "High Temperature",
        "Battery temperature is high (${_batteryInfo.temperature}°C). Cool down your device.",
      );
    }
  }

  @override
  void dispose() {
    // _batteryLevelSubscription?.cancel();
    _batteryStateSubscription?.cancel();
    _batteryInfoSubscription?.cancel();
    _graphTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isCharging =
        _batteryState == BatteryState.charging ||
        _batteryState == BatteryState.full;

    return SafeArea(
      top: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildHeading("Hey", "Ahmad"),
              const SizedBox(height: 30),
              GenericCircularAnnotatedGraph(
                batteryLevel: _batteryLevel,
                isCharging: isCharging,
                size: 350,
              ),
              const SizedBox(height: 40),
              _buildInfoRow(),
              const SizedBox(height: 30),
              _buildBatteryGraph(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeading(String heading, String userName) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GenericTextWidget(
            "👋 $heading, ${userName.split(" ")[0]}!",
            strutStyle: const StrutStyle(height: 3.0, forceStrutHeight: true),
            style: AppThemePreferences().appTheme.sliverUserNameTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GenericTextWidget(
              "Let's see how your battery is doing",
              style: AppThemePreferences().appTheme.sliverGreetingsTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GenericInfoCard(
                title: "Voltage",
                icon: Icon(Icons.flash_on, color: APP_PRIMARY_COLOR),
                suffix: "V",
                value: _batteryInfo.voltage.toStringAsFixed(1),
                backgroundColor: APP_DARK_COLOR,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GenericInfoCard(
                title: "Temperature",
                icon: Icon(Icons.thermostat, color: APP_PRIMARY_COLOR),
                suffix: isCelsius ? "°C" : "°F",
                value: displayTemp.toStringAsFixed(1),
                backgroundColor: APP_DARK_COLOR,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GenericInfoCard(
                title: "Health",
                icon: Icon(Icons.health_and_safety, color: APP_PRIMARY_COLOR),
                suffix: "",
                value: _batteryInfo.health,
                backgroundColor: APP_DARK_COLOR,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GenericInfoCard(
                title: "Power",
                icon: Icon(Icons.electric_bolt, color: APP_PRIMARY_COLOR),
                suffix: isWatts ? "W" : "mW",
                value: displayPower.toStringAsFixed(isWatts ? 2 : 0),
                backgroundColor: APP_DARK_COLOR,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Screen Time Card
        GestureDetector(
          onTap: _batteryInfo.screenTime == -1 ? _openUsageSettings : null,
          child: Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: APP_DARK_COLOR,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.screen_lock_portrait, color: APP_PRIMARY_COLOR),
                    const SizedBox(width: 6),
                    const GenericTextWidget(
                      "Screen Time (Today)",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(),
                _batteryInfo.screenTime == -1
                    ? Row(
                        children: [
                          const GenericTextWidget(
                            "Grant Permission",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.orangeAccent,
                          ),
                        ],
                      )
                    : RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${(_batteryInfo.screenTime / 60).floor()}h ${_batteryInfo.screenTime % 60}m",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryGraph() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: APP_DARK_COLOR,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GenericTextWidget(
            "Battery Usage (Session)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _batteryHistory.isEmpty
                ? const Center(
                    child: GenericTextWidget(
                      "Collecting data...",
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GenericTextWidget(
                                  "${value.toInt()}m",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              return GenericTextWidget(
                                "${value.toInt()}%",
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: _batteryHistory.map((spot) {
                        return BarChartGroupData(
                          x: spot.x.toInt(),
                          barRods: [
                            BarChartRodData(
                              toY: spot.y,
                              color: APP_PRIMARY_COLOR,
                              width: 12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                      maxY: 100,
                      minY: 0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class GenericInfoCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String value;
  final String suffix;
  final Color borderColor;
  final Color highlightColor;
  final double height;
  final Color backgroundColor;

  const GenericInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.suffix,
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.borderColor = const Color(0xFF2A2A2A),
    this.highlightColor = Colors.white,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 6),
              GenericTextWidget(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: highlightColor,
                  ),
                ),
                TextSpan(
                  text: suffix.isNotEmpty ? " $suffix" : "",
                  style: const TextStyle(fontSize: 14, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
