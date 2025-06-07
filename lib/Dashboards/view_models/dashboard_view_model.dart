import 'package:aiso/Dashboards/services/dashboard_service.dart';
import 'package:flutter/foundation.dart';

class DashboardViewModel extends ChangeNotifier {

  final DashboardServiceSupabase _dashService = DashboardServiceSupabase();

  bool isLoading = false;
  String? errorMessage;

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

  Future<String?> generateDashUrl() async {
    isLoading = true;
    notifyListeners();

    try {
      debugPrint('DEBUG: view model about to call streamlit-url edge function');
      final String? url = await _dashService.generateDashUrl();
      return url; // Let the UI handle launching
    } catch (e) {
      _handleError(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}