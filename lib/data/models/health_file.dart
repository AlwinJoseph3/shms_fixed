class HealthFile {
  final String id;
  final String name;
  final String type;
  final DateTime uploadDate;
  final bool isAnalyzed;
  final DateTime? analysisDate;
  final String? summary;

  const HealthFile({
    required this.id,
    required this.name,
    required this.type,
    required this.uploadDate,
    this.isAnalyzed = false,
    this.analysisDate,
    this.summary,
  });

  factory HealthFile.fromJson(Map<String, dynamic> json) {
    final analysisDate = json['analysisDate'] != null
        ? DateTime.tryParse(json['analysisDate'])
        : null;

    return HealthFile(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unnamed File',
      type: json['type'] ?? 'pdf',
      uploadDate: DateTime.tryParse(json['uploadDate'] ?? '') ?? DateTime.now(),
      isAnalyzed: analysisDate != null,
      analysisDate: analysisDate,
      summary: json['summary'],
    );
  }


  // Create a dummy file for preview
  static HealthFile createDummy({
    required String id,
    required String name,
    String type = 'pdf',
    required DateTime uploadDate,
    bool isAnalyzed = false,
    DateTime? analysisDate,
    String? summary,
  }) {
    return HealthFile(
      id: id,
      name: name,
      type: type,
      uploadDate: uploadDate,
      isAnalyzed: isAnalyzed,
      analysisDate: analysisDate ?? (isAnalyzed ? DateTime.now() : null),
      summary:
          summary ?? (isAnalyzed ? 'Sample analysis summary for $name' : null),
    );
  }
}
