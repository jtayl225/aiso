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
import 'package:aiso/services/location_service_supabase.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Reuse enum for report_run_status
enum ReportRunStatus { initialising, running, completed, failed } // generating, searching, 

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

  String email = '';
  String entityName = '';
  String prompt = '';
  
  int searchTargetRank = -1;
  String reportRunId = '';
  String reportId = '';
  String promptText = '';
  bool isLoading = false;
  String? errorMessage;

  List<Entity> _entities = [];
  List<Entity> get entities => _entities;
  set entities(List<Entity> value) {
    _entities = value;
    notifyListeners();
  }

  final ReportServiceSupabase _reportService = ReportServiceSupabase();
  final LocationServiceSupabase _locationService = LocationServiceSupabase();

  List<Industry> industries = [];
  Industry? selectedIndustry;

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

  Locality? _selectedLocality;
  Locality? get selectedLocality => _selectedLocality;
  set selectedLocality(Locality? value) {
    _selectedLocality = value;
    notifyListeners();
  }

  bool get isFormValid => 
    email.isNotEmpty &&
    email.contains('@') &&
    selectedIndustry != null && 
    entityName.isNotEmpty &&
    _selectedCountry != null &&
    _selectedRegion != null &&
    _selectedLocality != null;

  // track purchase reveals
  final Set<int> _revealed = {};

  // current status from report_runs
  ReportRunStatus _currentStatus = ReportRunStatus.initialising;
  ReportRunStatus get currentStatus => _currentStatus;
  set currentStatus(ReportRunStatus newStatus) {
    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;

      // Call fetchReportRunResults if status becomes 'completed'
      if (_currentStatus == ReportRunStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () async {
          await fetchReportRunResults();
          await fetchEntities();
          notifyListeners();
        });
      }

      notifyListeners(); // Don't forget to notify listeners!
    }
  }

  static final List<StepData> _steps = [
    StepData(title: 'Initialising', description: 'Setting up our services.'),
    StepData(title: 'Generating results', description: 'Generating results from LLMs.'),
    // StepData(title: 'Searching for you business', description: 'Searching the LLM results for your business.'),
    StepData(title: 'Done!', description: 'Woohoo! :rocket:'),
  ];
  List<StepData> get steps => _steps;

  int _currentStep = 1;
  int get currentStep => _currentStep;

  ReportRunResults? _reportRunResults;
  ReportRunResults? get reportRunResults => _reportRunResults;

  // Supabase subscription
  RealtimeChannel? _subscription;

  // FreeReportViewModel({
  //   required this.prompt,
  //   required this.entities,
  //   required this.searchTargetRank,
  //   required this.reportRunId,
  // }) {
  //   _initSupabaseListener();
  // }

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
    email = '';
    entityName = '';
    prompt = '';
    searchTargetRank = -1;
    reportRunId = '';
    reportId = '';
    promptText = '';
    isLoading = false;
    errorMessage = null;
    _entities = [];

    _currentStatus = ReportRunStatus.initialising;
    _currentStep = 1;

    _reportRunResults = null;

    // one notify for everything
    notifyListeners();
  }

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

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


  void _handleError(Object error, [StackTrace? stackTrace]) {
    errorMessage = error.toString();

    debugPrint('FreeReportViewModel error: $errorMessage');
    
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
        .channel('report_runs')
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
            debugPrint("DEBUG: Received update payload: ${payload.newRecord}");
            final newStatus = payload.newRecord['status'] as String;
            final statusEnum = ReportRunStatusX.fromString(newStatus);
            debugPrint("DEBUG: New status = $statusEnum, Current = $_currentStatus");
            if (statusEnum != _currentStatus && statusEnum.index > _currentStatus.index) {
              currentStatus = statusEnum;
              _currentStep = statusEnum.index + 1;
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

  /// createAndRunFreeReport
  Report _buildFreeReport(String searchTargetId) {

    final String serviceAccountId = _reportService.fetchServiceAccount();

    final Report freeReport = Report(
      id: '', // generated by supabase
      userId: serviceAccountId,
      searchTargetId: searchTargetId,
      title: 'Free report!',
      // isPaid: false,
      cadence: Cadence.once,
      dbTimestamps: DbTimestamps.now(),
    );

    return freeReport;

  }

  SearchTarget _buildSearchTarget() {

    final String serviceAccountId = _reportService.fetchServiceAccount();

    final SearchTarget searchTarget = SearchTarget(
      id: '', // generated by supabase
      // reportId: reportId,
      userId: serviceAccountId,
      name: entityName, 
      entityType: EntityType.business, 
      industry: selectedIndustry!,
      description: 'A real estate agency.', 
      dbTimestamps: DbTimestamps.now()
      );

    return searchTarget;

  }

  String _buildFreePrompt(String basePrompt) {
  if (selectedLocality == null || selectedRegion == null || selectedCountry == null) {
    throw StateError('All location fields must be selected');
  }

  return '$basePrompt in ${selectedLocality!.name}, ${selectedRegion!.code} ${selectedCountry!.name}';
}


  Future<bool> createAndRunFreeReport() async {
    isLoading = true;
    notifyListeners();
    try {
      debugPrint('DEBUG: createAndRunFreeReport.');

      // create search target
      final SearchTarget insertedSearchTarget = await _reportService.createSearchTarget(_buildSearchTarget());

      // create report
      final Report report = await _reportService.createReport(_buildFreeReport(insertedSearchTarget.id));

      // // fetch parent prompt given industry
      debugPrint('DEBUG: start freePromptText.');
      final String freePromptText = _buildFreePrompt('Top 10 real estate agencies');
      promptText = freePromptText;
      debugPrint('DEBUG: end freePromptText.');

      // creates prompt - handles upserts of new prompts
      debugPrint('DEBUG: start upsertPromptAndAttach.');
      final Prompt _ = await _reportService.upsertPromptAndAttach(reportId: report.id, promptText: freePromptText, localityId: selectedLocality!.id);
      debugPrint('DEBUG: end upsertPromptAndAttach.');

      // init free report run
      debugPrint('DEBUG: start runReport.');
      final String? newReportRunId = await _reportService.runReport(report, false);
      if (newReportRunId == null || newReportRunId.isEmpty) return false;
      reportRunId =  newReportRunId;
      debugPrint('DEBUG: end runReport.');
      debugPrint('DEBUG: reportRunId: $reportRunId.');

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

    final List<Locality> localities = (response as List).map((item) {
      return Locality.fromJson(item);
    }).toList();

    return localities;

  }

  Future<void> fetchReportRunResults() async {
    isLoading = true;
    notifyListeners();
    try {
      debugPrint('DEBUG: fetchReportRunResults.');
      if (reportRunId.isEmpty) return;
      _reportRunResults = await _reportService.fetchReportRunResults(reportRunId);
    } catch (e) {
      _handleError(e);
      return;
    } finally {
      isLoading = false;
      notifyListeners();
    }

  }

  Future<void> fetchEntities() async {
    isLoading = true;
    notifyListeners();
    try {
      debugPrint('DEBUG: fetchReportRunResults.');
      if (reportRunId.isEmpty || reportRunResults == null) return;
      entities = await _reportService.fetchLlmRunResults(reportRunResults!.llmEpochId);
    } catch (e) {
      _handleError(e);
      return;
    } finally {
      isLoading = false;
      notifyListeners();
    }

  }

}