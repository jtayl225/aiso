/// Auto-generated Dart model for Entity and EntityType, converted from Python definitions.

/// Enumerates the types of entities.
enum EntityType {
  product,
  service,
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
      type: EntityTypeExtension.fromValue(json['type'] as String),
      rank: json['rank'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      url: json['url'] as String?,
    );
  }

  /// Converts this [Entity] to a JSON map.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'type': type.toValue(),
      'rank': rank,
      'name': name,
      'description': description,
    };
    if (url != null) {
      map['url'] = url;
    }
    return map;
  }

  @override
  String toString() {
    return 'Entity(type: ${type.toValue()}, rank: $rank, name: $name, description: $description, url: $url)';
  }
}
