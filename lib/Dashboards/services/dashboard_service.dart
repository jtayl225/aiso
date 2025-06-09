import 'package:aiso/Reports/models/report_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class DashboardServiceSupabase {
  final _supabase = Supabase.instance.client;

  
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