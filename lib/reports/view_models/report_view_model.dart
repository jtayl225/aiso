import 'package:aiso/Dashboards/views/dashboard_menu.dart';
import 'package:aiso/models/cadence_enum.dart';
import 'package:aiso/models/db_timestamps_model.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/prompt_template_model.dart';
import 'package:aiso/models/purchase_enum.dart';
import 'package:aiso/models/recommendation.dart';
import 'package:aiso/reports/models/report_model.dart';
import 'package:aiso/models/search_target_model.dart';
import 'package:aiso/reports/models/report_run_model.dart';
import 'package:aiso/services/auth_service_supabase.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportViewModel extends ChangeNotifier {

  final String reportId;

  ReportViewModel({required this.reportId}) {
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

  SearchTarget? searchTarget;
  
  List<Prompt>? prompts = [];

  List<Recommendation>? recommendations = [];
  List<Recommendation>? get reportRunRecommendations {
  if (selectedReportRun == null || recommendations == null) return [];
    return recommendations!.where((r) => r.reportRunId == selectedReportRun!.id).toList();
  }

  List<Dashboard>? dashboards = [
    Dashboard(icon: Icons.analytics, title: 'Summary', description: 'High-level summary averaging across all of the prompts in your report.', number: 11),
    Dashboard(icon: Icons.analytics, title: 'Location', description: 'Prompt results by location.', number: 13),
    Dashboard(icon: Icons.analytics, title: 'Timeseries', description: 'Prompt results over time.', number: 12),
  ];

  Dashboard dash0 = Dashboard(icon: Icons.analytics, title: 'Summary', description: 'Descriptive statistics split by AI tool, prompt, and location.', number: 0);
  Dashboard dash1 = Dashboard(icon: Icons.analytics, title: 'Timeseries', description: 'Descriptive statistics over time.', number: 1);

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
    
    // Safely assign first report run if any exist
    if (reportRuns.isNotEmpty) {
      selectedReportRun = reportRuns.first;
    } else {
      selectedReportRun = null;
      debugPrint('⚠️ No report runs found for reportId: $reportId');
    }

    // Always attempt to load prompts and dashboards
    report = await _reportService.fetchReport(reportId);
    // searchTarget = await _reportService.fetchSearchTarget(report!.searchTargetId);
    searchTarget = report!.searchTarget;
    // prompts = await _reportService.fetchReportPrompts(reportId);
    prompts = report!.prompts;
    // dashboards = await _reportService.fetchMetabaseDashboards();
    recommendations = report?.recommendations ?? [];

    // // Only load recommendations if a run is selected
    // if (selectedReportRun != null) {
    //   recommendations = await _reportService.fetchRecommendations(
    //     selectedReportRun!.reportId,
    //     selectedReportRun!.id,
    //   );
    // } else {
    //   recommendations = [];
    // }

  } catch (e, stackTrace) {
    // Log full error for debugging
    errorMessage = 'Failed to initialize: $e';
    debugPrint('❌ [ReportViewModel] init error: $e\n$stackTrace');
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


  // Metabase
  Future<void> generateDashboardUrl(int dashboardNumber) async {
    isLoading = true;
    notifyListeners();

    try {

      final String? url = await _reportService.generateDashboardUrl(dashboardNumber, reportId, reportRunId: selectedReportRun?.id);

      if (url == null) {
        debugPrint('Checkout URL is null');
        return;
      }

      final Uri uri = Uri.parse(url);

      if (kIsWeb) {
        // Open in new browser tab
        await launchUrl(
          uri,
          webOnlyWindowName: '_blank',
        );
      } else {
        // Open in external browser
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('Could not launch $url');
        }
      }

    } catch (e) {
      debugPrint('generateDashboardUrl error: $e');
      return;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleRecommendationDone({
    required String recommendationId,
    required String reportRunId,
  }) async {
    debugPrint('🔄 Toggling isDone for $recommendationId');

    try {
      final index = recommendations?.indexWhere(
        (r) => r.id == recommendationId && r.reportRunId == reportRunId,
      );

      if (index == null || index == -1) {
        debugPrint('❌ Recommendation not found');
        return;
      }

      final current = recommendations![index];
      final newIsDone = !current.isDone;

      // Update local state
      recommendations![index] = current.copyWith(isDone: newIsDone);
      notifyListeners();

      // // Update backend
      // final response = await _supabase
      //     .from('recommendations')
      //     .update({
      //       'is_done': newIsDone,
      //       'updated_at': DateTime.now().toIso8601String(),
      //     })
      //     .match({
      //       'id': recommendationId,
      //       'report_run_id': reportRunId,
      //     });

      // debugPrint('✅ Supabase update response: $response');
    } catch (e, st) {
      debugPrint('❌ Error toggling isDone: $e\n$st');
    }
  }



  

}
