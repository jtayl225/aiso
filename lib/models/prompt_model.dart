import 'package:aiso/models/db_timestamps_model.dart';

class Prompt {
  final String id;
  final String templateId;
  final String reportId;
  final String prompt;
  final DbTimestamps dbTimestamps; // createdAt, updatedAt, deletedAt
  final DateTime? lastRunAt;

  Prompt({
    required this.id,
    required this.templateId, 
    required this.reportId, 
    required this.prompt, 
    required this.dbTimestamps,
    this.lastRunAt
    });

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['id'] as String,
      templateId: json['template_id'] as String,
      reportId: json['report_id'] as String,
      prompt: json['prompt'] as String,
      dbTimestamps: DbTimestamps(
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      ),
      lastRunAt: json['last_run_at'] != null ? DateTime.parse(json['last_run_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // handled by supabase
      'template_id': templateId,
      'report_id': reportId,
      'prompt': prompt,
    };
  }

  Prompt copyWith({
    String? id,
    String? templateId,
    String? reportId,
    String? prompt,
    DbTimestamps? dbTimestamps,
    DateTime? lastRunAt,
  }) {
    return Prompt(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      reportId: reportId ?? this.reportId,
      prompt: prompt ?? this.prompt,
      dbTimestamps: dbTimestamps ?? this.dbTimestamps,
      lastRunAt: lastRunAt ?? this.lastRunAt,
    );
  }


}