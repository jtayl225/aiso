import 'package:aiso/models/report_results.dart';
import 'package:aiso/models/search_target_model.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:flutter/material.dart';

class ReportResultsViewModel extends ChangeNotifier {

  final String reportId;
  List<ReportResult> results = [];
  SearchTarget? searchTarget;
  bool isLoading = false;
  String? errorMessage;
  final ReportServiceSupabase _reportService = ReportServiceSupabase();

  ReportResultsViewModel(this.reportId) {
    _init(); // async logic separated from constructor
  }

  void _init() async {
    await fetchReportResults(reportId);
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

  Future<bool> fetchReportResults(String reportId) async {
    isLoading = true;
    notifyListeners();
    try {
      searchTarget = await _reportService.fetchSearchTarget(reportId);
      results = await _reportService.fetchReportResults(reportId);
      // debugPrint('DEBUG: report results: $reportResults');
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> runReport(String reportId) async {
    isLoading = true;
    notifyListeners();
    try {
      debugPrint('DEBUG: view model about to call run-report edge function');
      await _reportService.runReport(reportId);
      results = await _reportService.fetchReportResults(reportId);
      searchTarget = await _reportService.fetchSearchTarget(reportId);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
