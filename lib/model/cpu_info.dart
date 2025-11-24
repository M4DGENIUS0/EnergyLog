class CPUInfo {
  final double usagePercent;
  final int cores;

  CPUInfo({required this.usagePercent, required this.cores});

  factory CPUInfo.fromMap(Map<String, dynamic> map) {
    return CPUInfo(
      usagePercent: (map['usagePercent'] ?? 0.0).toDouble(),
      cores: map['cores'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usagePercent': usagePercent,
      'cores': cores,
    };
  }
}