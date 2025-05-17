import 'package:aiso/models/db_timestamps_model.dart';

class Prompt {
  final String id;
  final String templateId;
  final String reportId;
  final String rawPrompt;
  final String subject;
  final String context;
  final DbTimestamps dbTimestamps; // createdAt, updatedAt, deletedAt
  final DateTime? lastRunAt;

  Prompt({
    required this.id,
    required this.templateId, 
    required this.reportId, 
    required this.rawPrompt, 
    required this.subject, 
    required this.context, 
    required this.dbTimestamps,
    this.lastRunAt
    });

  /// Returns the rawPrompt with {subject} and {context} replaced
  String get formattedPrompt {
    return rawPrompt
      .replaceAll('{subject}', subject)
      .replaceAll('{context}', context);
  }

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['id'] as String,
      templateId: json['template_id'] as String,
      reportId: json['report_id'] as String,
      rawPrompt: json['raw_prompt'] as String,
      subject: json['subject'] as String,
      context: json['context'] as String,
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
      'raw_prompt': rawPrompt,
      'formatted_prompt': formattedPrompt,
      'subject': subject,
      'context': context
    };
  }

  Prompt copyWith({
    String? id,
    String? templateId,
    String? reportId,
    String? rawPrompt,
    String? subject,
    String? context,
    DbTimestamps? dbTimestamps,
    DateTime? lastRunAt,
  }) {
    return Prompt(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      reportId: reportId ?? this.reportId,
      rawPrompt: rawPrompt ?? this.rawPrompt,
      subject: subject ?? this.subject,
      context: context ?? this.context,
      dbTimestamps: dbTimestamps ?? this.dbTimestamps,
      lastRunAt: lastRunAt ?? this.lastRunAt,
    );
  }


}