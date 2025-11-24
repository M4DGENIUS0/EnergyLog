class RAMInfo {
  final int totalMemory;
  final int availableMemory;
  final int usedMemory;
  final int threshold;
  final bool lowMemory;

  RAMInfo({
    required this.totalMemory,
    required this.availableMemory,
    required this.usedMemory,
    required this.threshold,
    required this.lowMemory,
  });

  factory RAMInfo.fromMap(Map<String, dynamic> map) {
    return RAMInfo(
      totalMemory: map['totalMemory'] ?? 0,
      availableMemory: map['availableMemory'] ?? 0,
      usedMemory: map['usedMemory'] ?? 0,
      threshold: map['threshold'] ?? 0,
      lowMemory: map['lowMemory'] ?? false,
    );
  }

  double get usagePercent {
    return totalMemory > 0 ? (usedMemory / totalMemory) * 100 : 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'totalMemory': totalMemory,
      'availableMemory': availableMemory,
      'usedMemory': usedMemory,
      'threshold': threshold,
      'lowMemory': lowMemory,
    };
  }
}