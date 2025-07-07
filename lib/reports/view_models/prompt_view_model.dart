import 'package:aiso/models/llm_enum.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/reports/models/prompt_result_model.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PromptViewModel extends ChangeNotifier {
  final String reportId;
  final String reportRunId;
  final String promptId;

  PromptViewModel({
    required this.reportId,
    required this.reportRunId,
    required this.promptId,
  }) {
    _init(); // Optional: load report immediately
  }

  bool isLoading = false;
  String? errorMessage;

  final ReportServiceSupabase _reportService = ReportServiceSupabase();

  Prompt? prompt;
  List<PromptResult> promptResults = [];
  List<PromptResult> get chatGptPromptResults {
  if (promptResults.isEmpty) return [];
    return promptResults.where((p) => LLMParsing.fromString(p.llmGeneration) == LLM.chatgpt).toList();
  }
  List<PromptResult> get geminiPromptResults {
  if (promptResults.isEmpty) return [];
    return promptResults.where((p) => LLMParsing.fromString(p.llmGeneration) == LLM.gemini).toList();
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
      promptResults = await _reportService.fetchPromptResults(
        reportId,
        reportRunId,
        promptId,
        epoch,
      );
      promptResults.sort((a, b) => a.entityRank.compareTo(b.entityRank));
      debugPrint('DEBUG: promptResults fecthed!');
      prompt = await _reportService.fetchPrompt(promptId);
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
