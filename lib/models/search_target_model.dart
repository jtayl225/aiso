import 'package:aiso/models/db_timestamps_model.dart';
import 'package:aiso/models/entity_model.dart';
import 'package:aiso/models/industry_model.dart';

class SearchTarget {
  final String id;
  // final String reportId;
  final String userId;
  final String name;          // e.g. "New Balance 1080v13"
  final EntityType entityType;          // e.g. "Product", "Service", "Business", "Person"
  final Industry? industry;
  final String description;   // Use case, benefits, location, etc. go here
  final String? url;          // Optional link to a website or product page
  final DbTimestamps dbTimestamps;

  SearchTarget({
    required this.id,
    // required this.reportId,
    required this.userId,
    required this.name,
    required this.entityType,
    this.industry,
    required this.description,
    this.url,
    required this.dbTimestamps
  });

  factory SearchTarget.fromJson(Map<String, dynamic> json) {
    return SearchTarget(
      id: json['id'],
      // reportId: json['report_id'],
      userId: json['user_id'],
      name: json['name'],
      entityType: EntityTypeExtension.fromValue(json['entity_type']),
      industry: json['industries'] != null
        ? Industry.fromJson(json['industries'])
        : null,
      description: json['description'],
      url: json['url'],
      dbTimestamps: DbTimestamps(
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      ),
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    return {
      if (includeId) 'id': id,
      // 'report_id': reportId,
      'user_id': userId,
      'industry_id': industry?.id,
      'entity_type': entityType.name.toLowerCase(),
      'name': name,
      'description': description,
      'url': url
    };
  }

  SearchTarget copyWith({
    String? id,
    // String? reportId,
    String? userId,
    String? name,
    EntityType? entityType,
    Industry? industry,
    String? description,
    String? url,
    DbTimestamps? dbTimestamps,
  }) {
    return SearchTarget(
      id: id ?? this.id,
      // reportId: reportId ?? this.reportId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      entityType: entityType ?? this.entityType,
      industry: industry ?? this.industry,
      description: description ?? this.description,
      url: url ?? this.url,
      dbTimestamps: dbTimestamps ?? this.dbTimestamps,
    );
  }



}
