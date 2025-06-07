/// Represents a country with its ISO codes, display name, and subdivisions (regions).
class Country {
  final String alpha2;
  final String alpha3;
  final String name;
  final List<Region> regions;

  const Country({
    required this.alpha2,
    required this.alpha3,
    required this.name,
    required this.regions,
  });

  /// Creates a Country from a JSON map.
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      alpha2: json['alpha2'] as String,
      alpha3: json['alpha3'] as String,
      name: json['name'] as String,
      regions: (json['regions'] as List<dynamic>? ?? [])
          .map((e) => Region.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts this Country to JSON.
  Map<String, dynamic> toJson() {
    return {
      'alpha2': alpha2,
      'alpha3': alpha3,
      'name': name,
      'regions': regions.map((r) => r.toJson()).toList(),
    };
  }

  /// Returns a copy of this Country with specified fields replaced.
  Country copyWith({
    String? alpha2,
    String? alpha3,
    String? name,
    List<Region>? regions,
  }) {
    return Country(
      alpha2: alpha2 ?? this.alpha2,
      alpha3: alpha3 ?? this.alpha3,
      name: name ?? this.name,
      regions: regions ?? List<Region>.from(this.regions),
    );
  }
}

/// Represents an administrative region within a country, with its code, name,
/// ISO code, and associated localities.
class Region {
  final String code;
  final String name;
  final String isoCode;
  final List<Locality> localities;

  const Region({
    required this.code,
    required this.name,
    required this.isoCode,
    required this.localities,
  });

  /// Creates a Region from a JSON map.
  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      code: json['code'] as String,
      name: json['name'] as String,
      isoCode: json['iso_code'] as String,
      localities: (json['localities'] as List<dynamic>? ?? [])
          .map((e) => Locality.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts this Region to JSON.
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'iso_code': isoCode,
      'localities': localities.map((l) => l.toJson()).toList(),
    };
  }

  /// Returns a copy of this Region with specified fields replaced.
  Region copyWith({
    String? code,
    String? name,
    String? isoCode,
    List<Locality>? localities,
  }) {
    return Region(
      code: code ?? this.code,
      name: name ?? this.name,
      isoCode: isoCode ?? this.isoCode,
      localities: localities ?? List<Locality>.from(this.localities),
    );
  }
}


/// A simple latitude/longitude pair.
class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);

  @override
  String toString() => 'LatLng($latitude, $longitude)';
}


class Locality {
  final String id;
  final String countryAlpha2;
  final String countryAlpha3;
  final String countryName;
  final String regionCode;
  final String regionIsoCode;
  final String regionName;
  final String name;
  final double latitude;
  final double longitude;

  Locality({
    required this.id,
    required this.countryAlpha2,
    required this.countryAlpha3,
    required this.countryName,
    required this.regionCode,
    required this.regionIsoCode, 
    required this.regionName,
    required this.name, 
    required this.latitude, 
    required this.longitude, 
    });

  factory Locality.fromJson(Map<String, dynamic> json) {
    return Locality(
      id: json['id'] as String,

      countryAlpha2: json['country_alpha2'] as String,
      countryAlpha3: json['country_alpha3'] as String,
      countryName: json['country_name'] as String,

      regionCode: json['region_code'] as String,
      regionIsoCode: json['region_iso_code'] as String,
      regionName: json['region_name'] as String,

      name: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'region_iso_code': regionIsoCode,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Locality copyWith({
    String? id,

    String? countryAlpha2,
    String? countryAlpha3,
    String? countryName,

    String? regionCode,
    String? regionIsoCode,
    String? regionName,

    String? name,
    double? latitude,
    double? longitude,

  }) {
   return Locality(
      id: id ?? this.id,
      countryAlpha2: countryAlpha2 ?? this.countryAlpha2,
      countryAlpha3: countryAlpha3 ?? this.countryAlpha3,
      countryName: countryName ?? this.countryName,
      regionCode: regionCode ?? this.regionCode,
      regionIsoCode: regionIsoCode ?? this.regionIsoCode,
      regionName: regionName ?? this.regionName,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

}