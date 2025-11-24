class BatteryInfo {
  final int level;
  final double voltage;
  final double temperature;
  final String status;
  final String health;
  final String technology;

  BatteryInfo({
    required this.level,
    required this.voltage,
    required this.temperature,
    required this.status,
    required this.health,
    required this.technology,
  });

  factory BatteryInfo.fromMap(Map<String, dynamic> map) {
    return BatteryInfo(
      level: map['level'] ?? 0,
      voltage: (map['voltage'] ?? 0.0).toDouble(),
      temperature: (map['temperature'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'Unknown',
      health: map['health'] ?? 'Unknown',
      technology: map['technology'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'voltage': voltage,
      'temperature': temperature,
      'status': status,
      'health': health,
      'technology': technology,
    };
  }

  @override
  String toString() {
    return 'BatteryInfo(level: $level%, voltage: ${voltage}V, temperature: ${temperature}°C, status: $status, health: $health, technology: $technology)';
  }
}