import 'package:aiso/models/db_timestamps_model.dart';

class PromptResult {
  final String id;
  final String reportId;
  final String runId;
  final String promptId;
  final int epoch;
  final String llm;
  final String entityType;
  final int rank;
  final String name;
  final String description;
  final bool isTarget;
  final String? url;
  final DbTimestamps dbTimestamps;

  PromptResult({
    required this.id,
    required this.reportId,
    required this.runId,
    required this.promptId,
    required this.epoch,
    required this.llm,
    required this.entityType,
    required this.rank,
    required this.name,
    required this.description,
    required this.isTarget,
    this.url,
    required this.dbTimestamps,
  });

  factory PromptResult.fromJson(Map<String, dynamic> json) {
    return PromptResult(
      id: json['id'] as String,
      reportId: json['report_id'] as String,
      runId: json['run_id'] as String,
      promptId: json['prompt_id'] as String,
      epoch: json['epoch'] as int,
      llm: json['llm'] as String,
      entityType: json['entity_type'] as String,
      rank: json['rank'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      isTarget: json['is_target'] as bool,
      url: json['url'] as String?,
      dbTimestamps: DbTimestamps.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'report_id': reportId,
      'run_id': runId,
      'prompt_id': promptId,
      'epoch': epoch,
      'llm': llm,
      'entity_type': entityType,
      'rank': rank,
      'name': name,
      'description': description,
      'is_target': isTarget,
      'url': url,
      // ...dbTimestamps.toJson(),
    };
  }
}
