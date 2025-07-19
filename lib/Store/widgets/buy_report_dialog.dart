import 'package:flutter/material.dart';

void showBuyReportDialog(BuildContext context) {
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
          onPressed: () {
            // Navigate to subscription
            Navigator.pop(ctx);
          },
          child: const Text('Subscribe & Save'),
        ),
      ],
    ),
  );
}
