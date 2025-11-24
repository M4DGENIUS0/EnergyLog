import 'package:app/model/cpu_info.dart';
import 'package:app/model/network_info.dart';
import 'package:app/model/ram_info.dart';
import 'package:app/model/storage_info.dart';

class PerformanceStats {
  final CPUInfo cpu;
  final RAMInfo ram;
  final StorageInfo storage;
  final NetworkInfo network;

  PerformanceStats({
    required this.cpu,
    required this.ram,
    required this.storage,
    required this.network,
  });

  factory PerformanceStats.fromMap(Map<String, dynamic> map) {
    return PerformanceStats(
      cpu: CPUInfo.fromMap(Map<String, dynamic>.from(map['cpu'] ?? {})),
      ram: RAMInfo.fromMap(Map<String, dynamic>.from(map['ram'] ?? {})),
      storage: StorageInfo.fromMap(Map<String, dynamic>.from(map['storage'] ?? {})),
      network: NetworkInfo.fromMap(Map<String, dynamic>.from(map['network'] ?? {})),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cpu': cpu.toMap(),
      'ram': ram.toMap(),
      'storage': storage.toMap(),
      'network': network.toMap(),
    };
  }
}