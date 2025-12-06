class SystemInfo {
  final int total; // in bytes
  final int used;  // in bytes

  SystemInfo({
    required this.total,
    required this.used,
  });

  factory SystemInfo.fromMap(Map<dynamic, dynamic> map) {
    return SystemInfo(
      total: (map['total'] as num).toInt(),
      used: (map['used'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'used': used,
    };
  }

  double get usedPercentage => total > 0 ? (used / total) * 100 : 0;
}