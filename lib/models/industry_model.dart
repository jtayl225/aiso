/// Defines the Industry model with JSON serialization and copyWith support.
class Industry {
  final String id;
  final String name;

  const Industry({
    required this.id,
    required this.name,
  });

  /// Creates a new Industry object from a JSON map.
  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  /// Converts this Industry to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  /// Returns a copy of this Industry with the given fields replaced.
  Industry copyWith({
    String? id,
    String? name,
  }) {
    return Industry(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'Industry(id: \$id, name: \$name)';
}
