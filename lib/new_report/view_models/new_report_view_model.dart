import 'dart:convert';
import 'package:aiso/models/cadence_enum.dart';
import 'package:aiso/models/db_timestamps_model.dart';
import 'package:aiso/models/entity_model.dart';
import 'package:aiso/models/industry_model.dart';
import 'package:aiso/models/location_models.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/report_run_results_model.dart';
import 'package:aiso/models/search_target_model.dart';
import 'package:aiso/reports/models/report_model.dart';
import 'package:aiso/reports/views/timeline.dart';
import 'package:aiso/services/auth_service_supabase.dart';
import 'package:aiso/services/location_service_supabase.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:aiso/utils/logger.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewReportViewModel extends ChangeNotifier {
  
  NewReportViewModel() {
    init(); // Auto-run when the provider creates this instance
  }

  Future<void> init() async {
    // if (_isInitialized) return;
    // _isInitialized = true;

    // Defer first notification to avoid "called during build"
    Future.microtask(() {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
    });

    try {

      countries = await _locationService.fetchCountries();
      selectedCountry = countries.first;

      industries = await _reportService.fetchIndustries();
      selectedIndustry = industries.first;

      // Fetch current user ID
      String? userId = await _authService.fetchCurrentUserId();
      if (userId == null) return;
      searchTargets = await _reportService.fetchSearchTargets(userId);
      selectedSearchTarget = searchTargets.isNotEmpty ? searchTargets.first : null;

    } catch (e) {
      errorMessage = 'Failed to initialize: $e';
    } finally {
      // Defer again to ensure build is complete
      Future.microtask(() {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  // String email = '';
  // String entityName = '';
  // String prompt = '';

  // int searchTargetRank = -1;
  // String reportRunId = '';
  // String reportId = '';
  // String promptText = '';
  bool isLoading = false;
  String? errorMessage;

  List<Entity> _entities = [];
  List<Entity> get entities => _entities;
  set entities(List<Entity> value) {
    _entities = value;
    notifyListeners();
  }

  final AuthServiceSupabase _authService = AuthServiceSupabase();
  final ReportServiceSupabase _reportService = ReportServiceSupabase();
  final LocationServiceSupabase _locationService = LocationServiceSupabase();

  List<Industry> industries = [];
  Industry? selectedIndustry;

  // Report Title
  String? _reportTitle = '';
  String? get reportTitle => _reportTitle;
  set reportTitle(String? value) {
    _reportTitle = value;
    notifyListeners();
  }

  // Search Target
  List<SearchTarget> searchTargets = [];
  SearchTarget? _selectedSearchTarget;
  SearchTarget? get selectedSearchTarget => _selectedSearchTarget;
  set selectedSearchTarget(SearchTarget? value) {
    _selectedSearchTarget = value;
    notifyListeners();
  }

  // Prompt
  List<String> promptTypes = ['Best', 'Top rated', 'Top 10'];
  String? _selectedPromptType = 'Top 10';
  String? get selectedPromptType => _selectedPromptType;

  set selectedPromptType(String? value) {
    _selectedPromptType = value;
    notifyListeners(); // 👈 this is essential
  }


  // Location
  List<Country> countries = [];
  Country? _selectedCountry;
  Country? get selectedCountry => _selectedCountry;
  set selectedCountry(Country? value) {
    _selectedCountry = value;
    selectedRegion = null; // Reset selected region if country changes
    notifyListeners(); // ✅ Trigger UI rebuild
  }

  Region? _selectedRegion;
  Region? get selectedRegion => _selectedRegion;
  set selectedRegion(Region? value) {
    _selectedRegion = value;
    notifyListeners();
  }

  List<Locality> localities = [];
  List<Locality> nearbyLocalities = [];
  Locality? _selectedLocality;
  Locality? get selectedLocality => _selectedLocality;
  set selectedLocality(Locality? value) {
    _selectedLocality = value;
    if (value != null && !_localitiesContains(value)) {
      bool _ = addLocality(value);
      fetchNearbyLocalities(value);
    }
    notifyListeners();
  }

  bool _localitiesContains(Locality locality) {
    return localities.any((l) => l.id == locality.id);
  }

  bool get isFormValid =>
      // reportTitle != '' &&
      selectedSearchTarget != null &&
      selectedPromptType != null &&
      localities.isNotEmpty;

  // Supabase subscription
  RealtimeChannel? _subscription;

  bool _isInitialized = false;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<FreeReportViewModel>(context, listen: false).init();
  //   });
  // }

  // FreeReportViewModel() {
  //   init();
  // }

  /// Resets all mutable fields to their initial values.
  void reset() {
    // entityName = '';
    isLoading = false;
    errorMessage = null;
    _entities = [];

    // one notify for everything
    notifyListeners();
  }

  void _handleError(Object error, [StackTrace? stackTrace]) {
    errorMessage = error.toString();

    printDebug('FreeReportViewModel error: $errorMessage');

    if (stackTrace != null) {
      printDebug('Stack trace:\n$stackTrace');
    }

    // You can add extra error handling logic here, like:
    // - showing user-friendly messages
    // - sending logs to remote error tracking services
  }

  // /// Listen for realtime changes on report_runs.status
  // void _initSupabaseListener() {
  //   final supabase = Supabase.instance.client;
  //   // Create a dedicated channel for listening to updates on the 'report_runs' table
  //   _subscription =
  //       supabase
  //           .channel('report_runs')
  //           .onPostgresChanges(
  //             event: PostgresChangeEvent.update,
  //             schema: 'public',
  //             table: 'report_runs',
  //             filter: PostgresChangeFilter(
  //               type: PostgresChangeFilterType.eq,
  //               column: 'id',
  //               value: reportRunId,
  //             ),
  //             callback: (payload) {
  //               // debugPrint("DEBUG: Received update payload: ${payload.newRecord}");
  //               // final newStatus = payload.newRecord['status'] as String;
  //               // final statusEnum = ReportRunStatusX.fromString(newStatus);
  //               // debugPrint("DEBUG: New status = $statusEnum, Current = $_currentStatus");
  //               // if (statusEnum != _currentStatus && statusEnum.index > _currentStatus.index) {
  //               //   currentStatus = statusEnum;
  //               //   _currentStep = statusEnum.index + 1;
  //               //   notifyListeners();
  //               // }
  //             },
  //           )
  //           .subscribe();
  // }

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

  /// createAndRunFreeReport
  Report _buildPaidReport(String userId, String searchTargetId, String title, String localityId) {

    final Report paidReport = Report(
      id: '', // generated by supabase
      localityId: localityId,
      userId: userId,
      searchTargetId: searchTargetId,
      title: title,
      isPaid: true,
      cadence: Cadence.month,
      dbTimestamps: DbTimestamps.now(),
    );

    return paidReport;
  }

  // SearchTarget _buildSearchTarget() {
  //   final String serviceAccountId = _reportService.fetchServiceAccount();

  //   final SearchTarget searchTarget = SearchTarget(
  //     id: '', // generated by supabase
  //     // reportId: reportId,
  //     userId: serviceAccountId,
  //     name: entityName,
  //     entityType: EntityType.business,
  //     industry: selectedIndustry!,
  //     description: 'A real estate agency.',
  //     dbTimestamps: DbTimestamps.now(),
  //   );

  //   return searchTarget;
  // }

  String _buildBasePrompt() {
    final entityLabel = selectedSearchTarget?.entityType == EntityType.business
        ? 'real estate agencies'
        : 'real estate agents';
    return '$selectedPromptType $entityLabel';
  }


  String _buildPrompt(String basePrompt, Locality localitity) {
    if (selectedRegion == null ||
        selectedCountry == null) {
      throw StateError('All location fields must be selected');
    }

    return '$basePrompt in ${localitity.name}, ${selectedRegion!.code} ${selectedCountry!.name}';
  }

  Future<bool> createAndRunPaidReport() async {
    isLoading = true;
    notifyListeners();
    try {
      printDebug('createAndRunPaidReport.');

      // create search target
      final String? userId = await _authService.fetchCurrentUserId();
      final String? searchTargetId = selectedSearchTarget?.id;
      // final String? title = reportTitle;

      if (userId == null || searchTargetId == null) {
        printDebug('❌ Missing required inputs: userId, searchTarget, or title');
        return false;
      }

      // create report
      // final Report report = await _reportService.createReport(
      //   _buildPaidReport(userId, searchTargetId, title),
      // );

      // // // fetch parent prompt given industry
      final String basePrompt = _buildBasePrompt();

      List<String> reportIds = [];

      for (final locality in localities) {

        printDebug('DEBUG: start _buildPrompt.');
        final String promptText = _buildPrompt(basePrompt, locality);
        printDebug('DEBUG: end _buildPrompt.');

        final Report report = await _reportService.createReport(
          _buildPaidReport(userId, searchTargetId, promptText, locality.id),
        );

        reportIds.add(report.id);

        // creates prompt - handles upserts of new prompts
        printDebug('DEBUG: start upsertPromptAndAttach.');
        final Prompt _ = await _reportService.upsertPromptAndAttach(
          reportId: report.id,
          promptText: promptText,
          localityId: locality.id
        );
        printDebug('DEBUG: end upsertPromptAndAttach.');

        // printDebug('DEBUG: start runReport.');
        // final String? newReportRunId = await _reportService.runReport(report, true);
        // if (newReportRunId == null || newReportRunId.isEmpty) return false;
        // printDebug('DEBUG: end runReport.');
        // printDebug('DEBUG: reportRunId: $newReportRunId.');

      }

       final String? _ = await _reportService.runReport(userId, reportIds, true);

      // // init paid report run
      // printDebug('DEBUG: start runReport.');
      // final String? newReportRunId = await _reportService.runReport(report, true);
      // if (newReportRunId == null || newReportRunId.isEmpty) return false;
      // printDebug('DEBUG: end runReport.');
      // printDebug('DEBUG: reportRunId: $newReportRunId.');

      return true;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCountries() async {
    isLoading = true;
    notifyListeners();
    try {
      countries = await _locationService.fetchCountries();
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Locality?> fetchLocality(
    String regionIsoCode,
    String localityName,
  ) async {
    // 1) show loading
    isLoading = true;
    notifyListeners();
    try {
      printDebug('DEBUG: createAndRunFreeReport.');

      // 2) compute normalized hash
      final String localityHash = _hashString(regionIsoCode + localityName);

      // 3) attempt to fetch an existing one
      final Locality? existingLocality = await _reportService
          .fetchLocalityFromHash(localityHash);
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
    debugPrint('fetchLocalitySuggestions called with: "$pattern"');

    final trimmed = pattern.trim();
    if (trimmed.isEmpty) return [];
    if (selectedRegion == null) return [];

    final response = await Supabase.instance.client
        .from('localities')
        .select('id, region_iso_code, name, latitude, longitude')
        .eq('region_iso_code', selectedRegion!.isoCode)
        .ilike('name', '%$trimmed%')
        .limit(3);

    final List<Locality> localities =
        (response as List).map((item) {
          return Locality.fromJson(item);
        }).toList();

    return localities;
  }

  Future<void> fetchNearbyLocalities(Locality locality) async {
    isLoading = true;
    notifyListeners();
    try {
      nearbyLocalities =
          (await _locationService.fetchNearbyLocalities(locality))
              .where(
                (loc) => !localities.any((existing) => existing.id == loc.id),
              )
              .toList();
    } catch (e) {
      _handleError(e);
      return;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool addLocality(Locality locality) {
    if (localities.length >= 10) return false;

    if (!localities.any((l) => l.name == locality.name)) {
      localities.add(locality);
      removeNearbyLocality(locality);
      notifyListeners();
      return true;
    }

    return false;
  }

  void removeLocality(Locality locality) {
    final initialLength = localities.length;
    localities.removeWhere((l) => l.id == locality.id);

    if (localities.length < initialLength) {
      notifyListeners();
    }
  }

  void removeNearbyLocality(Locality locality) {
    nearbyLocalities.removeWhere((l) => l.name == locality.name);
    notifyListeners();
  }

  // Future<void> fetchReportRunResults() async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     debugPrint('DEBUG: fetchReportRunResults.');
  //     if (reportRunId.isEmpty) return;
  //     _reportRunResults = await _reportService.fetchReportRunResults(reportRunId);
  //   } catch (e) {
  //     _handleError(e);
  //     return;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }

  // }

  // Future<void> fetchEntities() async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     debugPrint('DEBUG: fetchReportRunResults.');
  //     if (reportRunId.isEmpty || reportRunResults == null) return;
  //     entities = await _reportService.fetchLlmRunResults(reportRunResults!.llmEpochId);
  //   } catch (e) {
  //     _handleError(e);
  //     return;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }

  // }

  Future<void> createSearchTarget(SearchTarget newSearchTarget) async {
  try {

    // Fetch current user ID
    String? userId = await _authService.fetchCurrentUserId();

    // Handle null user ID safely
    if (userId == null) {
      printDebug('⚠️ Error: userId is null. Cannot fetch search targets.');
      return;
    }

    SearchTarget updatedSearchTarget = newSearchTarget.copyWith(userId: userId);

    // Attempt to create the search target
    await _reportService.createSearchTarget(updatedSearchTarget);

    // Fetch updated list of search targets
    searchTargets = await _reportService.fetchSearchTargets(userId);
  } catch (e, stackTrace) {
    printDebug('❌ Failed to create search target: $e');
    printDebug('StackTrace: $stackTrace');

    // Optionally: set an error state or notify the UI
    // errorMessage = 'Failed to create search target. Please try again.';
  }
}



}
