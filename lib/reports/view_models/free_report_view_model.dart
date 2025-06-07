import 'dart:convert';

import 'package:aiso/models/entity_model.dart';
import 'package:aiso/models/industry_model.dart';
import 'package:aiso/models/location_models.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/search_target_model.dart';
import 'package:aiso/reports/models/report_model.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Reuse enum for report_run_status
enum ReportRunStatus { initialising, generating, searching, completed, failed }

extension ReportRunStatusX on ReportRunStatus {
  String get name => toString().split('.').last;
  static ReportRunStatus fromString(String value) => ReportRunStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ReportRunStatus.initialising,
      );
}

/// A ChangeNotifier ViewModel to handle state & logic for the FreeReport flow.
/// It listens to supabase realtime on report_runs for status updates,
/// and drives both timeline and result screens.
class FreeReportViewModel extends ChangeNotifier {
  
  final String prompt;
  final List<Entity> entities;
  final int searchTargetRank;
  final String reportRunId;
  bool isLoading = false;
  String? errorMessage;
  final ReportServiceSupabase _reportService = ReportServiceSupabase();

  List<Industry> industries = [];
  Industry? selectedIndustry;

  List<Country> countries = [];
  Country? selectedCountry;
  Region? selectedRegion;
  Locality? selectedLocality;

  // track purchase reveals
  final Set<int> _revealed = {};

  // current status from report_runs
  ReportRunStatus _currentStatus = ReportRunStatus.initialising;
  ReportRunStatus get currentStatus => _currentStatus;

  // Supabase subscription
  RealtimeChannel? _subscription;

  FreeReportViewModel({
    required this.prompt,
    required this.entities,
    required this.searchTargetRank,
    required this.reportRunId,
  }) {
    _initSupabaseListener();
  }

  void _handleError(Object error, [StackTrace? stackTrace]) {
    errorMessage = error.toString();

    debugPrint('ReportViewModel error: $errorMessage');
    
    if (stackTrace != null) {
      debugPrint('Stack trace:\n$stackTrace');
    }

    // You can add extra error handling logic here, like:
    // - showing user-friendly messages
    // - sending logs to remote error tracking services
  }

  /// Listen for realtime changes on report_runs.status
  void _initSupabaseListener() {
    final supabase = Supabase.instance.client;
    // Create a dedicated channel for listening to updates on the 'report_runs' table
    _subscription = supabase
        .channel('public:report_runs')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'report_runs',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: reportRunId,
          ),
          callback: (payload) {
            final newStatus = payload.newRecord['status'] as String;
            final statusEnum = ReportRunStatusX.fromString(newStatus);
            if (statusEnum != _currentStatus) {
              _currentStatus = statusEnum;
              notifyListeners();
            }
          },
        )
        .subscribe();
  }

  /// Whether the card at [index] should be fully shown.
  bool canShow(int index) {
    return entities[index].rank == searchTargetRank || _revealed.contains(index);
  }

  /// Mark the card as revealed after purchase.
  void reveal(int index) {
    _revealed.add(index);
    notifyListeners();
  }

  @override
  void dispose() {
    if (_subscription != null) {
      Supabase.instance.client.removeChannel(_subscription!);
    }
    super.dispose();
  }

  String _hashString(String value) {
      final normalized = value.trim().toLowerCase();
      final bytes = utf8.encode(normalized);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

  Future<bool> createAndRunFreeReport(Report freeReport, SearchTarget freeSearchTarget, String freePromptText, Locality freeLocality) async {
    isLoading = true;
    notifyListeners();
    try {
      debugPrint('DEBUG: createAndRunFreeReport.');

      // create report
      final Report report = await _reportService.createReport(freeReport);

      // // fetch parent prompt given industry
      // final String parentPrompt = '';
      // final String freePromptText = parentPrompt + ' in ${locality.name}, ${locality.region_code} ${locality.country_name}';

      // creates prompt - handles upserts of new prompts
      final Prompt _ = await _reportService.upsertPromptAndAttach(reportId: report.id, promptText: freePromptText);

      // create search target
      final SearchTarget updatedSearchTarget = freeSearchTarget.copyWith(reportId: report.id);
      await _reportService.createSearchTarget(updatedSearchTarget);

      // init free report run
      await _reportService.runReport(report);

      // setup supabase listener
       _initSupabaseListener();
      
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Locality?> fetchLocality(String regionIsoCode, String localityName) async {
    // 1) show loading
    isLoading = true;
    notifyListeners();
    try {
      debugPrint('DEBUG: createAndRunFreeReport.');

      // 2) compute normalized hash
      final String localityHash = _hashString(regionIsoCode + localityName);

      // 3) attempt to fetch an existing one
      final Locality? existingLocality = await _reportService.fetchLocalityFromHash(localityHash);
      if (existingLocality != null) return existingLocality;

      // // 4) not found → correct spelling via ChatGPT
      // final String correctedName = await _reportService.correctLocalityName(
      //   regionIsoCode: regionIsoCode,
      //   rawName: localityName,
      // );

      // // 5) geocode the corrected name
      // final LatLng coords = await _reportService.geocodeLocality(
      //   regionIsoCode: regionIsoCode,
      //   localityName: correctedName,
      // );

      // // 6) assemble a new Locality instance (id blank—server will fill it)
      // final newLocality = Locality(
      //   id: '', 
      //   countryAlpha2: '', 
      //   countryAlpha3: '', 
      //   countryName: '',
      //   regionCode: '',
      //   regionIsoCode: regionIsoCode,
      //   regionName: '',
      //   name: correctedName,
      //   latitude: coords.latitude,
      //   longitude: coords.longitude,
      // );

      // // 7) persist via your service & return the result
      // final Locality created = await _reportService.createLocality(newLocality);
      // return created;

    } catch (e) {
      _handleError(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Returns up to 3 matching localities for the given input
  Future<List<Locality>> fetchLocalitySuggestions(String pattern) async {
    final trimmed = pattern.trim();
    if (trimmed.isEmpty) return [];

    final response = await Supabase.instance.client
        .from('localities')
        .select('id, name')
        .eq('region_iso_code', selectedRegion!.isoCode)
        .ilike('name', '%$trimmed%')
        .limit(3);

    final List<Locality> localities = (response as List).map((item) {
      return Locality.fromJson(item);
    }).toList();

    return localities;

  }




}