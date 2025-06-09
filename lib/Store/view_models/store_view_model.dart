import 'package:aiso/Store/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A ChangeNotifier ViewModel to handle state & logic for the FreeReport flow.
/// It listens to supabase realtime on report_runs for status updates,
/// and drives both timeline and result screens.
class StoreViewModel extends ChangeNotifier {

  // final ReportServiceSupabase _reportService = ReportServiceSupabase();

  bool isLoading = false;
  String? errorMessage;

  final List<Product> products = [
    Product(
      id: '1',
      title: 'Individual Report',
      description: 'Get started with a single one-off report.',
      cadence: '/ month (AUD)',
      price: 14.99,
      reducedFromPrice: 19.99,
      productInclusions: [
        ProductInclusion(isIncluded: true, description: '\$14.99 / report'),
        ProductInclusion(isIncluded: true, description: 'ChatGPT (OpenAI)'),
        ProductInclusion(isIncluded: true, description: 'Gemini (Google)'),
        ProductInclusion(isIncluded: true, description: 'Only 1 report'),
        ProductInclusion(isIncluded: false, description: 'Up to 10 reports / month'),
        ProductInclusion(isIncluded: false, description: 'Up to 10 prompts / report'),
        ProductInclusion(isIncluded: false, description: 'Automated monthly report updates'),
      ],
      callToAction: 'Buy Now',
    ),
    Product(
      id: '2',
      title: 'Monthly Plan',
      description: 'All features for growing teams.',
      cadence: '/ month (AUD)',
      price: 9.99,
      reducedFromPrice: 14.99,
      productInclusions: [
        ProductInclusion(isIncluded: true, description: '\$9.99 / report'),
        ProductInclusion(isIncluded: true, description: 'ChatGPT (OpenAI)'),
        ProductInclusion(isIncluded: true, description: 'Gemini (Google)'),
        ProductInclusion(isIncluded: true, description: 'Up to 10 reports / month'),
        ProductInclusion(isIncluded: true, description: 'Up to 10 prompts / report'),
        ProductInclusion(isIncluded: true, description: 'Automated monthly report updates'),
      ],
      callToAction: 'Subscribe',
    ),
    Product(
      id: '3',
      title: 'Yearly Plan',
      description: 'Custom solutions for businesses.',
      cadence: '/ year (AUD)',
      price: 99.99,
      reducedFromPrice: 179.99,
      productInclusions: [
        ProductInclusion(isIncluded: true, description: '\$8.30 / report'),
        ProductInclusion(isIncluded: true, description: 'ChatGPT (OpenAI)'),
        ProductInclusion(isIncluded: true, description: 'Gemini (Google)'),
        ProductInclusion(isIncluded: true, description: 'Up to 10 reports / month'),
        ProductInclusion(isIncluded: true, description: 'Up to 10 prompts / report'),
        ProductInclusion(isIncluded: true, description: 'Automated monthly report updates'),
      ],
      callToAction: 'Subscribe',
    ),
  ];

  void _handleError(Object error, [StackTrace? stackTrace]) {
    errorMessage = error.toString();

    debugPrint('FreeReportViewModel error: $errorMessage');
    
    if (stackTrace != null) {
      debugPrint('Stack trace:\n$stackTrace');
    }

    // You can add extra error handling logic here, like:
    // - showing user-friendly messages
    // - sending logs to remote error tracking services
  }


}