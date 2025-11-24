class StoragePartition {
  final int total;
  final int available;
  final int used;

  StoragePartition({
    required this.total,
    required this.available,
    required this.used,
  });

  factory StoragePartition.fromMap(Map<String, dynamic> map) {
    return StoragePartition(
      total: map['total'] ?? 0,
      available: map['available'] ?? 0,
      used: map['used'] ?? 0,
    );
  }

  double get usagePercent {
    return total > 0 ? (used / total) * 100 : 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'available': available,
      'used': used,
    };
  }
}