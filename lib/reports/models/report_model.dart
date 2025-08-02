import 'package:aiso/models/cadence_enum.dart';
import 'package:aiso/models/db_timestamps_model.dart';
import 'package:aiso/models/location_models.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/recommendation.dart';
import 'package:aiso/models/report_results.dart';
import 'package:aiso/models/search_target_model.dart';

class Report {
  final String id;
  final String? localityId;
  final Locality? locality;
  final String userId;
  final String searchTargetId;
  final String title;
  // final String description;
  final bool isPaid;
  final Cadence cadence;
  List<Prompt>? prompts;
  SearchTarget? searchTarget;
  List<ReportResult>? results;
  List<Recommendation>? recommendations;
  final DbTimestamps dbTimestamps;
  final DateTime? lastRunAt;

  Report({
    required this.id,
    this.localityId,
    this.locality,
    required this.userId,
    required this.searchTargetId, 
    required this.title, 
    // required this.description,
    required this.isPaid, 
    required this.cadence,
    this.prompts,
    this.searchTarget,
    this.results,
    this.recommendations,
    required this.dbTimestamps,
    this.lastRunAt
    });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      localityId: json['locality_id'] as String?,
      locality: json['localities'] != null
        ? Locality.fromJson(json['localities'] as Map<String, dynamic>)
        : null,
      userId: json['user_id'] as String,
      searchTargetId: json['search_target_id'] as String,
      title: json['title'] as String,
      // description: json['description'] as String,
      isPaid: json['is_paid'] as bool,
      cadence: CadenceExtension.fromString(json['cadence'] as String),
      prompts: (json['prompts'] as List<dynamic>?)
        ?.map((item) => Prompt.fromJson(item))
        .toList() ?? [],
      // searchTarget: (json['search_targets'] as List<dynamic>?)?.isNotEmpty == true
      //   ? SearchTarget.fromJson(json['search_targets'][0])
      //   : null,
      searchTarget: json['search_targets'] != null
        ? SearchTarget.fromJson(json['search_targets'])
        : null,
      recommendations: (json['report_run_recommendations_vw'] as List<dynamic>?)
        ?.map((item) => Recommendation.fromJson(item))
        .toList() ?? [],
      dbTimestamps: DbTimestamps(
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      ),
      lastRunAt: json['last_run_at'] != null ? DateTime.parse(json['last_run_at']) : null,
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    return {
      if (includeId) 'id': id,
      'locality_id': localityId,
      'user_id': userId,
      'search_target_id': searchTargetId,
      'title': title,
      // 'description': description,
      'is_paid': isPaid,
      'cadence': cadence.toJson()
    };
  }

  Report copyWith({
    String? id,
    String? localityId,
    Locality? locality,
    String? userId,
    String? searchTargetId,
    String? title,
    // String? description,
    bool? isPaid,
    Cadence? cadence,
    List<Prompt>? prompts,
    SearchTarget? searchTarget,
    List<ReportResult>? results,
    List<Recommendation>? recommendations,
    DbTimestamps? dbTimestamps,
    DateTime? lastRunAt,
  }) {
    return Report(
      id: id ?? this.id,
      localityId: localityId ?? this.localityId,
      locality: locality ?? this.locality,
      userId: userId ?? this.userId,
      searchTargetId: searchTargetId ?? this.searchTargetId,
      title: title ?? this.title,
      // description: description ?? this.description,
      isPaid: isPaid ?? this.isPaid,
      cadence: cadence ?? this.cadence,
      // Clone the list if provided, else clone current if not null, else null
      prompts: prompts ?? (this.prompts != null ? List<Prompt>.from(this.prompts!) : null),
      searchTarget: searchTarget ?? this.searchTarget,
      results: results ?? (this.results != null ? List<ReportResult>.from(this.results!) : null),
      recommendations: recommendations ?? (this.recommendations != null ? List<Recommendation>.from(this.recommendations!) : null),
      dbTimestamps: dbTimestamps ?? this.dbTimestamps,
      lastRunAt: lastRunAt ?? this.lastRunAt,
    );
  }

}