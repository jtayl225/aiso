import 'dart:convert';

extension on int? {
  String toEffortString() {
    switch (this) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Unknown';
    }
  }

  String toRewardString() {
    switch (this) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Unknown';
    }
  }
}

class Recommendation {
  final String id;
  final String reportId;
  final String reportRunId;
  final String? localityId;
  final String title;
  final String action;
  final String description;
  final String status;
  final String category;
  final String cadence;
  final int effort;
  final int reward;
  final List<String> frameworkPillars;
  final int feedback;
  final String llmModel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  String get effortString => effort.toEffortString();
  String get rewardString => reward.toRewardString(); // ← was effort before

  Recommendation({
    required this.id,
    required this.reportId,
    required this.reportRunId,
    this.localityId,
    required this.title,
    required this.action,
    required this.description,
    required this.status,
    required this.category,
    required this.cadence,
    required this.effort,
    required this.reward,
    required this.frameworkPillars,
    required this.feedback,
    required this.llmModel,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  // --- Helpers ---
  static DateTime _parseDate(dynamic v) =>
      v is DateTime ? v : DateTime.parse(v as String);

  static DateTime? _parseDateNullable(dynamic v) {
    if (v == null) return null;
    return v is DateTime ? v : DateTime.parse(v as String);
  }

  static List<String> _parseStringList(dynamic v) {
    if (v == null) return <String>[];
    if (v is List) {
      return v.map((e) => e.toString()).toList();
    }
    // If backend sends a JSON string (e.g. '["a","b"]')
    try {
      final decoded = jsonDecode(v as String);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return <String>[];
  }

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'] as String,
      reportId: json['report_id'] as String,
      reportRunId: json['report_run_id'] as String,
      localityId: json['locality_id'] as String?,
      title: json['title'] as String,
      action: json['action'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      category: json['category'] as String,
      cadence: json['cadence'] as String,
      effort: (json['effort'] as num).toInt(),
      reward: (json['reward'] as num).toInt(),
      frameworkPillars: _parseStringList(json['framework_pillars']),
      feedback: (json['feedback'] as num).toInt(),
      llmModel: json['llm_model'] as String,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      deletedAt: _parseDateNullable(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'report_id': reportId,
      'report_run_id': reportRunId,
      'locality_id': localityId,
      'title': title,
      'action': action,
      'description': description,
      'status': status,
      'category': category,
      'cadence': cadence,
      'effort': effort,
      'reward': reward,
      'framework_pillars': frameworkPillars,
      'feedback': feedback,
      'llm_model': llmModel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Recommendation copyWith({
    String? id,
    String? reportId,
    String? reportRunId,
    String? title,
    String? action,
    String? description,
    String? status,
    String? category,
    String? cadence,
    int? effort,
    int? reward,
    List<String>? frameworkPillars,
    int? feedback,
    String? llmModel,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt, // pass null explicitly to clear it
  }) {
    return Recommendation(
      id: id ?? this.id,
      reportId: reportId ?? this.reportId,
      reportRunId: reportRunId ?? this.reportRunId,
      title: title ?? this.title,
      action: action ?? this.action,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      cadence: cadence ?? this.cadence,
      effort: effort ?? this.effort,
      reward: reward ?? this.reward,
      frameworkPillars: frameworkPillars ?? this.frameworkPillars,
      feedback: feedback ?? this.feedback,
      llmModel: llmModel ?? this.llmModel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt == null && this.deletedAt != null
          ? null
          : deletedAt ?? this.deletedAt,
    );
  }
}
