import 'package:aiso/NavBar/views/navgation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/views/auth/auth_checker_screen.dart';

class AuthProfileDesktop extends StatelessWidget {
  const AuthProfileDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user   = authVm.currentUser;
    final email  = user?.email ?? 'Unknown';
    final isSubscribed = authVm.isSubscribed;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: [
            const MyNavigationBar(),

            const SizedBox(height: 24),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Account Settings',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 16),

                      // — Email display
                      Text('Email', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(email, style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 24),

                      // — Subscription status
                      Text('Subscription', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        isSubscribed ? 'Active subscriber' : 'Free tier',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),

                      // — Change Email button
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to change-email flow
                        },
                        child: const Text('Change Email'),
                      ),
                      const SizedBox(height: 12),

                      // — Change Password button
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to change-password flow
                        },
                        child: const Text('Change Password'),
                      ),
                      const SizedBox(height: 12),

                      // — Manage Billing button
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to billing/subscription page
                        },
                        child: const Text('Manage Billing'),
                      ),
                      const SizedBox(height: 24),

                      // — Sign Out
                      OutlinedButton(
                        onPressed: () async {
                          await authVm.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const AuthChecker()),
                            (_) => false,
                          );
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
