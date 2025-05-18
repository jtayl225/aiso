import 'package:aiso/models/cadence_enum.dart';
import 'package:aiso/models/db_timestamps_model.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/report_results.dart';
import 'package:aiso/models/search_target_model.dart';

class Report {
  final String id;
  final String userId;
  final String title;
  final String description;
  final Cadence cadence;
  List<Prompt>? prompts;
  SearchTarget? searchTarget;
  List<ReportResult>? results;
  final DbTimestamps dbTimestamps;
  final DateTime? lastRunAt;

  Report({
    required this.id, 
    required this.userId, 
    required this.title, 
    required this.description,
    required this.cadence,
    this.prompts,
    this.searchTarget,
    required this.dbTimestamps,
    this.lastRunAt
    });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      cadence: CadenceExtension.fromString(json['cadence'] as String),
      prompts: (json['prompts'] as List<dynamic>?)
        ?.map((item) => Prompt.fromJson(item))
        .toList() ?? [],
      // searchTarget: ,// TODO
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
      'user_id': userId,
      'title': title,
      'description': description,
      'cadence': cadence.toJson()
    };
  }

}