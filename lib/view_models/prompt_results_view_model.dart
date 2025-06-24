import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/purchase_enum.dart';
import 'package:aiso/reports/models/prompt_result_model.dart';
import 'package:aiso/reports/models/report_run_model.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:flutter/material.dart';

class PromptResultsViewModel extends ChangeNotifier {

  final String reportId;
  final String promptId;
  Prompt? prompt;
  List<ReportRun> reportRuns = [];
  List<PromptResult> promptResults = [];
  bool isLoading = false;
  String? errorMessage;
  final ReportServiceSupabase _reportService = ReportServiceSupabase();

  PromptResultsViewModel(this.reportId, this.promptId) {
    _init(); // async logic separated from constructor
  }

  void _init() async {
    await fetchResults(reportId, promptId);
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

  Future<bool> fetchResults(String reportId, String promptId) async {
    isLoading = true;
    notifyListeners();

    try {
      reportRuns = await _reportService.fetchReportRuns(reportId);
      if (reportRuns.isEmpty) {
        promptResults = [];
        return true;
      }

      final String runId = reportRuns.first.id; // assumes sorted DESC
      promptResults = await _reportService.fetchPromptResults(reportId, runId, promptId);
      prompt = await _reportService.fetchPrompt(promptId);

      debugPrint('DEBUG: ${promptResults.length} prompt results fetched for runId: $runId');
      return true;

    } catch (e) {
      _handleError(e);
      return false;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> fetchPromptResults(String reportId, String runId, String promptId) async {
    isLoading = true;
    notifyListeners();
    try {
      promptResults = await _reportService.fetchPromptResults(reportId, runId, promptId);
      debugPrint('DEBUG: ${promptResults.length} prompt results fetched for runId: $runId');
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<int> get availableEpochs {
    final epochs = promptResults.map((e) => e.epoch).toSet().toList();
    epochs.sort(); // optional: sort ascending
    return epochs;
  }

  List<String> get availableLlms {
  final llms = promptResults.map((e) => e.llm).toSet().toList();
  llms.sort(); // optional: sort alphabetically
  return llms;
}



















  Future<String?> generateCheckoutUrl(ProductType productType) async {
    isLoading = true;
    notifyListeners();

    try {
      debugPrint('DEBUG: view model about to call handle-stripe-purchase edge function');
      final String? url = await _reportService.generateCheckoutUrl(productType);
      return url; // Let the UI handle launching
    } catch (e) {
      _handleError(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> generateBillingPortal() async {
    isLoading = true;
    notifyListeners();

    try {
      debugPrint('DEBUG: view model about to call generateBillingPortal edge function');
      final String? url = await _reportService.generateBillingPortal();
      return url; // Let the UI handle launching
    } catch (e) {
      _handleError(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


}
