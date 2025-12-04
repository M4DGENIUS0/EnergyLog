import 'dart:async';
import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:app/model/battery_info.dart';
import 'package:app/repository/battery_repository.dart';
import 'package:app/services/notification_service.dart';
import 'package:app/services/native_channel_service.dart';
import 'package:app/widgets/app_bar_widget.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:app/widgets/generic_graph_widgets/generic_pie_graph_widget.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:app/file/hive_storage_files/hive_storage_manager.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  final BatteryRepository _batteryRepository = BatteryRepository();
  final NativeChannelService _nativeChannelService = NativeChannelService();

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
  Timer? _graphTimer;

  // Graph Data
  List<BarChartGroupData> _hourlyData = [];
  bool _isLoadingGraph = true;

  // App Usage Data
  List<Map<String, dynamic>> _topApps = [];
  bool _isLoadingApps = true;

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
    _loadGraphData();
    _loadTopApps();
    // Start background logging if not already started
    _nativeChannelService.startLogging(intervalMinutes: 15);
    _graphTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _loadGraphData(),
    );
  }

  void _initializeBatteryListeners() {
    _batteryRepository.getCurrentBatteryLevel().then((level) {
      if (mounted) {
        setState(() {
          _batteryLevel = level;
        });
      }
    });

    _batteryStateSubscription = _batteryRepository.batteryStateStream.listen((
      state,
    ) {
      if (mounted) {
        // Check for charging status change notifications
        if (_batteryState != state) {
          _checkChargingNotifications(state);
        }
        setState(() {
          _batteryState = state;
        });
      }
    });

    _batteryInfoSubscription = _batteryRepository.batteryInfoStream.listen(
      (batteryInfo) {
        if (mounted) {
          setState(() {
            _batteryInfo = batteryInfo;
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

  Future<void> _loadGraphData() async {
    try {
      final entries = await _nativeChannelService.getTodayLogEntries();
      final Map<int, List<int>> hourlyLevels = {};

      for (var entry in entries) {
        if (entry['timestamp'] != null && entry['battery'] != null) {
          final timestamp = entry['timestamp'] as int;
          final batteryMap = entry['battery'] as Map;
          final level = int.tryParse(batteryMap['level'].toString()) ?? 0;

          final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final hour = date.hour;

          if (!hourlyLevels.containsKey(hour)) {
            hourlyLevels[hour] = [];
          }
          hourlyLevels[hour]!.add(level);
        }
      }

      List<BarChartGroupData> groups = [];
      for (int i = 0; i <= 23; i++) {
        double value = 0;
        if (hourlyLevels.containsKey(i)) {
          // Average level for the hour
          final levels = hourlyLevels[i]!;
          value = levels.reduce((a, b) => a + b) / levels.length;
        }

        groups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: value,
                color: APP_PRIMARY_COLOR,
                width: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
      }

      if (mounted) {
        setState(() {
          _hourlyData = groups;
          _isLoadingGraph = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading graph data: $e");
      if (mounted) {
        setState(() {
          _isLoadingGraph = false;
        });
      }
    }
  }

  Future<void> _loadTopApps() async {
    try {
      final apps = await _nativeChannelService.getTopUsedApps();
      if (mounted) {
        setState(() {
          _topApps = apps;
          _isLoadingApps = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading top apps: $e");
      if (mounted) {
        setState(() {
          _isLoadingApps = false;
        });
      }
    }
  }

  Future<void> _openUsageSettings() async {
    try {
      await _batteryRepository.openUsageSettings();
    } catch (e) {
      debugPrint("Failed to open usage settings: $e");
    }
  }

  void _checkChargingNotifications(BatteryState newState) {
    var rawFormats = HiveStorageManager.readNotificationFormat();
    List<String> notificationFormat = [];
    if (rawFormats is List) {
      notificationFormat = rawFormats.cast<String>();
    }

    if (newState == BatteryState.charging &&
        notificationFormat.contains("charging_started")) {
      NotificationService().showNotification(
        "Charging Started",
        "Device is now charging.",
      );
    } else if (_batteryState == BatteryState.charging &&
        newState == BatteryState.discharging &&
        notificationFormat.contains("charging_stopped")) {
      NotificationService().showNotification(
        "Charging Stopped",
        "Device is no longer charging.",
      );
    }

    if (notificationFormat.contains("charging_status_change")) {
      // Generic status change if needed, but usually started/stopped covers it.
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

    // Normal Temperature (Recovery) - simplistic logic, might need state to avoid spam
    if (_batteryInfo.temperature < 40 &&
        notificationFormat.contains("temperature_normal")) {
      // Logic to ensure we only notify once after being high
    }

    // Charging Limits (Simulated logic as we don't have user settings for limits yet)
    if (_batteryLevel >= 80 &&
        notificationFormat.contains("battery_charging_limit")) {
      // NotificationService().showNotification("Charging Limit Reached", "Battery reached 80%.");
    }

    if (_batteryLevel <= 20 &&
        notificationFormat.contains("battery_discharge_limit")) {
      // NotificationService().showNotification("Discharge Limit Reached", "Battery dropped below 20%.");
    }
  }

  @override
  void dispose() {
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

    return Scaffold(
      appBar: AppBarWidget(
        centerTitle: false,
        elevation: 0,
        appBarTitle: UtilityMethods.getLocalizedString(APP_NAME),

        automaticallyImplyLeading:  false ,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              GenericCircularAnnotatedGraph(
                batteryLevel: _batteryLevel,
                isCharging: isCharging,
                size: 300,
              ),
              const SizedBox(height: 40),
              _buildInfoRow(),
              const SizedBox(height: 30),
              _buildBatteryGraph(),
              const SizedBox(height: 30),
              _buildTopAppsSection(),
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
                icon: AppThemePreferences().appTheme.voltageIcon!,
                suffix: "V",
                value: _batteryInfo.voltage.toStringAsFixed(1),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GenericInfoCard(
                title: "Temperature",
                icon: AppThemePreferences().appTheme.tempratureIcon!,
                suffix: isCelsius ? "°C" : "°F",
                value: displayTemp.toStringAsFixed(1),
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
                icon: AppThemePreferences().appTheme.healthAndSafeIcon!,
                suffix: "",
                value: _batteryInfo.health,
                // backgroundColor: APP_DARK_COLOR,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GenericInfoCard(
                title: "Power",
                icon: AppThemePreferences().appTheme.powerIcon!,
                suffix: isWatts ? "W" : "mW",
                value: displayPower.toStringAsFixed(isWatts ? 2 : 0),
                // backgroundColor: APP_DARK_COLOR,
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
              color: AppThemePreferences().appTheme.genericInfoCardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppThemePreferences().appTheme.genericBorderColor!, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppThemePreferences().appTheme.screenTimeIcon!,
                    const SizedBox(width: 6),
                    GenericTextWidget(
                      "Screen Time (Today)",
                      style: AppThemePreferences().appTheme.genericInfoCardTitleTextStyle,
                    ),
                  ],
                ),
                const Spacer(),
                _batteryInfo.screenTime == -1
                    ? Row(
                        children: [
                          GenericTextWidget(
                            "Grant Permission",
                            style: AppThemePreferences().appTheme.requestPermissionTextStyle
                          ),
                          const SizedBox(width: 8),
                          AppThemePreferences().appTheme.requestPermissionIcon!
                        ],
                      )
                    : RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${(_batteryInfo.screenTime / 60).floor()}h ${_batteryInfo.screenTime % 60}m",
                              style: AppThemePreferences().appTheme.genericInfoCardHighlightTextStyle!
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
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemePreferences().appTheme.genericInfoCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GenericTextWidget(
                "Battery Usage (Today)",
                style: AppThemePreferences().appTheme.genericInfoCardTitleTextStyle,
              ),
              IconButton(
                icon: AppThemePreferences().appTheme.refreshIcon!,
                onPressed: _loadGraphData,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoadingGraph
                ? const Center(child: CircularProgressIndicator())
                : _hourlyData.isEmpty
                ? const Center(
                    child: GenericTextWidget(
                      "No data available yet",
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
                              if (value % 4 != 0)
                                return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GenericTextWidget(
                                  "${value.toInt()}h",
                                  style: AppThemePreferences().appTheme.genericInfoCardHighlightTextStyle!.copyWith(
                                    fontSize: 10
                                  )
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
                                style: AppThemePreferences().appTheme.genericInfoCardHighlightTextStyle!.copyWith(
                                    fontSize: 10
                                )
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: _hourlyData,
                      maxY: 100,
                      minY: 0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemePreferences().appTheme.genericInfoCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(
            "Top Power Consumers",
            style: AppThemePreferences().appTheme.genericInfoCardTitleTextStyle
          ),
          const SizedBox(height: 16),
          _isLoadingApps
              ? const Center(child: CircularProgressIndicator())
              : _topApps.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GenericTextWidget(
                      "No app usage data available.\nMake sure permission is granted.",
                      textAlign: TextAlign.center,
                      style:  AppThemePreferences().appTheme.genericInfoCardTitleTextStyle!,
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _topApps.length,
                  itemBuilder: (context, index) {
                    final app = _topApps[index];
                    final usageTime = app['usageTime'] as int;
                    final duration = Duration(milliseconds: usageTime);
                    final hours = duration.inHours;
                    final minutes = duration.inMinutes.remainder(60);

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: APP_PRIMARY_COLOR.withOpacity(0.2),
                        child: Text(
                          (app['appName'] as String)[0].toUpperCase(),
                          style: TextStyle(color: APP_PRIMARY_COLOR),
                        ),
                      ),
                      title: GenericTextWidget(
                        app['appName'] as String,
                        style: AppThemePreferences().appTheme.genericInfoCardHighlightTextStyle!.copyWith(
                            fontSize: 16
                        ),
                      ),
                      subtitle: GenericTextWidget(
                        app['packageName'] as String,
                        style: AppThemePreferences().appTheme.genericInfoCardTitleTextStyle
                      ),
                      trailing: GenericTextWidget(
                        "${hours}h ${minutes}m",
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: APP_DARK_COLOR,
          title: const GenericTextWidget(
            "7-Day Battery History",
            style: TextStyle(color: Colors.white),
          ),
          content: const SizedBox(
            width: double.maxFinite,
            height: 100,
            child: Center(
              child: GenericTextWidget(
                "History feature coming soon!",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

class GenericInfoCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String value;
  final String suffix;
  final Color? borderColor;
  final Color? highlightColor;
  final double height;
  final Color? backgroundColor;

  GenericInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.suffix,
    this.backgroundColor,
    this.borderColor ,
    this.highlightColor,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppThemePreferences().appTheme.genericInfoCardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor ?? AppThemePreferences().appTheme.genericBorderColor!, width: 1),
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
                style: AppThemePreferences().appTheme.genericInfoCardTitleTextStyle,
                // style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppThemePreferences().appTheme.genericInfoCardHighlightTextStyle
                ),
                TextSpan(
                  text: suffix.isNotEmpty ? " $suffix" : "",
                  style: AppThemePreferences().appTheme.genericInfoCardTitleTextStyle!.copyWith(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
