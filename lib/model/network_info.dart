class NetworkInfo {
  final int receivedBytes;
  final int transmittedBytes;
  final int totalBytes;

  NetworkInfo({
    required this.receivedBytes,
    required this.transmittedBytes,
    required this.totalBytes,
  });

  factory NetworkInfo.fromMap(Map<String, dynamic> map) {
    return NetworkInfo(
      receivedBytes: map['receivedBytes'] ?? 0,
      transmittedBytes: map['transmittedBytes'] ?? 0,
      totalBytes: map['totalBytes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'receivedBytes': receivedBytes,
      'transmittedBytes': transmittedBytes,
      'totalBytes': totalBytes,
    };
  }
}