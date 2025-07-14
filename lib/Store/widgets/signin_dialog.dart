import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:flutter/material.dart';

void showSignInDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Sign in'),
      content: const Text(
        'Please sign in to continue to payment.',
      ),
      actions: [
        // TextButton(
        //   onPressed: () => Navigator.pop(ctx),
        //   child: const Text('Cancel'),
        // ),

        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.pop(ctx);
        //     appRouter.go(signUpRoute);
        //   },
        //   child: const Text('Sign up'),
        // ),

        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            appRouter.go(signInRoute);
          },
          child: const Text('Sign in'),
        ),
      ],
    ),
  );
}
