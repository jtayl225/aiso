import 'dart:convert';
import 'package:aiso/constants/api_endpoints.dart';
import 'package:aiso/models/purchase_enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StoreServiceSupabase {

  final _supabase = Supabase.instance.client;

  // final String _env = kDebugMode ? 'test' : 'prod';
  final String _env = 'test';
  String get env => _env;

  Future<String?> fetchStripeCustomerId(String userId, String env) async {
    debugPrint('DEBUG: Service is fetching Stripe customer ID for userId: $userId');

    final response = await _supabase
        .from('stripe_users')
        .select('stripe_customer_id')
        .eq('user_id', userId)
        .eq('env', env)
        .isFilter('deleted_at', null)
        .maybeSingle();

    if (response == null) {
      debugPrint('No stripe_user record found for userId: $userId');
      return null;
    }

    // `response` is a Map<String, dynamic> or null from maybeSingle()
    return response['stripe_customer_id'] as String?;
  }

  Future<String?>  generateCheckoutUrl(ProductType purchaseType, {String? reportId}) async {

    // final String endpoint = kDebugMode ? '$fastAPI/generate-checkout-url-test' : '$fastAPI/generate-checkout-url-prod';
    final String endpoint = '$fastAPI/generate-checkout-url-test';

    final url = Uri.parse(endpoint); // Replace with the correct path if needed

    try {

      final accessToken = _supabase.auth.currentSession?.accessToken;
      if (accessToken == null) {
        debugPrint('DEBUG: No access token found. User might not be logged in.');
        return null;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'productType': purchaseType.value, 'report_id': reportId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('DEBUG: Render response: $data');
        return data['checkout_url'] as String;
      } else {
        debugPrint('DEBUG: Render error (${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('DEBUG: Network error: $e');
      return null;
    }
  }

  Future<String?> generateBillingPortal() async {

    // final String endpoint = kDebugMode ? '$fastAPI/billing-portal-test' : '$fastAPI/billing-portal-prod';
  final String endpoint = '$fastAPI/billing-portal-test';

    final url = Uri.parse(endpoint); // Replace with the correct path if needed

    try {

      final accessToken = _supabase.auth.currentSession?.accessToken;
      if (accessToken == null) {
        debugPrint('DEBUG: No access token found. User might not be logged in.');
        return null;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('DEBUG: Render response: $data');
        return data['url'] as String;
      } else {
        debugPrint('DEBUG: Render error (${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('DEBUG: Network error: $e');
      return null;
    }
  }

}