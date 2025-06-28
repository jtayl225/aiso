/// Enumerates the types of entities.
enum EntityType {
  // product,
  // service,
  business,
  person,
}

extension EntityTypeExtension on EntityType {
  /// Convert enum to its string value.
  String toValue() => toString().split('.').last;

  /// Create an enum from its string representation.
  static EntityType fromValue(String value) {
    return EntityType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => throw ArgumentError('Unknown EntityType: $value'),
    );
  }
}

/// Represents an entity with type, rank, name, description, and optional URL.
class Entity {
  final EntityType type;
  final int rank;
  final String name;
  final String description;
  final String? url;

  Entity({
    required this.type,
    required this.rank,
    required this.name,
    required this.description,
    this.url,
  });

  /// Creates an [Entity] from a JSON map.
  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      type: EntityTypeExtension.fromValue(json['entity_type'] as String),
      rank: json['entity_rank'] as int,
      name: json['entity_name'] as String,
      description: json['entity_description'] as String,
      url: json['entity_url'] as String?,
    );
  }

  /// Converts this [Entity] to a JSON map.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'entity_type': type.toValue(),
      'entity_rank': rank,
      'entity_name': name,
      'entity_description': description,
    };
    if (url != null) {
      map['entity_url'] = url;
    }
    return map;
  }

  @override
  String toString() {
    return 'Entity(type: ${type.toValue()}, rank: $rank, name: $name, description: $description, url: $url)';
  }
}
