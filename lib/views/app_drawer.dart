import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/views/auth/auth_checker_screen.dart';
import 'package:aiso/views/auth/signin_screen.dart';
import 'package:aiso/reports/views/reports_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final isAnon = authViewModel.isAnonymous;
    return Drawer(
      child: ListView(
        children: [
          
          DrawerHeader(child: Text('Menu')),

          ListTile(
            leading: Icon(Icons.description),
            title: Text('Reports'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ReportsHomeScreen()),
              );
            },
          ),
          
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Billing'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/adminHub');
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),

          ListTile(
            leading: Icon(isAnon ? Icons.login : Icons.logout),
            title: Text(isAnon ? 'Sign in' : 'Sign out'),
            onTap: () async {
              final navigator = Navigator.of(context); // save before await

              if (isAnon) {
                // Navigate to SignIn screen
                // authViewModel.setAuthScreenState(AuthScreenState.signIn);
                navigator.push(
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              } else {
                // Sign out and reset navigation
                await authViewModel.signOut();
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AuthChecker()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}