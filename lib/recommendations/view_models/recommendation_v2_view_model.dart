import 'package:aiso/models/location_models.dart';
import 'package:aiso/models/recommendation.dart';
import 'package:aiso/services/auth_service_supabase.dart';
import 'package:aiso/services/report_service_supabase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecommendationV2ViewModel extends ChangeNotifier {

  RecommendationV2ViewModel() {
    _init(); // Optional: load report immediately
  }

  bool isLoading = false;
  String? errorMessage;

  final AuthServiceSupabase _authService = AuthServiceSupabase();
  final ReportServiceSupabase _reportService = ReportServiceSupabase();

  final String vmName = 'RecommendationV2ViewModel';

  List<Recommendation> recommendations = [];
  List<Recommendation> get sortedRecommendations {
  return [...recommendations]..sort((a, b) {
    // Primary sort: completion status (incomplete first, completed last)
    final aCompleted = a.status.toLowerCase() == 'done';
    final bCompleted = b.status.toLowerCase() == 'done';
    
    if (!aCompleted && bCompleted) return -1;  // a (incomplete) comes before b (completed)
    if (aCompleted && !bCompleted) return 1;   // b (incomplete) comes before a (completed)
    
    // Secondary sort: effort * reward score (higher scores first)
    final aScore = a.effort * a.reward;
    final bScore = b.effort * b.reward;
    final scoreComparison = bScore.compareTo(aScore);
    if (scoreComparison != 0) return scoreComparison;
    
    // Tertiary sort: timestamp (earlier createdAt first)
    return a.createdAt.compareTo(b.createdAt);
  });
}

  List<Locality> locations = [];
  Locality? _selectedLocation;
  Locality? get selectedLocation => _selectedLocation;
  set selectedLocation(Locality? location) {
    _selectedLocation = location;
    // fetchSummaries(
    //   reportId: _selectedReport?.id,
    //   reportRunId: _selectedReportRun?.id,
    //   promptId: _selectedPrompt?.id,
    //   locationId: _selectedLocation?.id,
    // );
  }

  

  Future<void> _init() async {
    // Mark as loading
    Future.microtask(() {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
    });

    try {

    // Always attempt to load prompts and dashboards
    String? userId = await _authService.fetchCurrentUserId();
    if (userId == null) return;
    recommendations = await _reportService.fetchRecommendations(userId);

    // Extract localityIds safely as List<String>
    final localityIds = recommendations
        .map((r) => r.localityId)
        .whereType<String>() // removes nulls and ensures correct type
        .toSet()             // optional: remove duplicates
        .toList();

    if (localityIds.isEmpty) return;

    locations = await _reportService.fetchLocalities(localityIds);

    } catch (e, stackTrace) {
      // Log full error for debugging
      errorMessage = 'Failed to initialize: $e';
      debugPrint('❌ [$vmName] init error: $e\n$stackTrace');
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

    debugPrint('[$vmName] error: $errorMessage');

    if (stackTrace != null) {
      debugPrint('Stack trace:\n$stackTrace');
    }

    // You can add extra error handling logic here, like:
    // - showing user-friendly messages
    // - sending logs to remote error tracking services
  }

  Future<void> toggleRecommendationDone({required String recommendationId}) async {
    debugPrint('🔄 Toggling isDone for $recommendationId');

    try {
      final index = recommendations.indexWhere(
        (r) => r.id == recommendationId,
      );

      if (index == null || index == -1) {
        debugPrint('❌ Recommendation not found');
        return;
      }

      final current = recommendations[index];
      final newIsDone = current.status == 'done';

      // Update local state
      recommendations[index] = current.copyWith(status: newIsDone ? 'todo' : 'done');
      notifyListeners();

     final _ = await _reportService.updateRecommendationStatus(current.id, current.reportRunId, recommendations[index].status);

    } catch (e, st) {
      debugPrint('❌ Error toggling isDone: $e\n$st');
    }
  }


}
