import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/views/auth/auth_checker_screen.dart';
import 'package:aiso/views/reports/reports_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              final authViewModel = context.read<AuthViewModel>();
              final navigator = Navigator.of(context); // store before async gap
              await authViewModel.signOut();
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AuthChecker()),
                (route) => false,
              );
            },
          ),


        ],
      ),
    );
  }
}