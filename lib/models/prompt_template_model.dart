import 'package:aiso/models/db_timestamps_model.dart';

class PromptTemplate {
  final String id;
  final String rawPrompt;
  final String subject;
  final String context;
  final DbTimestamps dbTimestamps;

  PromptTemplate({
    required this.id,
    required this.rawPrompt,
    required this.subject,
    required this.context,
    required this.dbTimestamps,
  });

  /// Returns the rawPrompt with {subject} and {context} replaced
  String get formattedPrompt {
    return rawPrompt
      .replaceAll('{subject}', subject)
      .replaceAll('{context}', context);
  }

  factory PromptTemplate.fromJson(Map<String, dynamic> json) {
    return PromptTemplate(
      id: json['id'] as String,
      rawPrompt: json['raw_prompt'] as String,
      subject: json['subject'] as String,
      context: json['context'] as String,
      dbTimestamps: DbTimestamps(
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // often handled by backend/db
      'raw_prompt': rawPrompt,
      'subject': subject,
      'context': context,
    };
  }

  PromptTemplate copyWith({
    String? id,
    String? rawPrompt,
    String? subject,
    String? context,
    DbTimestamps? dbTimestamps,
    DateTime? lastRunAt,
  }) {
    return PromptTemplate(
      id: id ?? this.id,
      rawPrompt: rawPrompt ?? this.rawPrompt,
      subject: subject ?? this.subject,
      context: context ?? this.context,
      dbTimestamps: dbTimestamps ?? this.dbTimestamps,
    );
  }



}
