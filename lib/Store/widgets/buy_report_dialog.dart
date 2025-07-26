import 'package:aiso/Store/view_models/store_view_model.dart';
import 'package:aiso/models/purchase_enum.dart';
import 'package:aiso/services/url_launcher_service.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showBuyReportDialog(BuildContext context) {

  final storeVM = context.read<StoreViewModel>();
  final authVM = context.read<AuthViewModel>();
  final user = authVM.currentUser;

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text(
        'Subscribe and get 10 reports for \$14.95/month, or get one report for \$24.95.',
      ),
      actions: [
        // TextButton(
        //   onPressed: () => Navigator.pop(ctx),
        //   child: const Text('Cancel'),
        // ),
        // TextButton(
        //   onPressed: () {
        //     // Handle single report purchase
        //     Navigator.pop(ctx);
        //   },
        //   child: const Text('Buy 1 Report'),
        // ),
        ElevatedButton(
          // onPressed: () {
          //   // Navigate to subscription
          //   Navigator.pop(ctx);
          // },
          onPressed: () {

            if (user != null) {
              // ✅ Only launch if signed in
              UrlLauncherService.launchFromAsyncSource(() {
                return storeVM.handleProductAction(context, ProductType.SUBSCRIBE_MONTHLY);
              });
            } else {
              // ❌ Not signed in — redirect
              storeVM.handleProductAction(context, ProductType.SUBSCRIBE_MONTHLY);
            }
          },
          child: const Text('Subscribe & Save'),
        ),
      ],
    ),
  );
}
