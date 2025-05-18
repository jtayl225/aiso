import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/prompt_template_model.dart';
import 'package:aiso/models/report_model.dart';
import 'package:aiso/models/report_results.dart';
import 'package:aiso/models/search_target_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class ReportServiceSupabase {
  final _supabase = Supabase.instance.client;

  // REPORTS //
  Future<Report> createReport(Report newReport) async {
    debugPrint('DEBUG: Service is creating a new report.');
    try {
      final response = await _supabase
      .from('reports')
      .insert(newReport.toJson())
      .select()
      .single();
    final Report insertedReport = Report.fromJson(response);
    debugPrint('DEBUG: inserted report ID: ${insertedReport.id}');
    return insertedReport;
    } catch (e) {
      debugPrint('ERROR: Failed to create report: $e');
      rethrow; // or throw a custom exception
    }
  }

  Future<List<Report>> fetchReports(String userId) async {
    debugPrint('DEBUG: Service is fetching all reports for userId: $userId');
    final response = await _supabase
      .from('reports')
      .select('*, prompts(*)')
      .eq('user_id', userId)
      .isFilter('deleted_at', null);

    // // Inspect the response to see its structure
    // debugPrint('Response: $response');

    final List<Report> reports = (response as List).map((item) {
      return Report.fromJson(item);
    }).toList();

    return reports;
  }

  Future<Report> updateReport(Report report) async {
    debugPrint('DEBUG: Service is updating a report.');
    try {
      final response = await _supabase
      .from('reports')
      .update(report.toJson())
      .eq('id', report.id)
      .eq('user_id', report.userId)
      .select()
      .single();
    final Report insertedReport = Report.fromJson(response);
    debugPrint('DEBUG: updated report ID: ${insertedReport.id}');
    return insertedReport;
    } catch (e) {
      debugPrint('ERROR: Failed to update report: $e');
      rethrow; // or throw a custom exception
    }
  }

  // REPORT RESULTS //
  Future<List<ReportResult>> fetchReportResults(String reportId) async {
    debugPrint('DEBUG: Service is fetching all report results For reportId: $reportId');
    final response = await _supabase
      .from('report_results_summary_vw')
      .select()
      .eq('report_id', reportId);

    debugPrint('DEBUG: report results response: $response');

    final List<ReportResult> reports = (response as List).map((item) {
      return ReportResult.fromJson(item);
    }).toList();

    return reports;
  }

  Future<void> runReport(String reportId) async {
    final supabase = Supabase.instance.client;
    // final session = supabase.auth.currentSession;

    final response = await supabase.functions.invoke(
      'run-report',
      method: HttpMethod.post,
      // headers: {
      //   'Authorization': 'Bearer ${session?.accessToken}',
      //   'Content-Type': 'application/json',
      // },
      // body: {'name': 'Functions'}
      body: {'reportId': reportId, 'name': 'Functions'}
      );

    if (response.status == 200) {
      final data = response.data;
      debugPrint('DEBUG: Function response: $data');
    } else {
      debugPrint('DEBUG: Function error (${response.status}): ${response.data}');
    }
  }


  // SEARCH TARGET //
  Future<SearchTarget> createSearchTarget(SearchTarget newSearchTarget) async {
    debugPrint('DEBUG: Service is creating a new search target.');
    final response = await _supabase
      .from('search_targets')
      .insert(newSearchTarget.toJson())
      .select()
      .single();
    final SearchTarget insertedSearchTarget = SearchTarget.fromJson(response);
    debugPrint('DEBUG: inserted search target ID: ${insertedSearchTarget.id}');
    return insertedSearchTarget;
  }







  // PROMPTS //
  Future<Prompt> createPrompt(Prompt newPrompt) async {
    debugPrint('DEBUG: Service is creating a new prompt.');
    final response = await _supabase
      .from('prompts')
      .insert(newPrompt.toJson())
      .select()
      .single();
    final Prompt insertedPrompt = Prompt.fromJson(response);
    debugPrint('DEBUG: inserted prompt ID: ${insertedPrompt.id}');
    return insertedPrompt;
  }

  Future<List<Prompt>> createPrompts(List<Prompt> newPrompts) async {
    debugPrint('DEBUG: Service is creating ${newPrompts.length} new prompts.');

    final response = await _supabase
      .from('prompts')
      .insert(newPrompts.map((p) => p.toJson()).toList())
      .select();

    // Response is a List<dynamic> of inserted prompts
    final List<Prompt> insertedPrompts = (response as List).map((item) {
      return Prompt.fromJson(item);
    }).toList();

    debugPrint('DEBUG: inserted prompt IDs: ${insertedPrompts.map((p) => p.id).join(', ')}');

    return insertedPrompts;
  }

  Future<List<PromptTemplate>> fetchPromptTemplates() async {
    debugPrint('DEBUG: Service is fetching all prompt templates');
    final response = await _supabase
      .from('prompt_templates')
      .select()
      .isFilter('deleted_at', null)
      ;

    final List<PromptTemplate> promptTemplates = (response as List).map((item) {
      return PromptTemplate.fromJson(item);
    }).toList();

    return promptTemplates;
  }











  // Future<Team> createTeam(Team newTeam) async {
  //   debugPrint('DEBUG: Service is creating a new team.');
  //   final response = await _supabase
  //     .from('teams')
  //     .insert(newTeam.toJson())
  //     .select()
  //     .single();
  //   final Team insertedTeam = Team.fromJson(response);
  //   debugPrint('DEBUG: inserted teamId: ${insertedTeam.id}');
  //   return insertedTeam;
  // }

  // Future<List<Workspace>> fetchWorkspacesWithRelations(String userId) async {
  //   debugPrint('DEBUG: Service is fetching all workshpaces (nested) for userId: $userId');
  //   final response = await _supabase
  //     .from('user_workspaces')
  //     // .select('workspaces(*)')
  //     .select('workspaces(*, teams(*, task_types(*)))')
  //     .eq('user_id', userId)
  //     .isFilter('deleted_at', null)
  //     .isFilter('workspaces.deleted_at', null)
  //     .isFilter('workspaces.teams.deleted_at', null)
  //     .isFilter('workspaces.teams.task_types.deleted_at', null)
  //     ;

  //   // Inspect the response to see its structure
  //   debugPrint('Response: $response');

  //   final List<Workspace> workspaces = (response as List).map((item) {
  //     return Workspace.withRelationsFromJson(item['workspaces']);
  //   }).toList();

  //   return workspaces;
  // }

  // Future<List<Team>> fetchTeams(String workspaceId) async {
  //   debugPrint('DEBUG: Service is fetching all workspace teams.');
  //   final response = await _supabase
  //     .from('teams')
  //     .select()
  //     .eq('workspace_id', workspaceId);

  //   // Inspect the response to see its structure
  //   debugPrint('Response: $response');

  //   final List<Team> teams = (response as List).map((teamJson) {
  //     return Team.fromJson(teamJson);
  //   }).toList();
  //   return teams;  
  // }

  // Future<Team> fetchTeam(String workspaceId, String teamId) async {
  //   debugPrint('DEBUG: Service is fetching team for workspaceId: $workspaceId and teamId: $teamId');
  //   try {
  //     final response = await _supabase
  //       .from('teams')
  //       .select()
  //       .eq('workspace_id', workspaceId)
  //       .eq('id', teamId)
  //       .single();
  //     final Team team = Team.fromJson(response);
  //     debugPrint('DEBUG: fetched teamId: ${team.id}');
  //     return team;
  //   } catch (e) {
  //     debugPrint('Error fetching team: $e');
  //     rethrow; // Re-throw the error to be caught in the view model
  //   }
  // }


  // Future<bool> updateTeam(Team updatedTeam) async {
  //   debugPrint('DEBUG: Updating team with id: ${updatedTeam.id}');
  //   try {
  //     final response = await _supabase
  //       .from('teams')
  //       .update({
  //         'name': updatedTeam.name,
  //         'description': updatedTeam.description,
  //         'image_url': updatedTeam.imageUrl,
  //         // 'updated_at': updatedTeam.updatedAt?.toIso8601String(),
  //       })
  //       .eq('id', updatedTeam.id)
  //       .eq('workspace_id', updatedTeam.workspaceId);
  //     return response == null || response is List ? true : false; // Supabase update returns null on success (no rows affected if no change), so check for that.
  //   } catch (e) {
  //     debugPrint('Error updating team in database: $e');
  //     return false;
  //   }
  // }

}