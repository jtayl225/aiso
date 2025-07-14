import 'package:aiso/locator.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/views/auth/auth_checker_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:aiso/routing/app_router.dart';

class AuthProfileDesktop extends StatelessWidget {
  const AuthProfileDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.currentUser;
    final email = user?.email ?? 'Unknown';
    final isSubscribed = authVm.isSubscribed;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Account Settings',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                // — Email display
                Text('Email', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(email, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 24),

                // — Subscription status
                Text(
                  'Subscription',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  isSubscribed ? 'Active subscriber' : 'Free tier',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),

                // // — Change Email button
                // ElevatedButton(
                //   onPressed: () {
                //     // TODO: Navigate to change-email flow
                //   },
                //   child: const Text('Change Email'),
                // ),
                // const SizedBox(height: 12),

                // // — Change Password button
                // ElevatedButton(
                //   onPressed: () {
                //     // TODO: Navigate to change-password flow
                //   },
                //   child: const Text('Change Password'),
                // ),
                // const SizedBox(height: 12),

                // — Manage Billing button
                ElevatedButton(
                  onPressed: () {                 
                    authVm.launchBillingPortalUrl();
                  },
                  child: const Text('Manage Billing'),
                ),

                const SizedBox(height: 12),

                // — Sign Out

                // OutlinedButton(
                //   onPressed: () async {
                //     await authVm.signOut();
                //     appRouter.go(homeRoute);
                //   },
                //   child: const Text('Sign Out'),
                // ),

                 ElevatedButton(
                  onPressed: () async {
                    await authVm.signOut();
                    appRouter.go(homeRoute);
                  },
                  child: const Text('Sign Out'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
