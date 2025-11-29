import 'dart:async';
import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:app/widgets/generic_graph_widgets/generic_pie_graph_widget.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app/file/hive_storage_files/hive_storage_manager.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  // Event Channel for detailed stats
  static const EventChannel _batteryChannel = EventChannel('com.energylog.app/battery_stream');
  // Method Channel for actions
  static const MethodChannel _batteryActionsChannel = MethodChannel('com.energylog.app/battery_actions');
  StreamSubscription? _detailedStatsSubscription;

  // Detailed Stats
  double _voltage = 0.0;
  double _temperature = 0.0;
  String _health = "Unknown";
  String _technology = "Unknown";
  int _currentNow = 0;
  double _power = 0.0;
  int _chargeCounter = 0;
  int _timeRemaining = -1; // Minutes
  int _screenTime = -1; // Minutes, -1 means permission denied

  // Graph Data
  final List<FlSpot> _batteryHistory = [];
  Timer? _graphTimer;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) {
      if (mounted) {
        setState(() {
          _batteryState = state;
        });
      }
      _getBatteryLevel();
    });

    _startListeningToDetailedStats();
    _startGraphTracking();
  }

  void _startListeningToDetailedStats() {
    _detailedStatsSubscription = _batteryChannel.receiveBroadcastStream().listen((dynamic event) {
      if (event is Map) {
        if (mounted) {
          setState(() {
            _voltage = (event['voltage'] as num?)?.toDouble() ?? 0.0;
            _temperature = (event['temperature'] as num?)?.toDouble() ?? 0.0;
            _health = event['health'] as String? ?? "Unknown";
            _technology = event['technology'] as String? ?? "Unknown";
            _currentNow = (event['currentNow'] as num?)?.toInt() ?? 0;
            _power = (event['power'] as num?)?.toDouble() ?? 0.0;
            _chargeCounter = (event['chargeCounter'] as num?)?.toInt() ?? 0;
            _timeRemaining = (event['timeRemaining'] as num?)?.toInt() ?? -1;
            _screenTime = (event['screenTime'] as num?)?.toInt() ?? -1;
            
            // Also update level from native if available, as it might be more accurate/timely
            if (event['level'] != null) {
              _batteryLevel = (event['level'] as num).toInt();
            }
          });
        }
      }
    }, onError: (error) {
      debugPrint("Error receiving battery stats: $error");
    });
  }

  void _startGraphTracking() {
    // Add initial point
    _addToHistory();
    // Track every minute
    _graphTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _addToHistory();
    });
  }

  void _addToHistory() {
    if (!mounted) return;
    final now = DateTime.now();
    // Use minutes from start of day or similar relative time for X axis
    // For simplicity in this session view, we'll use relative minutes from app start or just timestamp
    // Let's use milliseconds since epoch converted to double for X, but scaled to be readable?
    // Actually, for a simple "Usage" graph, maybe just index or relative time.
    // Let's use relative minutes from when we started tracking.
    
    // Better: Store timestamp and value.
    setState(() {
      double xValue = _batteryHistory.length.toDouble(); // Simple increment for now
      _batteryHistory.add(FlSpot(xValue, _batteryLevel.toDouble()));
    });
  }

  Future<void> _getBatteryLevel() async {
    final int level = await _battery.batteryLevel;
    if (mounted) {
      setState(() {
        _batteryLevel = level;
      });
    }
  }

  Future<void> _openUsageSettings() async {
    try {
      await _batteryActionsChannel.invokeMethod('openUsageSettings');
    } on PlatformException catch (e) {
      debugPrint("Failed to open usage settings: '${e.message}'.");
    }
  }

  @override
  void dispose() {
    _batteryStateSubscription?.cancel();
    _detailedStatsSubscription?.cancel();
    _graphTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isCharging = _batteryState == BatteryState.charging || _batteryState == BatteryState.full;

    return SafeArea(
      top: true,
      // child: Scaffold(
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: .start,
              children: [
              SizedBox(height: 40,),
                _buildHeading("Hey", "Ahmad"),
                const SizedBox(height: 30),
                GenericCircularAnnotatedGraph(
                  batteryLevel: _batteryLevel,
                  isCharging: isCharging,
                  size: 350,
                  lineAxisColor: AppThemePreferences().appTheme.primaryColor!,
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
      // ),
    );
  }

  Widget _buildHeading(String heading, String userName){
    return Align(
      alignment: .centerLeft,
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .center,
        children: [
          GenericTextWidget(
            "👋 $heading, ${userName.split(" ")[0]}!",
            strutStyle: const StrutStyle(
              height: 3.0,
              forceStrutHeight: true,
            ),
            style: AppThemePreferences().appTheme.sliverUserNameTextStyle,
          ),
            Padding(
              padding:  EdgeInsets.only(left: 10),
              child: GenericTextWidget(
                "Let’s see how your battery is doing",
                style: AppThemePreferences().appTheme.sliverGreetingsTextStyle,
              ),
            ),

        ],
      ),
    );
  }


  String _getBatteryStateString(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return "Charging";
      case BatteryState.discharging:
        return "Discharging";
      case BatteryState.full:
        return "Full";
      case BatteryState.unknown:
        return "Unknown";
      default:
        return "Unknown";
    }
  }

  Widget _buildInfoRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: GenericInfoCard(
                title: "Voltage",
                icon: Icon(Icons.flash_on, color: APP_PRIMARY_COLOR,),
                suffix: "V",
                value: _voltage.toStringAsFixed(1),
                backgroundColor: APP_DARK_COLOR,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box(HiveStorageManager.userBoxName).listenable(keys: ['temp_unit_celsius']),
                builder: (context, box, _) {
                  bool isCelsius = box.get('temp_unit_celsius', defaultValue: true);
                  double displayTemp = isCelsius ? _temperature : (_temperature * 9 / 5) + 32;
                  return GenericInfoCard(
                    title: "Temperature",
                    icon: Icon(Icons.thermostat, color: APP_PRIMARY_COLOR,),
                    suffix: isCelsius ? "°C" : "°F",
                    value: displayTemp.toStringAsFixed(1),
                    backgroundColor: APP_DARK_COLOR,
                  );
                }
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: GenericInfoCard(
                title: "Health",
                icon: Icon(Icons.health_and_safety, color: APP_PRIMARY_COLOR,),
                suffix: "",
                value: _health,
                backgroundColor: APP_DARK_COLOR,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box(HiveStorageManager.userBoxName).listenable(keys: ['power_unit_watts']),
                builder: (context, box, _) {
                  bool isWatts = box.get('power_unit_watts', defaultValue: true);
                  double displayPower = isWatts ? _power : _power * 1000;
                  return GenericInfoCard(
                    title: "Power",
                    icon: Icon(Icons.electric_bolt, color: APP_PRIMARY_COLOR,),
                    suffix: isWatts ? "W" : "mW",
                    value: displayPower.toStringAsFixed(isWatts ? 2 : 0),
                    backgroundColor: APP_DARK_COLOR,
                  );
                }
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Screen Time Card
        GestureDetector(
          onTap: _screenTime == -1 ? _openUsageSettings : null,
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
                    const Text(
                      "Screen Time (Today)",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _screenTime == -1
                    ? Row(
                        children: [
                          const Text(
                            "Grant Permission",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.orangeAccent),
                        ],
                      )
                    : RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${(_screenTime / 60).floor()}h ${_screenTime % 60}m",
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
          const Text(
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
                ? const Center(child: Text("Collecting data...", style: TextStyle(color: Colors.white54)))
                : BarChart(
                    BarChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "${value.toInt()}m",
                                  style: const TextStyle(color: Colors.white54, fontSize: 10),
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
                              return Text(
                                "${value.toInt()}%",
                                style: const TextStyle(color: Colors.white54, fontSize: 10),
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
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const Spacer(),

          /// VALUE + SUFFIX using RichText
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
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
