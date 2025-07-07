import 'package:aiso/models/db_timestamps_model.dart';

class PromptResult {
  final String id;
  final String reportId;
  final String reportRunId;
  final String promptId;
  final int epoch;
  final String llmGeneration;

  final String entityType;
  final int entityRank;
  final String entityName;
  final String entityDescription;
  final String? entityUrl;

  final bool isTarget;
  
  final DbTimestamps dbTimestamps;

  PromptResult({
    required this.id,
    required this.reportId,
    required this.reportRunId,
    required this.promptId,
    required this.epoch,
    required this.llmGeneration,
    required this.entityType,
    required this.entityRank,
    required this.entityName,
    required this.entityDescription,
    this.entityUrl,
    required this.isTarget,
    required this.dbTimestamps,
  });

  factory PromptResult.fromJson(Map<String, dynamic> json) {
    return PromptResult(
      id: json['id'] as String,
      reportId: json['report_id'] as String,
      reportRunId: json['report_run_id'] as String,
      promptId: json['prompt_id'] as String,
      epoch: json['epoch'] as int,
      llmGeneration: json['llm_generation'] as String ?? 'unknown',
      entityType: json['entity_type'] as String,
      entityRank: json['entity_rank'] as int,
      entityName: json['entity_name'] as String,
      entityDescription: json['entity_description'] as String,
      entityUrl: json['entity_url'] as String?,
      isTarget: json['is_target'] as bool,
      dbTimestamps: DbTimestamps.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'report_id': reportId,
      'report_run_id': reportRunId,
      'prompt_id': promptId,
      'epoch': epoch,
      'llm_generation': llmGeneration,
      'entity_type': entityType,
      'entity_rank': entityRank,
      'entity_name': entityName,
      'entity_description': entityDescription,
      'entity_url': entityUrl,
      'is_target': isTarget,
      // ...dbTimestamps.toJson(),
    };
  }
}
