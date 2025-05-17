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

}

