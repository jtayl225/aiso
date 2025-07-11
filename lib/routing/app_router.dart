import 'package:aiso/Auth/views/signin_view.dart';
import 'package:aiso/Auth/views/signup_view.dart';
import 'package:aiso/Auth/views/verify_email_view.dart';
import 'package:aiso/NavBar/views/faq_view.dart';
import 'package:aiso/NavBar/views/privacy_policy_view.dart';
import 'package:aiso/NavBar/views/terms_and_conditions_view.dart';
import 'package:aiso/free_reports/views/free_report_confirmation_view.dart';
import 'package:aiso/reports/views/prompt_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aiso/Auth/views/auth_home_view.dart';
import 'package:aiso/Auth/views/auth_profile_view.dart';
import 'package:aiso/Home/views/home_view.dart';
import 'package:aiso/free_reports/views/free_report_view.dart';
import 'package:aiso/free_reports/views/free_report_results_screen.dart';
import 'package:aiso/free_reports/views/free_report_timeline_screen.dart';
import 'package:aiso/NewReport/views/new_report_view.dart';
import 'package:aiso/reports/views/report_view.dart';
import 'package:aiso/reports/views/reports_view.dart';
import 'package:aiso/Store/views/store_view.dart';
import 'package:aiso/routing/route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: initRoute,
  routes: [
    GoRoute(path: initRoute, pageBuilder: (context, state) => NoTransitionPage(child: const MyHome())),
    GoRoute(path: homeRoute, pageBuilder: (context, state) => NoTransitionPage(child: const MyHome())),
    GoRoute(path: aboutRoute, pageBuilder: (context, state) => NoTransitionPage(child: const MyHome())),
    GoRoute(path: storeRoute, pageBuilder: (context, state) => NoTransitionPage(child: const MyStore())),
    GoRoute(path: signInRoute, pageBuilder: (context, state) => NoTransitionPage(child: const SignInView())),
    GoRoute(path: signUpRoute, pageBuilder: (context, state) => NoTransitionPage(child: const SignUpView())),
    GoRoute(path: termsRoute, pageBuilder: (context, state) => NoTransitionPage(child: const TermsAndConditionsView())),
    GoRoute(path: privacyRoute, pageBuilder: (context, state) => NoTransitionPage(child: const PrivacyPolicyView())),
    GoRoute(path: faqRoute, pageBuilder: (context, state) => NoTransitionPage(child: const FAQView())),
    GoRoute(path: verifyEmailRoute, pageBuilder: (context, state) => NoTransitionPage(child: const VerifyEmailView())),

    GoRoute(path: getStartedRoute, pageBuilder: (context, state) => NoTransitionPage(child: const AuthHome())),
    GoRoute(path: reportsRoute, pageBuilder: (context, state) => NoTransitionPage(child: const MyReports())),

    GoRoute(
      path: reportRoute,
      pageBuilder: (context, state) {
        final reportId = state.uri.queryParameters['report_id']!;
        return  NoTransitionPage(child: MyReportView(reportId: reportId));
      },
    ),

    GoRoute(
      path: promptRoute,
      pageBuilder: (context, state) {
        final reportId = state.uri.queryParameters['report_id']!;
        final reportRunId = state.uri.queryParameters['report_run_id']!;
        final promptId = state.uri.queryParameters['prompt_id']!;
        return NoTransitionPage(child: MyPromptView(reportId: reportId, reportRunId: reportRunId, promptId: promptId)); 
      },
    ),

    GoRoute(path: newReportRoute, pageBuilder: (context, state) => NoTransitionPage(child: const NewReportView())),
    GoRoute(path: profileRoute, pageBuilder: (context, state) => NoTransitionPage(child: const AuthProfile())),
    GoRoute(path: freeReportFormRoute, pageBuilder: (context, state) => NoTransitionPage(child: const FreeReport())),
    GoRoute(path: freeReportConfirmationRoute, pageBuilder: (context, state) => NoTransitionPage(child: const FreeReportConfirmationView())),
    // GoRoute(path: freeReportTimelineRoute, pageBuilder: (context, state) => NoTransitionPage(child: const FreeReportTimelineScreen())),
    // GoRoute(path: freeReportResultsRoute, pageBuilder: (context, state) => NoTransitionPage(child: const FreeReportResultScreen())),
  ],
);

class NoTransitionPage<T> extends CustomTransitionPage<T> {
  NoTransitionPage({required Widget child})
      : super(
          child: child,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, child) => child,
        );
}

