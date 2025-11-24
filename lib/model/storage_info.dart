import 'package:app/model/storage_partition.dart';

class StorageInfo {
  final StoragePartition internal;
  final StoragePartition external;

  StorageInfo({required this.internal, required this.external});

  factory StorageInfo.fromMap(Map<String, dynamic> map) {
    return StorageInfo(
      internal: StoragePartition.fromMap(Map<String, dynamic>.from(map['internal'] ?? {})),
      external: StoragePartition.fromMap(Map<String, dynamic>.from(map['external'] ?? {})),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'internal': internal.toMap(),
      'external': external.toMap(),
    };
  }
}