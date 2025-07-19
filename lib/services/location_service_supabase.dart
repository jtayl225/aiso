import 'package:aiso/models/location_models.dart';
import 'package:aiso/utils/logger.dart';
// import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class LocationServiceSupabase {
  final _supabase = Supabase.instance.client;

  Future<List<Country>> fetchCountries() async {

    printDebug('Service is fetching countries');

    final response = await _supabase
        .from('countries')
        .select('*, regions(code, name, iso_code)');

    // printDebug('countries response: $response');

    final List<Country> countries =
        (response as List).map((item) {
          return Country.fromJson(item);
        }).toList();

    debugPrint(
      'DEBUG: countries formatted: ${countries.first.regions.first.name}',
    );

    return countries;
  }

  // // (Re-use your existing hash helper)
  // String _hashString(String value) {
  //   final normalized = value.trim().toLowerCase();
  //   final bytes = utf8.encode(normalized);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  Future<Locality> fetchLocality(String localityId) async {
    printDebug(
      'DEBUG: Service is fetching locality for localityId: $localityId',
    );
    final response =
        await _supabase
            .from('locality_vw')
            .select()
            .eq('locality_id', localityId)
            .select()
            .single();
    // printDebug('DEBUG: report results response: $response');
    final Locality locality = Locality.fromJson(response);
    return locality;
  }

  Future<Locality?> fetchLocalityFromHash(String localityHash) async {
    printDebug('DEBUG: Service is fetching locality for hash: $localityHash');
    final response =
        await _supabase
            .from('localities')
            .select()
            .eq('locality_hash', localityHash)
            .select()
            .maybeSingle();
    if (response == null) return null;
    final Locality locality = Locality.fromJson(response);
    return locality;
  }

  Future<Locality> createLocality(Locality locality) async {
    printDebug(
      'DEBUG: Service is creating a locality: ${locality.regionIsoCode}, ${locality.name}.',
    );
    final response =
        await _supabase
            .from('localities')
            .insert(locality.toJson())
            .select()
            .single();
    final Locality insertedLocality = Locality.fromJson(response);
    printDebug('DEBUG: inserted Locality ID: ${insertedLocality.id}');
    return insertedLocality;
  }

  Future<List<Locality>> fetchNearbyLocalities(Locality locality) async {
    printDebug(
      'DEBUG: Service is fetchNearbyLocalities: ${locality.regionIsoCode}, ${locality.name}.',
    );
    final response = await _supabase.rpc(
      'find_nearby_localities',
      params: {
        'lat': locality.latitude,
        'lon': locality.longitude,
        'radius': 10000,
        'result_limit': 10,
      },
    );

    final List<Locality> localities =
        (response as List).map((item) {
          return Locality.fromJson(item);
        }).toList();

    return localities;
  }
}
