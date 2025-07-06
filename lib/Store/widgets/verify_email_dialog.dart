import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:flutter/material.dart';

void showVerifyEmailDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Verify email'),
      content: const Text(
        'Please verify your email to proceed with payment. A confirmation link was sent to your inbox when you signed up.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            appRouter.go(verifyEmailRoute);
          },
          child: const Text('More info'),
        ),

      ],
    ),
  );
}
