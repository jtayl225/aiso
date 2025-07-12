// import 'package:aiso/Dashboards/views/dashboard_menu.dart';
// import 'package:aiso/models/auth_state_enum.dart';
// import 'package:aiso/free_reports/views/generate_free_report_view.dart';
// import 'package:aiso/view_models/auth_view_model.dart';
// import 'package:aiso/views/auth/auth_screen.dart';
// import 'package:aiso/reports/views/reports_home_screen.dart';
// import 'package:aiso/views/todo_placeholder_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AuthChecker extends StatelessWidget {
//   const AuthChecker({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authViewModel = context.watch<AuthViewModel>();

//     switch (authViewModel.authState) {
//       case MyAuthState.initial:
//         return const Scaffold(body: Center(child: CircularProgressIndicator()));
//       case MyAuthState.loading:
//         return const Scaffold(body: Center(child: CircularProgressIndicator()));
//       case MyAuthState.anon:
//         return const FreeReportFormScreen();
//       case MyAuthState.error:
//         return const Scaffold(body: Center(child: Text('An error occurred')));
//       case MyAuthState.authenticated:
//         return const DashboardMenu(); // ReportsHomeScreen();
//       case MyAuthState.unauthenticated:
//         return const AuthScreen();
//     }

//     // If new states are added and not handled, provide a fallback UI
//     return const Scaffold(body: Center(child: Text('Unexpected state')));
//   }
// }
