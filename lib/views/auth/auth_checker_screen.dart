import 'package:aiso/models/auth_state_enum.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/views/auth/auth_screen.dart';
import 'package:aiso/views/reports/reports_home_screen.dart';
import 'package:aiso/views/todo_placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    switch (authViewModel.authState) {
      case AuthState.initial:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthState.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthState.error:
        return const Scaffold(body: Center(child: Text('An error occurred')));
      case AuthState.authenticated:
        return const ReportsHomeScreen();
      case AuthState.unauthenticated:
        return const AuthScreen();
    }

    // If new states are added and not handled, provide a fallback UI
    return const Scaffold(body: Center(child: Text('Unexpected state')));
  }
}
