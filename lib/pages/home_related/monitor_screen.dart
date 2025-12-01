import 'dart:async';
import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/hive_storage_files/hive_storage_manager.dart';
import 'package:app/services/notification_service.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:system_info_plus/system_info_plus.dart';
import 'package:app/file/common/constants.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  List<FlSpot> ramSpots = [];
  List<FlSpot> cpuSpots = [];
  double _time = 0;
  Timer? _timer;
  int _totalMemory = 0;
  int _usedMemory = 0;

  static const EventChannel _systemChannel = EventChannel(
    'com.energylog.app/system_stream',
  );
  StreamSubscription? _systemSubscription;

  @override
  void initState() {
    super.initState();
    _startListeningToSystemInfo();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateGraph();
    });
  }

  void _startListeningToSystemInfo() {
    _systemSubscription = _systemChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        if (event is Map) {
          if (mounted) {
            setState(() {
              _totalMemory = (event['total'] as num?)?.toInt() ?? 0;
              _usedMemory = (event['used'] as num?)?.toInt() ?? 0;
            });
            _checkHighUsage();
          }
        }
      },
      onError: (error) {
        debugPrint("Error receiving system info: $error");
      },
    );
  }

  void _checkHighUsage() {
    if (_totalMemory > 0) {
      double usagePercentage = (_usedMemory / _totalMemory) * 100;

      bool notificationsEnabled =
          HiveStorageManager.readNotificationEnabled() ?? false;

      var rawFormats = HiveStorageManager.readNotificationFormat();
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

  void _updateGraph() {
    double ramPercent = _totalMemory > 0
        ? (_usedMemory / _totalMemory) * 100
        : 0;

    double cpuPercent = 0;
    try {
      cpuPercent = (DateTime.now().millisecond % 100).toDouble();
    } catch (e) {
      cpuPercent = 0;
    }

    if (mounted) {
      setState(() {
        _time++;
        if (ramSpots.length > 60) {
          ramSpots.removeAt(0);
          cpuSpots.removeAt(0);
        }
        ramSpots.add(FlSpot(_time, ramPercent));
        cpuSpots.add(FlSpot(_time, cpuPercent));
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _systemSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      // bottom: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: .start,
          children: [
            SizedBox(height: 40),

            _buildHeading(
              "Performance Monitor",
              "Monitor and analyze real-time system and application performance data",
            ),
            const SizedBox(height: 20),
            _buildMonitorCard(
              title: "RAM Usage",
              value:
                  "${(_usedMemory / 1024 / 1024).toStringAsFixed(0)} MB / ${(_totalMemory / 1024 / 1024).toStringAsFixed(0)} MB",
              spots: ramSpots,
              color: Colors.blueAccent,
              maxY: 100,
            ),
            const SizedBox(height: 20),
            _buildMonitorCard(
              title: "CPU Usage (Simulated)",
              value:
                  "${cpuSpots.isNotEmpty ? cpuSpots.last.y.toStringAsFixed(1) : '0'}% / 100%",
              spots: cpuSpots,
              color: Colors.redAccent,
              maxY: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading(String heading, String description) {
    return Align(
      alignment: .centerLeft,
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .center,
        children: [
          GenericTextWidget(
            "$heading",
            strutStyle: const StrutStyle(height: 3.0, forceStrutHeight: true),
            style: AppThemePreferences().appTheme.sliverUserNameTextStyle,
          ),
          GenericTextWidget(
            description,
            style: AppThemePreferences().appTheme.sliverGreetingsTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildMonitorCard({
    required String title,
    required String value,
    required List<FlSpot> spots,
    required Color color,
    required double maxY,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: AppThemePreferences().appTheme.containerBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        color: APP_DARK_COLOR,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GenericTextWidget(
                title,
                style: TextStyle(
                  fontSize: AppThemePreferences.titleFontSize,
                  fontWeight: AppThemePreferences.titleFontWeight,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppThemePreferences.titleTextColorDark
                      : AppThemePreferences.titleTextColorLight,
                ),
              ),
              GenericTextWidget(
                value,
                style: TextStyle(
                  fontSize: AppThemePreferences.bodyFontSize,
                  fontWeight: AppThemePreferences.bodyFontWeight,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppThemePreferences.bodyTextColorDark
                      : AppThemePreferences.bodyTextColorLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.white10),
                ),
                minX: spots.isNotEmpty ? spots.first.x : 0,
                maxX: spots.isNotEmpty ? spots.last.x : 60,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
