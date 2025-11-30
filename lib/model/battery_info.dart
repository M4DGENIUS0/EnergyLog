class BatteryInfo {
  final double voltage;
  final double temperature;
  final String health;
  final String technology;
  final int currentNow;
  final double power;
  final int chargeCounter;
  final int timeRemaining;
  final int screenTime;
  final int? level;

  BatteryInfo({
    required this.voltage,
    required this.temperature,
    required this.health,
    required this.technology,
    required this.currentNow,
    required this.power,
    required this.chargeCounter,
    required this.timeRemaining,
    required this.screenTime,
    this.level,
  });

  factory BatteryInfo.fromMap(Map<dynamic, dynamic> map) {
    return BatteryInfo(
      voltage: (map['voltage'] as num?)?.toDouble() ?? 0.0,
      temperature: (map['temperature'] as num?)?.toDouble() ?? 0.0,
      health: map['health'] as String? ?? "Unknown",
      technology: map['technology'] as String? ?? "Unknown",
      currentNow: (map['currentNow'] as num?)?.toInt() ?? 0,
      power: (map['power'] as num?)?.toDouble() ?? 0.0,
      chargeCounter: (map['chargeCounter'] as num?)?.toInt() ?? 0,
      timeRemaining: (map['timeRemaining'] as num?)?.toInt() ?? -1,
      screenTime: (map['screenTime'] as num?)?.toInt() ?? -1,
      level: (map['level'] as num?)?.toInt(),
    );
  }
}