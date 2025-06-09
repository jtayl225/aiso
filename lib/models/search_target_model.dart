import 'package:aiso/models/db_timestamps_model.dart';
import 'package:aiso/models/entity_model.dart';
import 'package:aiso/models/industry_model.dart';

class SearchTarget {
  final String id;
  final String reportId;
  final String name;          // e.g. "New Balance 1080v13"
  final EntityType type;          // e.g. "Product", "Service", "Business", "Person"
  final Industry? industry;
  final String description;   // Use case, benefits, location, etc. go here
  final String? url;          // Optional link to a website or product page
  final DbTimestamps dbTimestamps;

  SearchTarget({
    required this.id,
    required this.reportId,
    required this.name,
    required this.type,
    this.industry,
    required this.description,
    this.url,
    required this.dbTimestamps
  });

  factory SearchTarget.fromJson(Map<String, dynamic> json) {
    return SearchTarget(
      id: json['id'],
      reportId: json['report_id'],
      name: json['name'],
      type: EntityTypeExtension.fromValue(json['type']),
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

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'report_id': reportId,
      'industry_id': industry?.id,
      'type': type.name.toLowerCase(),
      'name': name,
      'description': description,
      'url': url
    };
  }

  SearchTarget copyWith({
    String? id,
    String? reportId,
    String? name,
    EntityType? type,
    Industry? industry,
    String? description,
    String? url,
    DbTimestamps? dbTimestamps,
  }) {
    return SearchTarget(
      id: id ?? this.id,
      reportId: reportId ?? this.reportId,
      name: name ?? this.name,
      type: type ?? this.type,
      industry: industry ?? this.industry,
      description: description ?? this.description,
      url: url ?? this.url,
      dbTimestamps: dbTimestamps ?? this.dbTimestamps,
    );
  }



}
