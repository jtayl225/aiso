import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/prompt_template_model.dart';
import 'package:aiso/models/report_model.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:flutter/material.dart';

class ReportViewModel extends ChangeNotifier {

  List<Report> reports = [];
  List<PromptTemplate> promptTemplates = [];
  bool isLoading = false;
  String? errorMessage;
  final ReportServiceSupabase _reportService = ReportServiceSupabase();

  void _handleError(Exception e) {
    errorMessage = e.toString();
    debugPrint('ReportViewModel error: $errorMessage');
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

      if (newReport.searchTarget != null) {
        final updatedSearchTarget = newReport.searchTarget!.copyWith(reportId: report.id);
        final reportSearchTarget = await _reportService.createSearchTarget(updatedSearchTarget);
        report.searchTarget = reportSearchTarget;
      }

      reports.add(report);
      return true;
    } catch (e) {
      _handleError(e as Exception);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateReport(Report newReport) async {
    isLoading = true;
    notifyListeners();
    try {
      final updatedReport = await _reportService.updateReport(newReport);
      _upsertReport(updatedReport);
      return true;
    } catch (e) {
      _handleError(e as Exception);
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

  Future<bool> signinFetchAll(String userId) async {
    isLoading = true;
    notifyListeners();
    try {
      // parallel
      final promptTemplatesFuture = _reportService.fetchPromptTemplates();
      final reportsFuture = _reportService.fetchReports(userId);
      promptTemplates = await promptTemplatesFuture;
      reports = await reportsFuture;
      return true;
    } catch (e) {
      _handleError(e as Exception);
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

      final report = reports.firstWhere(
        (r) => r.id == reportId,
        orElse: () => throw Exception('Report not found'),
      );

      report.results = reportResults;
      _upsertReport(report);
      return true;
    } catch (e) {
      _handleError(e as Exception);
      return false;
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
