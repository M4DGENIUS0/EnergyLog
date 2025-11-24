class LogFile {
  final String fileName;
  final int fileSize;
  final int lastModified;
  final int entryCount;

  LogFile({
    required this.fileName,
    required this.fileSize,
    required this.lastModified,
    required this.entryCount,
  });

  factory LogFile.fromMap(Map<String, dynamic> map) {
    return LogFile(
      fileName: map['fileName'] ?? '',
      fileSize: map['fileSize'] ?? 0,
      lastModified: map['lastModified'] ?? 0,
      entryCount: map['entryCount'] ?? 0,
    );
  }

  /// Get file size in MB
  double get fileSizeInMB => fileSize / (1024 * 1024);

  /// Get formatted last modified date
  String get lastModifiedFormatted {
    final date = DateTime.fromMillisecondsSinceEpoch(lastModified);
    return '${date.day}/${date.month}/${date.year}';
  }

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'fileSize': fileSize,
      'lastModified': lastModified,
      'entryCount': entryCount,
    };
  }
}