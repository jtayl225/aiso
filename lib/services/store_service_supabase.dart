import 'dart:convert';

import 'package:aiso/models/purchase_enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StoreServiceSupabase {

  final _supabase = Supabase.instance.client;

  Future<String?> fetchStripeCustomerId(String userId) async {
    debugPrint('DEBUG: Service is fetching Stripe customer ID for userId: $userId');

    final response = await _supabase
        .from('stripe_users')
        .select('stripe_customer_id')
        .eq('user_id', userId)
        .isFilter('deleted_at', null)
        .maybeSingle();

    if (response == null) {
      debugPrint('No stripe_user record found for userId: $userId');
      return null;
    }

    // `response` is a Map<String, dynamic> or null from maybeSingle()
    return response['stripe_customer_id'] as String?;
  }



  // Future<String?> generateCheckoutUrl(ProductType purchaseType, {String? reportId}) async {
  //   try {
  //     final accessToken = _supabase.auth.currentSession?.accessToken;
  //     if (accessToken == null) {
  //       debugPrint('DEBUG: No access token found. User might not be logged in.');
  //       return null;
  //     }

  //     final response = await _supabase.functions.invoke(
  //       'stripe-generate-checkout-url',
  //       body: {'productType': purchaseType.value, 'report_id': reportId},
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     );

  //     final data = response.data;
  //     final checkoutUrl = data?['checkout_url'] as String?;

  //     debugPrint('DEBUG: stripe-generate-checkout-url response: $data');
  //     debugPrint('DEBUG: stripe-generate-checkout-url URL: $checkoutUrl');

  //     return checkoutUrl;
  //   } catch (e, stackTrace) {
  //     debugPrint('DEBUG: handlePurchase error: $e');
  //     debugPrint('DEBUG: Stack trace: $stackTrace');
  //     return null;
  //   }
  // }

  Future<String?>  generateCheckoutUrl(ProductType purchaseType, {String? reportId}) async {
    final url = Uri.parse('https://app-kyeo.onrender.com/generate-checkout-url'); // Replace with the correct path if needed

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

  // Future<String?> generateBillingPortal() async {
  //   try {
  //     final accessToken = _supabase.auth.currentSession?.accessToken;
  //     if (accessToken == null) {
  //       debugPrint('DEBUG: No access token found. User might not be logged in.');
  //       return null;
  //     }

  //     final response = await _supabase.functions.invoke(
  //       'stripe-billing-portal',
  //       body: {},
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     );

  //     final data = response.data;
  //     final url = data?['url'] as String?;

  //     debugPrint('DEBUG: stripe-billing-portal response: $data');
  //     debugPrint('DEBUG: stripe-billing-portal URL: $url');

  //     return url;
  //   } catch (e, stackTrace) {
  //     debugPrint('DEBUG: billing portal error: $e');
  //     debugPrint('DEBUG: Stack trace: $stackTrace');
  //     return null;
  //   }
  // }

  Future<String?> generateBillingPortal() async {
    final url = Uri.parse('https://app-kyeo.onrender.com/billing-portal'); // Replace with the correct path if needed

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