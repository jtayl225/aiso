import 'package:aiso/reports/models/report_model.dart';
import 'package:aiso/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class DataSummary {
  final Map<String, double> byLlm;
  final Map<String, double> byLocation;
  final double overall;

  DataSummary({
    required this.byLlm,
    required this.byLocation,
    required this.overall,
  });
}


class DashboardServiceSupabase {
  final _supabase = Supabase.instance.client;


  Future<DataSummary> fetchPercentFoundSummary({
    // required String userId, 
    required String reportId, 
    String? reportRunId, 
    String? promptId, 
    String? locationId
    }) async {

    printDebug('Dashboard service: fetchPercentFoundSummary');

    PostgrestFilterBuilder query = _supabase
      .from('dash_01_vw')
      .select('llm_generation, locality_name, target_found')
      // .eq('user_id', userId)
      .eq('report_id', reportId) // enough if RLS is properly scoped
      ;

    if (reportRunId != null) {
      query = query.eq('report_run_id', reportRunId);
    }

    if (promptId != null) {
      query = query.eq('prompt_id', promptId);
    }

    if (locationId != null) {
      query = query.eq('locality_id', locationId);
    }

    final List data = await query;

    // printDebug('fetchPercentFoundSummary response: $data');

    // by LLM
    final Map<String, List<bool>> byLlm = {};
    for (final row in data) {
      final gen = row['llm_generation'];
      final found = row['target_found'] == true;
      byLlm.putIfAbsent(gen, () => []).add(found);
    }

    final Map<String, double> percentByLlm = {
      for (final e in byLlm.entries)
        e.key: e.value.where((f) => f).length / e.value.length
    };

    // by Location
    final Map<String, List<bool>> byLoc = {};
    for (final row in data) {
      final loc = row['locality_name'];
      final found = row['target_found'] == true;
      byLoc.putIfAbsent(loc, () => []).add(found);
    }

    final Map<String, double> percentByLoc = {
      for (final e in byLoc.entries)
        e.key: e.value.where((f) => f).length / e.value.length
    };

    // overall
    final total = data.length;
    final found = data.where((row) => row['target_found'] == true).length;
    final overallPercent = total > 0 ? found / total : 0.0;

    return DataSummary(
      byLlm: percentByLlm,
      byLocation: percentByLoc,
      overall: overallPercent,
    );

  }

  Future<DataSummary> fetchMeanRankSummary({
    // required String userId, 
    required String reportId, 
    String? reportRunId, 
    String? promptId, 
    String? locationId
    }) async {

    printDebug('Dashboard service: fetchMeanRankSummary');

    PostgrestFilterBuilder query = _supabase
      .from('dash_01_vw')
      .select('llm_generation, locality_name, target_rank')
      // .eq('user_id', userId)
      .eq('target_found', true)
      .eq('report_id', reportId) // enough if RLS is properly scoped
      ;

    if (reportRunId != null) {
      query = query.eq('report_run_id', reportRunId);
    }

    if (promptId != null) {
      query = query.eq('prompt_id', promptId);
    }

    if (locationId != null) {
      query = query.eq('locality_id', locationId);
    }

    final List data = await query;

    // printDebug('fetchMeanRankSummary response: $data');

    // by LLM
    final Map<String, List<num>> byLlm = {};

    for (final row in data) {
      final gen = row['llm_generation'];
      final rank = row['target_rank'];

      // Skip nulls or convert safely
      if (rank != null) {
        byLlm.putIfAbsent(gen, () => []).add(rank);
      }
    }

    final Map<String, double> meanRankByLlm = {
      for (final entry in byLlm.entries)
        entry.key: entry.value.isEmpty
            ? 0.0
            : entry.value.reduce((a, b) => a + b) / entry.value.length // same as sum(values) / count(values)
    };


    // by Location
    final Map<String, List<num>> byLoc = {};

    for (final row in data) {
      final loc = row['locality_name'];
      final rank = row['target_rank'];

      // Skip nulls or convert safely
      if (rank != null) {
        byLoc.putIfAbsent(loc, () => []).add(rank);
      }
    }

    final Map<String, double> meanRankByLocation = {
      for (final entry in byLoc.entries)
        entry.key: entry.value.isEmpty
            ? 0.0
            : entry.value.reduce((a, b) => a + b) / entry.value.length // same as sum(values) / count(values)
    };

    // overall
    final validRanks = data
        .map((row) => row['target_rank'])
        .where((rank) => rank != null)
        .cast<num>()
        .toList();

    final overallMeanRank = validRanks.isNotEmpty
        ? validRanks.reduce((a, b) => a + b) / validRanks.length
        : 0.0;

    return DataSummary(
      byLlm: meanRankByLlm,
      byLocation: meanRankByLocation,
      overall: overallMeanRank,
    );

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

  Future<String?> generateDashUrl() async {
    try {
      final accessToken = _supabase.auth.currentSession?.accessToken;
      final userId = _supabase.auth.currentUser?.id;
      if (accessToken == null) {
        debugPrint('DEBUG: No access token found. User might not be logged in.');
        return null;
      }

      final response = await _supabase.functions.invoke(
        'streamlit-url',
        body: {'user_id': userId},
        // headers: {
        //   'Authorization': 'Bearer $accessToken',
        // },
      );

      final data = response.data;
      // final token = data?['token'] as String?;
      final url = data?['url'] as String?;

      debugPrint('DEBUG: streamlit-url response: $data');
      debugPrint('DEBUG: streamlit-url URL: $url');

      return url;
    } catch (e, stackTrace) {
      debugPrint('DEBUG: handlePurchase error: $e');
      debugPrint('DEBUG: Stack trace: $stackTrace');
      return null;
    }
  }

 
}