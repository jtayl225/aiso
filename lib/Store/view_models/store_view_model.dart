import 'package:aiso/Store/models/product_model.dart';
import 'package:aiso/Store/widgets/buy_report_dialog.dart';
import 'package:aiso/Store/widgets/signin_dialog.dart';
// import 'package:aiso/Store/widgets/store_desktop.dart';
import 'package:aiso/Store/widgets/verify_email_dialog.dart';
import 'package:aiso/models/purchase_enum.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/auth_service_supabase.dart';
import 'package:aiso/services/store_service_supabase.dart';
import 'package:aiso/services/url_launcher_service.dart';
import 'package:aiso/utils/logger.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:web/web.dart' as web;

/// A ChangeNotifier ViewModel to handle state & logic for the FreeReport flow.
/// It listens to supabase realtime on report_runs for status updates,
/// and drives both timeline and result screens.
class StoreViewModel extends ChangeNotifier {

  final AuthServiceSupabase _authService = AuthServiceSupabase();
  final StoreServiceSupabase _storeService = StoreServiceSupabase();
  // final UrlLauncherService _urlLauncherService = UrlLauncherService();

  bool isLoading = false;
  String? errorMessage;
  late List<Product> products = [];
  late final Product _oneoff_access;
  late final Product _monthlySubcription;
  late final Product _yearlySubcription;

  Product? _selectedProduct;
  Product get selectedProduct => _selectedProduct ?? _monthlySubcription;
  set selectedProduct(Product? value) {
    _selectedProduct = value;    
    notifyListeners(); // ✅ Trigger UI rebuild
  }

  StoreViewModel() {

    _oneoff_access = Product(
        id: '1',
        title: 'One-off 30 Day Access',
        description: 'Get started with 30 day access.',
        cadence: '/ month',
        price: 29.95,
        // reducedFromPrice: 34.95,
        pctDiscount: 0.0,
        productInclusions: [
          ProductInclusion(isIncluded: true, description: '\$2.99 / report'),
          ProductInclusion(isIncluded: true, description: 'ChatGPT (OpenAI)'),
          ProductInclusion(isIncluded: true, description: 'Gemini (Google)'),
          // ProductInclusion(isIncluded: true, description: 'Only 1 report'),
          ProductInclusion(isIncluded: false, description: 'Up to 10 reports / month'),
          // ProductInclusion(isIncluded: false, description: 'Up to 10 prompts / report'),
          ProductInclusion(isIncluded: false, description: 'Monthly report updates'),
        ],
        callToAction: 'Buy Now',
        // onPressed: (context) => handleProductAction(context, ProductType.PURCHASE)
        // onPressed: (context) => UrlLauncherService.launchFromAsyncSource(() {
        //   return handleProductAction(context, ProductType.PURCHASE);
        // }),
         onPressed: (context) {
        
          final user =_authService.currentUser;

          if (user != null) {
            // ✅ Only launch if signed in
            UrlLauncherService.launchFromAsyncSource(() {
              return handleProductAction(context, ProductType.PURCHASE);
            });
          } else {
            // ❌ Not signed in — redirect
            handleProductAction(context, ProductType.PURCHASE);
          }
        },

      );

    _monthlySubcription = Product(
        id: '2',
        highlightLabel: 'Most popular',
        title: 'Monthly Plan',
        description: 'All features for growing teams.',
        cadence: '/ month',
        price: 17.95,
        // reducedFromPrice: 19.95,
        pctDiscount: 0.0,
        productInclusions: [
          ProductInclusion(isIncluded: true, description: '\$1.80 / report'),
          ProductInclusion(isIncluded: true, description: 'ChatGPT (OpenAI)'),
          ProductInclusion(isIncluded: true, description: 'Gemini (Google)'),
          ProductInclusion(isIncluded: true, description: 'Up to 10 reports / month'),
          // ProductInclusion(isIncluded: true, description: 'Up to 10 prompts / report'),
          ProductInclusion(isIncluded: true, description: 'Monthly report updates'),
        ],
        callToAction: 'Subscribe',
        // onPressed: (context) => handleProductAction(context, ProductType.SUBSCRIBE_MONTHLY),
       onPressed: (context) {

        final user =_authService.currentUser;

        if (user != null) {
          // ✅ Only launch if signed in
          UrlLauncherService.launchFromAsyncSource(() {
            return handleProductAction(context, ProductType.SUBSCRIBE_MONTHLY);
          });
        } else {
          // ❌ Not signed in — redirect
          handleProductAction(context, ProductType.SUBSCRIBE_MONTHLY);
        }
      },
      );

    _yearlySubcription = Product(
        id: '3',
        highlightLabel: 'Best value',
        title: 'Yearly Plan',
        description: 'Custom solutions for businesses.',
        cadence: '/ year',
        price: 169.95,
        // reducedFromPrice: 199.95,
        pctDiscount: 0.0,
        productInclusions: [
          ProductInclusion(isIncluded: true, description: '\$1.40 / report'),
          ProductInclusion(isIncluded: true, description: 'ChatGPT (OpenAI)'),
          ProductInclusion(isIncluded: true, description: 'Gemini (Google)'),
          ProductInclusion(isIncluded: true, description: 'Up to 10 reports / month'),
          // ProductInclusion(isIncluded: true, description: 'Up to 10 prompts / report'),
          ProductInclusion(isIncluded: true, description: 'Monthly report updates'),
        ],
        callToAction: 'Subscribe',
        // onPressed: (context) => handleProductAction(context, ProductType.SUBSCRIBE_YEARLY),
        onPressed: (context) {
        
          final user =_authService.currentUser;

          if (user != null) {
            // ✅ Only launch if signed in
            UrlLauncherService.launchFromAsyncSource(() {
              return handleProductAction(context, ProductType.SUBSCRIBE_YEARLY);
            });
          } else {
            // ❌ Not signed in — redirect
            handleProductAction(context, ProductType.SUBSCRIBE_YEARLY);
          }
        },
      );

    products = [
      _oneoff_access,
      _monthlySubcription,
      _yearlySubcription      
    ];

  }

  

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

  // Future<String?> handleProductAction(BuildContext context, ProductType productType) async {
  //   // This should return a URL (or null on error)
  //   final url = await _storeService.generateCheckoutUrl(productType, reportId: '');
  //   return url;
  // }


  // void handlePopUp(BuildContext context, ProductType productType) {
  //   final user = Supabase.instance.client.auth.currentUser;

  //   if (user == null) {
  //     showSignInDialog(context);
  //     return;
  //   }

  //   if (user.emailConfirmedAt == null) {
  //     showVerifyEmailDialog(context);
  //     return;
  //   }

  //   showBuyReportDialog(context);
  //   return;

  // }

  Future<String?> handleProductAction(BuildContext context, ProductType productType) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      switch (productType) {
        case ProductType.PURCHASE: selectedProduct = _oneoff_access;
          // showBuyReportDialog(context); // UI action, not a checkout URL
          // return null;
        case ProductType.SUBSCRIBE_MONTHLY: selectedProduct = _monthlySubcription;
        case ProductType.SUBSCRIBE_YEARLY: selectedProduct = _yearlySubcription;
    }
      appRouter.go(storeAuthRoute);
      return null;
    }

    if (user.emailConfirmedAt == null) {
      showVerifyEmailDialog(context);
      return null;
    }

    switch (productType) {
      case ProductType.PURCHASE:
        // showBuyReportDialog(context); // UI action, not a checkout URL
        // return null;
        return _storeService.generateCheckoutUrl(productType, reportId: '');
      case ProductType.SUBSCRIBE_MONTHLY:
        return _storeService.generateCheckoutUrl(productType, reportId: '');
      case ProductType.SUBSCRIBE_YEARLY:
        return _storeService.generateCheckoutUrl(productType, reportId: '');

    }
  }




  // Future<void> launchCheckoutUrl(ProductType productType) async {

  //   try {
  //     final String? url = await _storeService.generateCheckoutUrl(productType, reportId: '');

  //     if (url == null) {
  //       debugPrint('Checkout URL is null');
  //       return;
  //     }

  //     final Uri uri = Uri.parse(url);

  //     if (kIsWeb) {
  //       // Open in new browser tab
  //       // await launchUrl(uri, webOnlyWindowName: '_blank',);
  //       web.window.open(url, '_blank');
  //     } else {
  //       // Open in external browser
  //       if (await canLaunchUrl(uri)) {
  //         await launchUrl(uri, mode: LaunchMode.externalApplication);
  //       } else {
  //         debugPrint('Could not launch $url');
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('launchCheckoutUrl error: $e');
  //   } finally {
  //     notifyListeners();
  //   }

  // }


}