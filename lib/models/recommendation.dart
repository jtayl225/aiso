class Recommendation {
  final String id;
  final String reportRunId;
  final String recommendationId;
  final String? generatedComment;
  final bool isDone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String description;
  final String cadence;
  final String category;
  final int effort;
  final int reward;
  final String reportId;

  Recommendation({
    required this.id,
    required this.reportRunId,
    required this.recommendationId,
    this.generatedComment,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.description,
    required this.cadence,
    required this.category,
    required this.effort,
    required this.reward,
    required this.reportId,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'],
      reportRunId: json['report_run_id'],
      recommendationId: json['recommendation_id'],
      generatedComment: json['generated_comment'],
      isDone: json['is_done'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      name: json['name'],
      description: json['description'],
      cadence: json['cadence'],
      category: json['category'],
      effort: json['effort'],
      reward: json['reward'],
      reportId: json['report_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'report_run_id': reportRunId,
      'recommendation_id': recommendationId,
      'generated_comment': generatedComment,
      'is_done': isDone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'name': name,
      'description': description,
      'cadence': cadence,
      'category': category,
      'effort': effort,
      'reward': reward,
      'report_id': reportId,
    };
  }

  Recommendation copyWith({
    String? id,
    String? reportRunId,
    String? recommendationId,
    String? generatedComment,
    bool? isDone,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? name,
    String? description,
    String? cadence,
    String? category,
    int? effort,
    int? reward,
    String? reportId,
  }) {
    return Recommendation(
      id: id ?? this.id,
      reportRunId: reportRunId ?? this.reportRunId,
      recommendationId: recommendationId ?? this.recommendationId,
      generatedComment: generatedComment ?? this.generatedComment,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      cadence: cadence ?? this.cadence,
      category: category ?? this.category,
      effort: effort ?? this.effort,
      reward: reward ?? this.reward,
      reportId: reportId ?? this.reportId,
    );
  }
}
