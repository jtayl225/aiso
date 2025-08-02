import 'package:aiso/models/llm_enum.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/report_run_results_model.dart';
import 'package:aiso/models/search_target_model.dart';
import 'package:aiso/reports/models/prompt_result_model.dart';
import 'package:aiso/reports/models/report_run_model.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RankViewModel extends ChangeNotifier {
  final String reportId;
  // final String reportRunId;
  // final String promptId;

  RankViewModel({
    required this.reportId,
    // required this.reportRunId,
    // required this.promptId,
  }) {
    _init(); // Optional: load report immediately
  }

  bool isLoading = false;
  String? errorMessage;

  final ReportServiceSupabase _reportService = ReportServiceSupabase();

  List<ReportRun> reportRuns = [];

  ReportRun? _selectedReportRun;
  ReportRun? get selectedReportRun => _selectedReportRun;
  set selectedReportRun(ReportRun? reportRun) {
    _selectedReportRun = reportRun;
    _fetchPromptResults();
  }


  // List<ReportRunResults> reportRunResults = [];

  // int? get chatGptTargetRank {
  //   if (reportRunResults.isEmpty) return -1;
  //   return reportRuns
  //       .where((p) => LLMParsing.fromString(p.llmGeneration) == LLM.chatgpt)
  //       .toList()
  //     ;
  // }

  List<Prompt> prompts = [];
  Prompt? prompt;
  List<PromptResult> promptResults = [];
  // List<PromptResult> get chatGptPromptResults {
  // if (promptResults.isEmpty) return [];
  //   return promptResults.where((p) => LLMParsing.fromString(p.llmGeneration) == LLM.chatgpt).toList();
  // }

  SearchTarget? searchTarget;
  int searchTargetRank = -1;

  int get chatGptTargetRank {
    try {
      return promptResults.firstWhere(
        (p) =>
            LLMParsing.fromString(p.llmGeneration) == LLM.chatgpt &&
            p.isTarget == true,
      ).entityRank;
    } catch (e) {
      return -1; // return -1 if not found
    }
  }

  int get geminiTargetRank {
    try {
      return promptResults.firstWhere(
        (p) =>
            LLMParsing.fromString(p.llmGeneration) == LLM.gemini &&
            p.isTarget == true,
      ).entityRank;
    } catch (e) {
      return -1; // return -1 if not found
    }
  }


  List<PromptResult> get chatGptPromptResults {
    if (promptResults.isEmpty) return [];
    return promptResults
        .where((p) => LLMParsing.fromString(p.llmGeneration) == LLM.chatgpt)
        .toList()
      ..sort((a, b) => a.entityRank.compareTo(b.entityRank));
  }

  // List<PromptResult> get geminiPromptResults {
  // if (promptResults.isEmpty) return [];
  //   return promptResults.where((p) => LLMParsing.fromString(p.llmGeneration) == LLM.gemini).toList();
  // }

  List<PromptResult> get geminiPromptResults {
    if (promptResults.isEmpty) return [];
    return promptResults
        .where((p) => LLMParsing.fromString(p.llmGeneration) == LLM.gemini)
        .toList()
      ..sort((a, b) => a.entityRank.compareTo(b.entityRank));
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
      final int epoch = 0;

      reportRuns = await _reportService.fetchReportRuns(reportId);
      prompts = await _reportService.fetchReportPrompts(reportId);

      if (reportRuns.isEmpty || prompts.isEmpty) {
        debugPrint('DEBUG: No report runs or prompts found.');
        return;
      }

      selectedReportRun = reportRuns.first;
      prompt = prompts.first;

      if (selectedReportRun == null || prompt == null) return;

      promptResults = await _reportService.fetchPromptResults(
        reportId,
        selectedReportRun!.id,
        prompt!.id,
        epoch,
      )..sort((a, b) => a.entityRank.compareTo(b.entityRank));

      // if (selectedReportRun == null ) return;
      // reportRunResults = await _reportService.fetchReportRunResults(selectedReportRun!.id);

      // if (reportRunResults == null ) return;

      // searchTargetRank = reportRunResults!.targetRank!;

      // promptResults.sort((a, b) => a.entityRank.compareTo(b.entityRank));

      debugPrint('DEBUG: promptResults fecthed!');

    } catch (e, stackTrace) {
      // Log full error for debugging
      errorMessage = 'Failed to initialize: $e';
      debugPrint('❌ [PromptViewModel] init error: $e\n$stackTrace');
    } finally {
      // Finish loading
      Future.microtask(() {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  Future<void> _fetchPromptResults() async {
    // Mark as loading
    Future.microtask(() {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
    });

    try {

      int epoch = 0;

      promptResults = await _reportService.fetchPromptResults(
        reportId,
        selectedReportRun!.id,
        prompt!.id,
        epoch,
      )..sort((a, b) => a.entityRank.compareTo(b.entityRank));
     

    } catch (e, stackTrace) {
      // Log full error for debugging
      errorMessage = 'Failed to initialize: $e';
      debugPrint('❌ [PromptViewModel] init error: $e\n$stackTrace');
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

    debugPrint('ReportViewModel error: $errorMessage');

    if (stackTrace != null) {
      debugPrint('Stack trace:\n$stackTrace');
    }

    // You can add extra error handling logic here, like:
    // - showing user-friendly messages
    // - sending logs to remote error tracking services
  }
}
