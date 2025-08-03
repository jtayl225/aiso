import 'package:aiso/models/cadence_enum.dart';
import 'package:aiso/models/db_timestamps_model.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/prompt_template_model.dart';
import 'package:aiso/models/purchase_enum.dart';
import 'package:aiso/reports/models/report_model.dart';
import 'package:aiso/models/search_target_model.dart';
import 'package:aiso/services/auth_service_supabase.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:flutter/material.dart';

class ReportsViewModel extends ChangeNotifier {

  ReportsViewModel() {
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

      // Fetch current user ID
      String? userId = await _authService.fetchCurrentUserId();
      if (userId == null) return;
      reports = await _reportService.fetchReports(userId);

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

  List<Report> reports = [];
  // List<Report> reports = [
  //   Report(id: '0', userId: '', searchTargetId: '', title: 'title', cadence: Cadence.month, dbTimestamps: DbTimestamps.now()),
  //   Report(id: '1', userId: '', searchTargetId: '', title: 'title2', cadence: Cadence.month, dbTimestamps: DbTimestamps.now()),
  //   Report(id: '2', userId: '', searchTargetId: '', title: 'title3', cadence: Cadence.month, dbTimestamps: DbTimestamps.now()),
  //   Report(id: '3', userId: '', searchTargetId: '', title: 'title4', cadence: Cadence.month, dbTimestamps: DbTimestamps.now()),
  //   Report(id: '4', userId: '', searchTargetId: '', title: 'title4', cadence: Cadence.month, dbTimestamps: DbTimestamps.now()),
  //   Report(id: '5', userId: '', searchTargetId: '', title: 'title4', cadence: Cadence.month, dbTimestamps: DbTimestamps.now()),
  //   Report(id: '6', userId: '', searchTargetId: '', title: 'title4', cadence: Cadence.month, dbTimestamps: DbTimestamps.now()),
  //   Report(id: '7', userId: '', searchTargetId: '', title: 'title4', cadence: Cadence.month, dbTimestamps: DbTimestamps.now()),
  //   Report(id: '8', userId: '', searchTargetId: '', title: 'title4', cadence: Cadence.month, dbTimestamps: DbTimestamps.now()),
  //   Report(id: '9', userId: '', searchTargetId: '', title: 'title4', cadence: Cadence.month, dbTimestamps: DbTimestamps.now()),
  // ];

  List<PromptTemplate> promptTemplates = [];
  bool isLoading = false;
  String? errorMessage;

  final AuthServiceSupabase _authService = AuthServiceSupabase();
  final ReportServiceSupabase _reportService = ReportServiceSupabase();

  void clearReports() {
    reports = [];
    // promptTemplates = [];
    errorMessage = null;
    isLoading = false;
    notifyListeners();
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


  Future<bool> createReport(Report newReport) async {
    isLoading = true;
    notifyListeners();
    try {
      final Report report = await _reportService.createReport(newReport);

      if (newReport.prompts != null && newReport.prompts!.isNotEmpty) {
        final updatedPrompts = newReport.prompts!
            .map((prompt) => prompt.copyWith(reportId: report.id))
            .toList();

        final reportPrompts = await _reportService.createPrompts(updatedPrompts);
        report.prompts = reportPrompts;
      }

      // if (newReport.searchTarget != null) {
      //   final updatedSearchTarget = newReport.searchTarget!.copyWith(reportId: report.id);
      //   final reportSearchTarget = await _reportService.createSearchTarget(updatedSearchTarget);
      //   report.searchTarget = reportSearchTarget;
      // }

      reports.add(report);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateReport(Report newReport) async {
    isLoading = true;
    notifyListeners();
    debugPrint('DEBUG: reportViewModel is updating report: ${newReport.id}');

    try {
      final originalReport = getReportById(newReport.id); // from local store
      debugPrint('DEBUG: old report:');
      debugPrint(originalReport!.prompts?.map((p) => 'Prompt(id: ${p.id}, title: ${p.prompt})').toList().toString());
       debugPrint('DEBUG: new report:');
      debugPrint(newReport.prompts?.map((p) => 'Prompt(id: ${p.id}, title: ${p.prompt})').toList().toString());

      final reportDidChange = _reportChanged(originalReport, newReport);
      final promptsDidChange = _promptsChanged(originalReport.prompts ?? [], newReport.prompts ?? []);
      final searchTargetDidChange = _searchTargetChanged(originalReport.searchTarget, newReport.searchTarget);

      if (reportDidChange) {
        Report _ = await _reportService.updateReport(newReport);
      } 

      // 🔁 Prompts CRUD logic
      if (promptsDidChange) {
        debugPrint('DEBUG: prompts did change');
        final updatedPrompts = newReport.prompts
          ?.map((prompt) => prompt.copyWith(reportId: newReport.id))
          .toList();
        await _syncPrompts(oldPrompts: originalReport.prompts, newPrompts: updatedPrompts);
      }

      // // 🧠 Search Target logic
      // if (searchTargetDidChange) {
      //   final SearchTarget updatedSearchTarget = newReport.searchTarget!.copyWith(reportId: newReport.id);
      //   await _syncSearchTarget(oldSearchTarget: originalReport.searchTarget, newSearchTarget: updatedSearchTarget);
      // }

      Report updatedReport = await _reportService.fetchReport(newReport.id);
      _upsertReport(updatedReport); // Update frontend memory/cache
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  void _upsertReport(Report report) {
    final index = reports.indexWhere((r) => r.id == report.id);
    if (index != -1) {
      reports[index] = report; // Update existing task
    } else {
      reports.add(report); // Add new task
    }
  }

  bool _reportChanged(Report? old, Report newReport) {
    if (old == null) return true;
    return old.title != newReport.title; // || old.description != newReport.description;
  }

  // PROMPTS // 
  bool _promptsChanged(List<Prompt> oldPrompts, List<Prompt> newPrompts) {
    debugPrint('DEBUG: comparing prompts. Old: ${oldPrompts.length}, New: ${newPrompts.length}');
    // if (oldPrompts == null || newPrompts == null) return oldPrompts != newPrompts;
    if (oldPrompts.length != newPrompts.length) return true;

    // for (final newPrompt in newPrompts) {
    //   final Prompt? matchingOld = oldPrompts
    //     .cast<Prompt?>()
    //     .firstWhere(
    //       (old) => old?.id == newPrompt.id,
    //       orElse: () => null,
    //     );

    //   if (matchingOld == null || !_promptEquals(matchingOld, newPrompt)) {
    //     return true;
    //   }
    // }
    return false;
  }

  Future<void> _syncPrompts({required List<Prompt>? oldPrompts, required List<Prompt>? newPrompts}) async {
    final existing = oldPrompts ?? [];
    final updated = newPrompts ?? [];

    final existingIds = existing.map((p) => p.id).toSet();
    final updatedIds = updated.map((p) => p.id).toSet();

    final deleted = existing.where((p) => !updatedIds.contains(p.id));
    final added = updated.where((p) => !existingIds.contains(p.id));
    final maybeUpdated = updated.where((p) => existingIds.contains(p.id));

    for (final prompt in deleted) {
      debugPrint('DEBUG: deleting new prompts');
      await _reportService.softDeletePrompt(prompt);
    }

    for (final prompt in added) {
      debugPrint('DEBUG: adding new prompts');
      await _reportService.createPrompt(prompt);
    }

    for (final prompt in maybeUpdated) {
      // final existingPrompt = existing.firstWhere((p) => p.id == prompt.id);
      // if (prompt != existingPrompt) {
      //   await _reportService.updatePrompt(prompt);
      // }
    }
  }

  // SEARCH TARGET //
  Future<void> _syncSearchTarget({
    SearchTarget? oldSearchTarget,
    SearchTarget? newSearchTarget
  }) async {
    if (oldSearchTarget != null && newSearchTarget == null) {
      // Delete search target if it existed but now removed
      await _reportService.softDeleteSearchTarget(oldSearchTarget);
    } else if (newSearchTarget != null) {
      if (oldSearchTarget == null) {
        // Create new search target if none existed before
        await _reportService.createSearchTarget(newSearchTarget);
      } else {
        // Update existing search target
        await _reportService.updateSearchTarget(newSearchTarget);
      }
    }
  }

  bool _searchTargetChanged(SearchTarget? oldTarget, SearchTarget? newTarget) {
    if (oldTarget == null && newTarget == null) return false;
    if (oldTarget == null || newTarget == null) return true;
    return !_searchTargetEquals(oldTarget, newTarget);
  }

  // bool _promptEquals(Prompt a, Prompt b) {
  //   return a.id == b.id &&
  //       a.title == b.title &&
  //       a.description == b.description &&
  //       a.inputType == b.inputType;
  // }

  bool _searchTargetEquals(SearchTarget a, SearchTarget b) {
    return a.entityType == b.entityType &&
        a.name == b.name &&
        a.description == b.description &&
        a.url == b.url;
  }

  Future<bool> signinFetchAll(String userId) async {
    isLoading = true;
    notifyListeners();
    try {
      // parallel
      // final promptTemplatesFuture = _reportService.fetchPromptTemplates();
      final reportsFuture = _reportService.fetchReports(userId);
      // promptTemplates = await promptTemplatesFuture;
      reports = await reportsFuture;
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> fetchReportResults(String reportId) async {
    isLoading = true;
    notifyListeners();
    try {
      final reportResults = await _reportService.fetchReportResults(reportId);
      final reportSearchTarget = await _reportService.fetchSearchTarget(reportId);
      // debugPrint('DEBUG: report results: $reportResults');

      final report = reports.firstWhere(
        (r) => r.id == reportId,
        orElse: () => throw Exception('Report not found'),
      );

      report.results = reportResults;
      report.searchTarget = reportSearchTarget;
      _upsertReport(report);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Returns a Report object by reportId, or null if not found
  Report? getReportById(String reportId) {
    try {
      return reports.firstWhere((report) => report.id == reportId);
    } catch (e) {
      return null; // Report not found
    }
  }

  // Future<bool> runReport(Report report) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     debugPrint('DEBUG: view model about to call run-report edge function');
  //     await _reportService.runReport(report, true);
  //     return true;
  //   } catch (e) {
  //     _handleError(e);
  //     return false;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

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

  

  






  // Future<bool> fetchWorkspacesWithRelations(String userId) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     workspaces = await _workspaceService.fetchWorkspacesWithRelations(userId);
  //     return true;
  //   } catch (e) {
  //     _handleError(e as Exception);
  //     return false;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // // TEAMS // 
  // void _upsertTeam(Team team) {
  //   final workspaceIndex = workspaces.indexWhere((w) => w.id == team.workspaceId);
  //   if (workspaceIndex == -1) {
  //     throw Exception('Workspace not found for team.');
  //   }
  //   final workspace = workspaces[workspaceIndex];
  //   workspace.teams ??= [];

  //   final teamIndex = workspace.teams!.indexWhere((t) => t.id == team.id);
  //   if (teamIndex != -1) {
  //     workspace.teams![teamIndex] = team;
  //   } else {
  //     workspace.teams!.add(team);
  //   }

  //   workspaces[workspaceIndex] = workspace;

  // }

  // Future<bool> createTeam(Team team) async {
  //   isLoading = true;
  //   notifyListeners(); 
  //   try {
  //     final Team insertedTeam = await _workspaceService.createTeam(team);

  //     // Sequential
  //     // for (final taskType in newTeam.taskTypes) {
  //     //   final TaskType newTaskType = taskType.copyWith(teamId: team.id);
  //     //   await _workspaceService.createTaskType(newTaskType);
  //     // }

  //     // Prepare all task type creation futures
  //     final futures = team.taskTypes.map((taskType) {
  //       final newTaskType = taskType.copyWith(teamId: insertedTeam.id);
  //       return _workspaceService.createTaskType(newTaskType);
  //     }).toList();

  //     // Run them all in parallel and wait for all to finish
  //     await Future.wait(futures);

  //     // fetch inserted task types and add to team
  //     final List<TaskType> insertedTaskTypes = await _workspaceService.fetchTeamTaskTypes(insertedTeam.id);
  //     insertedTeam.taskTypes = insertedTaskTypes;

  //     _upsertTeam(insertedTeam);
  //     return true;
  //   } catch (e) {
  //     errorMessage = e.toString();
  //     debugPrint('Error creating org: $errorMessage');
  //     return false;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners(); // One place to update UI
  //   }
  // }

  // Future<bool> updateTeam(Team updatedTeam) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     final success = await _workspaceService.updateTeam(updatedTeam);
  //     if (!success) throw Exception('Error updating teamteam.');
  //     _upsertTeam(updatedTeam);
  //     return true;
  //   } catch (e) {
  //     errorMessage = 'Error updating team: ${e.toString()}';
  //     debugPrint(errorMessage);
  //     return false;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> fetchTeam(String workspaceId, String teamId) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     final Team team = await _workspaceService.fetchTeam(workspaceId, teamId);
  //     // final TaskType taskTypesForTeam = await _workspaceService.fetchTeamTaskTypes(teamId); // TODO
  //     _upsertTeam(team);
  //   } catch (e) {
  //     errorMessage = 'Failed to fetch team: ${e.toString()}';
  //     debugPrint('Error in fetchTeam: $e');
  //   } finally {
  //     isLoading = false; // Reset the loading state
  //     notifyListeners(); // Notify the UI to update the loading state
  //   }
  // }

}
