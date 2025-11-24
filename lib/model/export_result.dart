class ExportResult {
  final String filePath;
  final bool success;

  ExportResult({required this.filePath, required this.success});

  factory ExportResult.fromMap(Map<String, dynamic> map) {
    return ExportResult(
      filePath: map['filePath'] ?? '',
      success: map['success'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'filePath': filePath,
      'success': success,
    };
  }
}