import 'package:aiso/models/db_timestamps_model.dart';
import 'package:aiso/models/location_models.dart';

class Prompt {
  final String id;
  final String? localityId;
  final Locality? locality;
  // final String templateId;
  // final String reportId;
  final String prompt;
  final DbTimestamps dbTimestamps; // createdAt, updatedAt, deletedAt
  // final DateTime? lastRunAt;

  Prompt({
    required this.id,
    this.localityId,
    this.locality,
    // required this.templateId, 
    // required this.reportId, 
    required this.prompt, 
    required this.dbTimestamps,
    // this.lastRunAt
    });

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['id'] as String,
      localityId: json['locality_id'] as String,
      locality: json['localities'] != null
        ? Locality.fromJson(json['localities'] as Map<String, dynamic>)
        : null,
      // templateId: json['template_id'] as String,
      // reportId: json['report_id'] as String,
      prompt: json['prompt'] as String,
      dbTimestamps: DbTimestamps(
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      ),
      // lastRunAt: json['last_run_at'] != null ? DateTime.parse(json['last_run_at']) : null,
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    return {
      if (includeId) 'id': id,
      // 'template_id': templateId,
      // 'report_id': reportId,
      'locality_id': localityId,
      'prompt': prompt,
    };
  }

  Prompt copyWith({
    String? id,
    String? localityId,
    Locality? locality,
    // String? templateId,
    String? reportId,
    String? prompt,
    DbTimestamps? dbTimestamps,
    // DateTime? lastRunAt,
  }) {
    return Prompt(
      id: id ?? this.id,
      localityId: localityId ?? this.localityId,
      locality: locality ?? this.locality,
      // templateId: templateId ?? this.templateId,
      // reportId: reportId ?? this.reportId,
      prompt: prompt ?? this.prompt,
      dbTimestamps: dbTimestamps ?? this.dbTimestamps,
      // lastRunAt: lastRunAt ?? this.lastRunAt,
    );
  }


}