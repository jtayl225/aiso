import 'package:aiso/models/entity_model.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/report_run_results_model.dart';
import 'package:aiso/reports/models/report_model.dart';
import 'package:aiso/models/search_target_model.dart';
import 'package:aiso/reports/models/report_run_model.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:aiso/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FreeReportViewModel extends ChangeNotifier {

  final String reportId;

  FreeReportViewModel({required this.reportId}) {
    _init(); // Optional: load report immediately
  }

  bool isLoading = false;
  String? errorMessage;

  // final AuthServiceSupabase _authService = AuthServiceSupabase();
  final ReportServiceSupabase _reportService = ReportServiceSupabase();

  Report? report;

  List<ReportRun> reportRuns = [];
  ReportRun? _selectedReportRun;
  ReportRun? get selectedReportRun => _selectedReportRun;
  set selectedReportRun(ReportRun? reportRun) {
    _selectedReportRun = reportRun;
    notifyListeners();
  }

  ReportRunResults? _reportRunResults;
  ReportRunResults? get reportRunResults => _reportRunResults;

  SearchTarget? searchTarget;
  int searchTargetRank = -1;

  final Set<int> _revealed = {};
  Set<int> get revealed => _revealed;

  List<Entity> _entities = [];
  List<Entity> get entities => _entities;
  set entities(List<Entity> value) {
    _entities = value;
    notifyListeners();
  }
  
  List<Prompt> prompts = [];
  Prompt? _selectedPrompt;
  Prompt? get selectedPrompt => _selectedPrompt;
  set selectedPrompt(Prompt? value) {
    _selectedPrompt = value;
    notifyListeners();
  }

  Future<void> _init() async {
    // Mark as loading
    Future.microtask(() {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
    });

    try {
      // Fetch all report runs
      reportRuns = await _reportService.fetchReportRuns(reportId);
      selectedReportRun = reportRuns.isNotEmpty ? reportRuns.first : null;
      if (selectedPrompt == null) {
        printDebug('⚠️ No report runs found for reportId: $reportId');
      }

      // Always attempt to load prompts and dashboards
      report = await _reportService.fetchReport(reportId);
      if (report == null) {
        errorMessage = '⚠️ Report not found for reportId: $reportId';
        printDebug(errorMessage!);
        return;
      }

      searchTarget = report!.searchTarget;

      prompts = report?.prompts ?? [];
      selectedPrompt = prompts.isNotEmpty ? prompts.first : null;
      if (selectedPrompt == null) {
        printDebug('⚠️ No prompts found for reportId: $reportId');
      }


      if (selectedReportRun == null ) return;
      _reportRunResults = await _reportService.fetchReportRunResults(selectedReportRun!.id);

      if (_reportRunResults == null ) return;

      entities = await _reportService.fetchLlmRunResults(_reportRunResults!.llmEpochId);

      if (_reportRunResults!.targetRank == null) {
        printDebug('⚠️ targetRank is null for llmEpochId: ${_reportRunResults!.llmEpochId}');
        searchTargetRank = -1;
        return;
      }

      searchTargetRank =  _reportRunResults!.targetRank!;

    } catch (e, stackTrace) {
      // Log full error for debugging
      errorMessage = 'Failed to initialize: $e';
      printDebug('❌ [FreeReportViewModel] init error: $e\n$stackTrace');
    } finally {
      // Finish loading
      Future.microtask(() {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  /// Whether the card at [index] should be fully shown.
  bool canShow(int index) {
    return entities[index].rank == searchTargetRank || _revealed.contains(index);
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

}
