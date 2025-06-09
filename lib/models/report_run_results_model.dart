import 'package:aiso/models/db_timestamps_model.dart';

class ReportRunResults {
  final String id;
  final String reportRunId;
  final String promptId;
  final String llmEpochId;
  final String status; // 'running', 'completed', 'failed'
  final bool targetFound;
  final int? targetRank;
  final DbTimestamps dbTimestamps; // createdAt, updatedAt, deletedAt

  ReportRunResults({
    required this.id,
    required this.reportRunId,
    required this.promptId,
    required this.llmEpochId,
    required this.status,
    required this.targetFound,
    this.targetRank,
    required this.dbTimestamps,
  });

  factory ReportRunResults.fromJson(Map<String, dynamic> json) {
    return ReportRunResults(
      id: json['id'] as String,
      reportRunId: json['report_run_id'] as String,
      promptId: json['prompt_id'] as String,
      llmEpochId: json['llm_epoch_id'] as String,
      status: json['status'] as String,
      targetFound: json['target_found'] as bool,
      targetRank: json['target_rank'],
      dbTimestamps: DbTimestamps(
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'report_run_id': reportRunId,
      'prompt_id': promptId,
      'llm_epoch_id': llmEpochId,
      'status': status,
      'target_found': targetFound,
      'target_rank': targetRank,
    };
  }

  ReportRunResults copyWith({
    String? id,
    String? reportRunId,
    String? promptId,
    String? llmEpochId,
    String? status,
    bool? targetFound,
    int? targetRank,
    DbTimestamps? dbTimestamps,
  }) {
    return ReportRunResults(
      id: id ?? this.id,
      reportRunId: reportRunId ?? this.reportRunId,
      promptId: promptId ?? this.promptId,
      llmEpochId: llmEpochId ?? this.llmEpochId,
      status: status ?? this.status,
      targetFound: targetFound ?? this.targetFound,
      targetRank: targetRank ?? this.targetRank,
      dbTimestamps: dbTimestamps ?? this.dbTimestamps,
    );
  }
}
