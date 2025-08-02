import 'package:aiso/Dashboards/services/dashboard_service.dart';
import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/models/llm_enum.dart';
import 'package:aiso/models/location_models.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/reports/models/prompt_result_model.dart';
import 'package:aiso/reports/models/report_model.dart';
import 'package:aiso/reports/models/report_run_model.dart';
import 'package:aiso/services/auth_service_supabase.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:aiso/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DashViewModel extends ChangeNotifier {

  DashViewModel() {
    _init();
  }

  bool isLoading = false;
  String? errorMessage;

  final AuthServiceSupabase _authService = AuthServiceSupabase();
  final ReportServiceSupabase _reportService = ReportServiceSupabase();
  final DashboardServiceSupabase _dashService = DashboardServiceSupabase();

  List<Report> reports = [];
  Report? _selectedReport;
  Report? get selectedReport => _selectedReport;
  set selectedReport(Report? report) {
    _selectedReport = report;
    fetchSummaries(
      reportId: _selectedReport?.id,
      reportRunId: _selectedReportRun?.id,
      promptId: _selectedPrompt?.id,
      locationId: _selectedLocation?.id,
    );
  }

  List<ReportRun> reportRuns = [];
  ReportRun? _selectedReportRun;
  ReportRun? get selectedReportRun => _selectedReportRun;
  set selectedReportRun(ReportRun? reportRun) {
    _selectedReportRun = reportRun;
    fetchSummaries(
      reportId: _selectedReport?.id,
      reportRunId: _selectedReportRun?.id,
      promptId: _selectedPrompt?.id,
      locationId: _selectedLocation?.id,
    );
  }

  List<Prompt> prompts = [];
  Prompt? _selectedPrompt;
  Prompt? get selectedPrompt => _selectedPrompt;
  set selectedPrompt(Prompt? prompt) {
    _selectedPrompt = prompt;
    fetchSummaries(
      reportId: _selectedReport?.id,
      reportRunId: _selectedReportRun?.id,
      promptId: _selectedPrompt?.id,
      locationId: _selectedLocation?.id,
    );
  }

  List<Locality> locations = [];
  Locality? _selectedLocation;
  Locality? get selectedLocation => _selectedLocation;
  set selectedLocation(Locality? location) {
    _selectedLocation = location;
    fetchSummaries(
      reportId: _selectedReport?.id,
      reportRunId: _selectedReportRun?.id,
      promptId: _selectedPrompt?.id,
      locationId: _selectedLocation?.id,
    );
  }

  // percent found
  DataSummary? percentFoundSummary;

  String get formattedPercentFound {
    final percent = percentFoundSummary?.overall;

    if (percent == null) return '–';
    return '${(percent * 100).toStringAsFixed(1)}%';
  }


  List<Map<String, dynamic>> get percentFoundLLMData {
    if (percentFoundSummary == null) return [];

    final entries = percentFoundSummary!.byLlm.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // Sort by key (label)

    return entries.map((e) => {
      'label': e.key,
      'value': e.value,
      'color': AppColors.color3,
    }).toList();
  }

  List<Map<String, dynamic>> get percentFoundLocationData {
    if (percentFoundSummary == null) return [];

    final entries = percentFoundSummary!.byLocation.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // Sort by key (label)

    return entries.map((e) => {
      'label': e.key,
      'value': e.value,
      'color': AppColors.color3,
    }).toList();
  }

 // mean rank
  DataSummary? meanRankSummary;

  String get formattedMeanRank {
    final rank = meanRankSummary?.overall;

    if (rank == null) return '–';
    return rank.toStringAsFixed(1);
  }

  List<Map<String, dynamic>> get meanRankLLMData {
    if (meanRankSummary == null) return [];

    final entries = meanRankSummary!.byLlm.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // Sort by key (label)

    return entries.map((e) => {
      'label': e.key,
      'value': e.value,
      'color': AppColors.color3,
    }).toList();
  }

  List<Map<String, dynamic>> get meanRankLocationData {
    if (meanRankSummary == null) return [];

    final entries = meanRankSummary!.byLocation.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // Sort by key (label)

    return entries.map((e) => {
      'label': e.key,
      'value': e.value,
      'color': AppColors.color3,
    }).toList();
  }

  Future<void> _init() async {
    // Mark as loading
    Future.microtask(() {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
    });

    try {

      String? userId = await _authService.fetchCurrentUserId();
      if (userId == null) return;

      List<Report> reports = await _reportService.fetchReportsWithLocations(userId);

      locations = reports
        .map((r) => r.locality)
        .whereType<Locality>() // filters out nulls
        .toSet()
        .toList();

      // reportRuns = await _reportService.fetchReportRuns(reportId);
      // prompts = await _reportService.fetchReportPrompts(reportId);
      // locations = prompts
      //   .map((p) => p.locality)
      //   .whereType<Locality>() // filters out nulls
      //   .toSet()
      //   .toList();

      percentFoundSummary = await _dashService.fetchPercentFoundSummary(userId: userId);
      meanRankSummary = await _dashService.fetchMeanRankSummary(userId: userId);

      // // Safely assign first report run if any exist
      // if (reportRuns.isNotEmpty) {
      //   selectedReportRun = reportRuns.first;
      // } else {
      //   selectedReportRun = null;
      //   printDebug('⚠️ No report runs found for reportId: $reportId');
      // }

      // // Safely assign first report run if any exist
      // if (prompts.isNotEmpty) {
      //   selectedPrompt = prompts.first;
      // } else {
      //   selectedPrompt = null;
      //   printDebug('⚠️ No report runs found for reportId: $reportId');
      // }



      // // Fetch all report runs
      // final int epoch = 0;
      // promptResults = await _reportService.fetchPromptResults(
      //   reportId
      // );
      // promptResults.sort((a, b) => a.entityRank.compareTo(b.entityRank));
      // debugPrint('DEBUG: promptResults fecthed!');
      // prompt = await _reportService.fetchPrompt(promptId);
    } catch (e, stackTrace) {
      // Log full error for debugging
      errorMessage = 'Failed to initialize: $e';
      debugPrint('❌ [DashViewModel] init error: $e\n$stackTrace');
    } finally {
      // Finish loading
      Future.microtask(() {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  void _handleError(Object error, [StackTrace? stackTrace]) {
    errorMessage = error.toString();

    debugPrint('DashViewModel error: $errorMessage');

    if (stackTrace != null) {
      debugPrint('Stack trace:\n$stackTrace');
    }

    // You can add extra error handling logic here, like:
    // - showing user-friendly messages
    // - sending logs to remote error tracking services
  }

  Future<void> fetchSummaries({
    String? reportId,
    String? reportRunId,
    String? promptId,
    String? locationId,
  }) async {

    isLoading = true;
    notifyListeners();

    try {
      // Optional: set a loading state here
      printDebug('ViewModel: fetching summaries');

      printDebug('reportId: $reportId');
      printDebug('reportRunId: $reportRunId');
      printDebug('promptId: $promptId');
      printDebug('locationId: $locationId');

      String? userId = await _authService.fetchCurrentUserId();
      if (userId == null) return;

      final percentFuture = _dashService.fetchPercentFoundSummary(
        userId: userId,
        reportId: reportId,
        reportRunId: reportRunId,
        promptId: promptId,
        locationId: locationId,
      );

      final rankFuture = _dashService.fetchMeanRankSummary(
        userId: userId,
        reportId: reportId,
        reportRunId: reportRunId,
        promptId: promptId,
        locationId: locationId,
      );

      final results = await Future.wait([percentFuture, rankFuture]);

      percentFoundSummary = results[0];
      meanRankSummary = results[1];

      printDebug('ViewModel: summaries fetched successfully');
      printDebug('Percent found: ${percentFoundSummary?.overall}');
      printDebug('Mean rank: ${meanRankSummary?.overall}');

    } catch (e, st) {
      printError('Error fetching summaries: $e');
      printError(st as String);
      // Optionally handle error state here
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



}
