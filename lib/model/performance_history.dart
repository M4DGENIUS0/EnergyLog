class PerformanceHistory {
  final DateTime timestamp;
  final int ramUsed;
  final int ramTotal;
  final int batteryLevel;

  PerformanceHistory({
    required this.timestamp,
    required this.ramUsed,
    required this.ramTotal,
    required this.batteryLevel,
  });

  factory PerformanceHistory.fromMap(Map<String, dynamic> map) {
    return PerformanceHistory(
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      ramUsed: map['ram_used'] ?? 0,
      ramTotal: map['ram_total'] ?? 0,
      batteryLevel: map['battery_level'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'ram_used': ramUsed,
      'ram_total': ramTotal,
      'battery_level': batteryLevel,
    };
  }
}