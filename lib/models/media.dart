class Media {
  int id;
  String modelType;
  int modelId;
  String mimetype;
  String fileName;
  String path;
  DateTime createdAt;
  DateTime updatedAt;

  Media({
    required this.id,
    required this.modelType,
    required this.modelId,
    required this.mimetype,
    required this.fileName,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json['id'] as int,
        modelType: json['modelType'],
        modelId: json['modelId'],
        mimetype: json['mimetype'] ?? "",
        fileName: json['filename'] ?? "",
        path: json['path'] ?? "",
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
