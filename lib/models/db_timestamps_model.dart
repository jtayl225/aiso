class DbTimestamps {
  final DateTime createdAt; // Timestamp when the record was created
  final DateTime updatedAt; // Timestamp when the record was last updated
  final DateTime? deletedAt; // Optional, timestamp when the record was deleted
  final DateTime? archivedAt; // Optional, timestamp when the record was archived

  DbTimestamps({
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.archivedAt,
  });

  factory DbTimestamps.now() {
    final now = DateTime.now();
    return DbTimestamps(
      createdAt: now,
      updatedAt: now,
    );
  }

  DbTimestamps copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    DateTime? archivedAt,
  }) {
    return DbTimestamps(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }

  factory DbTimestamps.fromJson(Map<String, dynamic> json) {
    return DbTimestamps(
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      archivedAt: json['archived_at'] != null ? DateTime.parse(json['archived_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (deletedAt != null) 'deleted_at': deletedAt!.toIso8601String(),
      if (archivedAt != null) 'archived_at': archivedAt!.toIso8601String(),
    };
  }

}

