import 'dart:convert';
// import 'dart:ffi';

import 'package:aiso/models/entity_model.dart';
import 'package:aiso/models/industry_model.dart';
import 'package:aiso/models/location_models.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/prompt_template_model.dart';
import 'package:aiso/models/purchase_enum.dart';
import 'package:aiso/models/report_run_results_model.dart';
import 'package:aiso/reports/models/report_model.dart';
import 'package:aiso/models/report_results.dart';
import 'package:aiso/reports/models/prompt_result_model.dart';
import 'package:aiso/reports/models/report_run_model.dart';
import 'package:aiso/models/search_target_model.dart';
// import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ReportServiceSupabase {
  final _supabase = Supabase.instance.client;

  // service account //
  // Service account UUID (hardcoded for now)
  static const String _serviceAccountId = 'c339cd41-5a8b-48de-b466-812a6acf6b07';
  /// Returns the service account’s user ID.
  String fetchServiceAccount() => _serviceAccountId;

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
      .select('*, prompts(*), search_targets(*)')
      .eq('user_id', userId)
      .isFilter('deleted_at', null)
      .isFilter('prompts.deleted_at', null)
      .isFilter('search_targets.deleted_at', null);

    // Inspect the response to see its structure
    // debugPrint('Response: $response');

    final List<Report> reports = (response as List).map((item) {
      return Report.fromJson(item);
    }).toList();

    return reports;
  }

  Future<Report> fetchReport(String reportId) async {
    debugPrint('DEBUG: Service is fetching report with ID: $reportId');
    final response = await _supabase
      .from('reports')
      .select('*, prompts(*), search_targets(*)')
      .eq('id', reportId)
      .isFilter('deleted_at', null)
      .isFilter('prompts.deleted_at', null)
      .isFilter('search_targets.deleted_at', null)
      .single();

    final Report report = Report.fromJson(response);
    return report;
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

  Future<List<ReportRun>> fetchReportRuns(String reportId) async {
    debugPrint('DEBUG: Service is fetching all report runs for userId: $reportId');
    final response = await _supabase
      .from('report_runs')
      .select('*')
      .eq('report_id', reportId)
      .eq('status', 'completed')
      .isFilter('deleted_at', null);

    // Inspect the response to see its structure
    // debugPrint('Response: $response');

    final List<ReportRun> reportRuns = (response as List).map((item) {
      return ReportRun.fromJson(item);
    }).toList();

    return reportRuns;
  }

  // REPORT RESULTS //
  Future<ReportRunResults> fetchReportRunResults(String reportRunId) async {

    debugPrint('DEBUG: Service is fetching all report run results for reportRunId: $reportRunId');

    final response = await _supabase
      .from('report_results')
      .select()
      .eq('report_run_id', reportRunId)
      .limit(1)
      .maybeSingle(); // <- returns null instead of throwing

    if (response == null) {
      throw Exception('No report result found for reportRunId: $reportRunId');
    }

    debugPrint('DEBUG: report results response: $response');

    final ReportRunResults reportRunResult = ReportRunResults.fromJson(response);

    // final List<ReportRunResults> reportRunResult = (response as List).map((item) {
    //   return ReportRunResults.fromJson(item);
    // }).toList();

    return reportRunResult;
  }

  Future<List<Entity>> fetchLlmRunResults(String llmEochId) async {

    debugPrint('DEBUG: Service is fetchLlmRunResults');

    final response = await _supabase
      .from('llm_results')
      .select()
      .eq('llm_epoch_id', llmEochId);

    // debugPrint('DEBUG: report results response: $response');

    // final ReportRunResults reportRunResult = ReportRunResults.fromJson(response);

    final List<Entity> entities = (response as List).map((item) {
      return Entity.fromJson(item);
    }).toList();

    return entities;
  }
  


  Future<List<ReportResult>> fetchReportResults(String reportId) async {
    debugPrint('DEBUG: Service is fetching all report results For reportId: $reportId');
    final response = await _supabase
      .from('report_results_summary_vw')
      .select()
      .eq('report_id', reportId);

    // debugPrint('DEBUG: report results response: $response');

    final List<ReportResult> reports = (response as List).map((item) {
      return ReportResult.fromJson(item);
    }).toList();

    return reports;
  }

  Future<SearchTarget> fetchSearchTarget(String reportId) async {
    debugPrint('DEBUG: Service is fetching the search target for reportId: $reportId');
    final response = await _supabase
      .from('search_targets')
      .select()
      .eq('report_id', reportId)
      .select()
      .single();
    // debugPrint('DEBUG: report results response: $response');
    final SearchTarget searchTarget = SearchTarget.fromJson(response);
    return searchTarget;
  }

  Future<List<SearchTarget>> fetchSearchTargets(String userId) async {
    debugPrint('DEBUG: Service is fetching the search target for userId: $userId');
    final response = await _supabase
      .from('search_targets')
      .select()
      .eq('user_id', userId);

    debugPrint('DEBUG: search targets response: $response');

    final List<SearchTarget> searchTargets = (response as List).map((item) {
      return SearchTarget.fromJson(item);
    }).toList();

    return searchTargets;
  }

  // Future<void> runReport(String reportId) async {
  //   final supabase = Supabase.instance.client;
  //   // final session = supabase.auth.currentSession;

  //   final response = await supabase.functions.invoke(
  //     'run-report',
  //     method: HttpMethod.post,
  //     // headers: {
  //     //   'Authorization': 'Bearer ${session?.accessToken}',
  //     //   'Content-Type': 'application/json',
  //     // },
  //     // body: {'name': 'Functions'}
  //     body: {'reportId': reportId, 'name': 'Functions'}
  //     );

  //   if (response.status == 200) {
  //     final data = response.data;
  //     debugPrint('DEBUG: Function response: $data');
  //   } else {
  //     debugPrint('DEBUG: Function error (${response.status}): ${response.data}');
  //   }
  // }

  Future<String?> runReport(Report report, bool isPaid) async {
    final url = Uri.parse('https://app-kyeo.onrender.com/run-task'); // Replace with the correct path if needed

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'report_id': report.id,
          'is_paid': isPaid,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('DEBUG: Render response: $data');
        return data['report_run_id'] as String;
      } else {
        debugPrint('DEBUG: Render error (${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('DEBUG: Network error: $e');
      return null;
    }
  }

  Future<String?> generateCheckoutUrl(ProductType purchaseType, {String? reportId}) async {
    try {
      final accessToken = _supabase.auth.currentSession?.accessToken;
      if (accessToken == null) {
        debugPrint('DEBUG: No access token found. User might not be logged in.');
        return null;
      }

      final response = await _supabase.functions.invoke(
        'stripe-generate-checkout-url',
        body: {'productType': purchaseType.value, 'report_id': reportId},
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final data = response.data;
      final checkoutUrl = data?['checkout_url'] as String?;

      debugPrint('DEBUG: stripe-generate-checkout-url response: $data');
      debugPrint('DEBUG: stripe-generate-checkout-url URL: $checkoutUrl');

      return checkoutUrl;
    } catch (e, stackTrace) {
      debugPrint('DEBUG: handlePurchase error: $e');
      debugPrint('DEBUG: Stack trace: $stackTrace');
      return null;
    }
  }

  Future<String?> generateBillingPortal() async {
    try {
      final accessToken = _supabase.auth.currentSession?.accessToken;
      if (accessToken == null) {
        debugPrint('DEBUG: No access token found. User might not be logged in.');
        return null;
      }

      final response = await _supabase.functions.invoke(
        'stripe-billing-portal',
        body: {},
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final data = response.data;
      final url = data?['url'] as String?;

      debugPrint('DEBUG: stripe-billing-portal response: $data');
      debugPrint('DEBUG: stripe-billing-portal URL: $url');

      return url;
    } catch (e, stackTrace) {
      debugPrint('DEBUG: billing portal error: $e');
      debugPrint('DEBUG: Stack trace: $stackTrace');
      return null;
    }
  }



  // SEARCH TARGET //
  Future<SearchTarget> createSearchTarget(SearchTarget newSearchTarget) async {
    debugPrint('DEBUG: Service is creating a new search target.');
    final response = await _supabase
      .from('search_targets')
      // .insert(newSearchTarget.toJson())
      .upsert(
        newSearchTarget.toJson(),
        onConflict: 'user_id,industry_id,entity_type,name,description'
      )
      .select()
      .single();
    final SearchTarget insertedSearchTarget = SearchTarget.fromJson(response);
    debugPrint('DEBUG: inserted search target ID: ${insertedSearchTarget.id}');
    return insertedSearchTarget;
  }

  Future<void> softDeleteSearchTarget(SearchTarget searchTarget) async {
    debugPrint('DEBUG: Service is soft deleting a SearchTarget.');
    final response = await _supabase
      .from('search_targets')
      .update({
        'deleted_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      })
      .eq('id', searchTarget.id);
    if (response.error != null) {
      throw Exception('Failed to soft delete SearchTarget: ${response.error!.message}');
    }
  }

  Future<void> updateSearchTarget(SearchTarget searchTarget) async {
    debugPrint('DEBUG: Service is updating a SearchTarget.');
    final response = await _supabase
      .from('search_targets')
      .update(searchTarget.toJson())
      .eq('id', searchTarget.id);

    if (response.error != null) {
      throw Exception('Failed to update SearchTarget: ${response.error!.message}');
    }
  }







  // PROMPTS //
  Future<Prompt> createPrompt(Prompt newPrompt) async {
    debugPrint('DEBUG: Service is creating a new prompt: ${newPrompt.toJson()}');
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

  Future<Prompt> fetchPrompt(String promptId) async {
    debugPrint('DEBUG: Service is fetching prompt for promptId: $promptId');
    final response = await _supabase
      .from('prompts')
      .select()
      .eq('id', promptId)
      .isFilter('deleted_at', null)
      .single();
    final Prompt prompt = Prompt.fromJson(response);
    return prompt;
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

  Future<void> softDeletePrompt(Prompt prompt) async {
    debugPrint('DEBUG: Service is soft deleting a prompt.');
    await _supabase
      .from('prompts')
      .update({
        'deleted_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      })
      .eq('id', prompt.id);
  }

  Future<List<PromptResult>> fetchPromptResults(String reportId, String runId, String promptId) async {
    debugPrint('DEBUG: Service is fetching all prompt results for reportId: $reportId, runId: $runId');
    final response = await _supabase
      .from('prompt_results_vw')
      .select()
      .eq('report_id', reportId)
      .eq('run_id', runId)
      .eq('prompt_id', promptId)
      .isFilter('deleted_at', null);

    // Inspect the response to see its structure
    // debugPrint('Response: $response');

    final List<PromptResult> promptResults = (response as List).map((item) {
      return PromptResult.fromJson(item);
    }).toList();

    return promptResults;
  }

  /// Ensure a prompt exists for [text], attach it to [reportId], and return its Prompt record.
  Future<Prompt> upsertPromptAndAttach({required String reportId, required String promptText,}) async {
    // 1. Hash the normalized prompt
    // final promptHash = _hashString(promptText);

    // 2) Upsert into the prompts table directly by hash
    final response = await _supabase
        .from('prompts')
        .upsert({'prompt': promptText.trim()},  onConflict: 'prompt_hash')
        .select()
        .single();

    debugPrint("Response from prompts upsert: $response");

    // 3) Parse the Prompt object
    final Prompt prompt = Prompt.fromJson(response);

    // 4) Link prompt to report (idempotent via onConflict)
    await _supabase
        .from('report_prompts')
        .upsert({
          'report_id': reportId,
          'prompt_id': prompt.id,
        }, onConflict: 'report_id, prompt_id');

    // 5) Return the prompt record
    return prompt;

  }

  // // (Re-use your existing hash helper)
  // String _hashString(String value) {
  //   final normalized = value.trim().toLowerCase();
  //   final bytes = utf8.encode(normalized);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  // LOCATIONS

  Future<Locality> fetchLocality(String localityId) async {
    debugPrint('DEBUG: Service is fetching locality for localityId: $localityId');
    final response = await _supabase
      .from('locality_vw')
      .select()
      .eq('locality_id', localityId)
      .select()
      .single();
    // debugPrint('DEBUG: report results response: $response');
    final Locality locality = Locality.fromJson(response);
    return locality;
  }

  Future<Locality?> fetchLocalityFromHash(String localityHash) async {
    debugPrint('DEBUG: Service is fetching locality for hash: $localityHash');
    final response = await _supabase
      .from('localities')
      .select()
      .eq('locality_hash', localityHash)
      .select()
      .maybeSingle();
    if (response == null) return null;
    final Locality locality = Locality.fromJson(response);
    return locality;
  }

  Future<Locality> createLocality(Locality locality) async {
    debugPrint('DEBUG: Service is creating a locality: ${locality.regionIsoCode}, ${locality.name}.');
    final response = await _supabase
      .from('localities')
      .insert(locality.toJson())
      .select()
      .single();
    final Locality insertedLocality = Locality.fromJson(response);
    debugPrint('DEBUG: inserted Locality ID: ${insertedLocality.id}');
    return insertedLocality;
  }

  Future<List<Industry>> fetchIndustries() async {
    debugPrint('DEBUG: Service is fetching all industries');

    final response = await _supabase
      .from('industries')
      .select('id, name')
      .isFilter('deleted_at', null);

    // Inspect the response to see its structure
    // debugPrint('Response: $response');

    final List<Industry> industries = (response as List).map((item) {
      return Industry.fromJson(item);
    }).toList();

    return industries;
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