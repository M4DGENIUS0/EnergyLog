class AppUsage {
  final String appName;
  final String packageName;
  final int usageTime; // in milliseconds
  final int lastUsed; // timestamp

  AppUsage({
    required this.appName,
    required this.packageName,
    required this.usageTime,
    required this.lastUsed,
  });

  factory AppUsage.fromMap(Map<String, dynamic> map) {
    return AppUsage(
      appName: map['appName'] ?? 'Unknown',
      packageName: map['packageName'] ?? '',
      usageTime: map['usageTime'] ?? 0,
      lastUsed: map['lastUsed'] ?? 0,
    );
  }

  /// Get usage time in minutes
  double get usageTimeInMinutes => usageTime / (1000 * 60);

  /// Get usage time in hours
  double get usageTimeInHours => usageTimeInMinutes / 60;

  /// Get formatted last used time
  String get lastUsedFormatted {
    final date = DateTime.fromMillisecondsSinceEpoch(lastUsed);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'packageName': packageName,
      'usageTime': usageTime,
      'lastUsed': lastUsed,
    };
  }

  @override
  String toString() {
    return 'AppUsage(appName: $appName, usageTime: ${usageTimeInMinutes.toStringAsFixed(2)} min)';
  }
}