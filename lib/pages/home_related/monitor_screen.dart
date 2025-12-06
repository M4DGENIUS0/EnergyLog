import 'dart:async';
import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:app/services/native_channel_service.dart';
import 'package:app/services/system_monitor_service.dart';
import 'package:app/widgets/app_bar_widget.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/home_related/task_monitor_screen.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen>
    with TickerProviderStateMixin {
  List<FlSpot> ramSpots = [];
  List<FlSpot> cpuSpots = [];
  double _time = 0;
  Timer? _timer;
  int _totalMemory = 0;
  int _usedMemory = 0;
  TabController? _tabController;

  StreamSubscription? _systemSubscription;
  final SystemMonitorService _systemMonitorService = SystemMonitorService();
  final NativeChannelService _nativeChannelService = NativeChannelService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _startSystemMonitoring();
    _startGraphUpdateTimer();
    _startPerformanceLoggingTimer();
  }

  void _startSystemMonitoring() {
    _systemSubscription = _nativeChannelService.systemInfoStream.listen(
          (systemInfo) {
        if (mounted) {
          setState(() {
            _totalMemory = systemInfo.total;
            _usedMemory = systemInfo.used;
          });
          _systemMonitorService.checkAndNotifyHighMemoryUsage(
            usedMemory: _usedMemory,
            totalMemory: _totalMemory,
          );
        }
      },
      onError: (error) {
        debugPrint("Error receiving system info: $error");
      },
    );
  }

  void _startGraphUpdateTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateGraph();
    });
  }

  void _startPerformanceLoggingTimer() {
    Timer.periodic(const Duration(minutes: 5), (timer) {
      _logCurrentPerformance();
    });
  }

  void _logCurrentPerformance() {
    if (_totalMemory > 0) {
      _systemMonitorService.logPerformanceHistory(
        ramUsed: _usedMemory,
        ramTotal: _totalMemory,
        batteryLevel: 0,
      );
    }
  }

  void _updateGraph() {
    final double ramPercent = _totalMemory > 0
        ? (_usedMemory / _totalMemory) * 100
        : 0;

    final double cpuPercent = (DateTime.now().millisecond % 100).toDouble();

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
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBarWidget(
          elevation: 0,
          appBarTitle: UtilityMethods.getLocalizedString("performance_monitor"),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppThemePreferences().appTheme.primaryColor,
            labelColor: AppThemePreferences().appTheme.primaryColor,
            labelStyle: AppThemePreferences().appTheme.genericTabBarTextStyle,
            unselectedLabelColor:
            AppThemePreferences().appTheme.unselectedTabLabelColor,
            unselectedLabelStyle:
            AppThemePreferences().appTheme.genericTabBarTextStyle,
            tabs: [
              Tab(
                child: GenericTextWidget(
                  UtilityMethods.getLocalizedString("system_uasage"),
                ),
              ),
              Tab(
                child: GenericTextWidget(
                  UtilityMethods.getLocalizedString("app_usage"),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [_buildSystemMonitorTab(), const TaskMonitorScreen()],
        ),
      ),
    );
  }

  Widget _buildSystemMonitorTab() {
    return SafeArea(
      top: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildMonitorCard(
              title: "ram_usage",
              value:
              "${(_usedMemory / 1024 / 1024).toStringAsFixed(0)} MB / ${(_totalMemory / 1024 / 1024).toStringAsFixed(0)} MB",
              spots: ramSpots,
              color: Colors.blueAccent,
              maxY: 100,
            ),
            const SizedBox(height: 20),
            _buildMonitorCard(
              title: "cpu_usage",
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
        borderRadius: BorderRadius.circular(12),
        color: AppThemePreferences().appTheme.genericInfoCardColor,
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

                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(show: false),
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
                    preventCurveOverShooting: true,
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
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