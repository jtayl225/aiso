import 'package:aiso/Auth/views/auth_home_view.dart';
import 'package:aiso/Auth/views/auth_profile_view.dart';
import 'package:aiso/Home/views/home_view.dart';
import 'package:aiso/extensions/string_extensions.dart';
import 'package:aiso/reports/views/free_report_form_view.dart';
import 'package:aiso/reports/views/free_report_results_screen.dart';
import 'package:aiso/reports/views/free_report_timeline_screen.dart';
import 'package:aiso/NewReport/views/new_report_view.dart';
import 'package:aiso/reports/views/report_view.dart';
import 'package:aiso/reports/views/reports_view.dart';
import 'package:aiso/Store/views/store_view.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name?.getRoutingData;

  switch (routingData?.route) {
    case homeRoute:
      return _getPageRoute(MyHome(), settings.name);
    case aboutRoute:
      return _getPageRoute(MyHome(), settings.name);
    case storeRoute:
      return _getPageRoute(MyStore(), settings.name);
    case getStartedRoute:
      return _getPageRoute(AuthHome(), settings.name);
    case reportsRoute:
      return _getPageRoute(MyReports(), settings.name);
    case reportRoute:
      var reportId = routingData?['report_id'];
      return _getPageRoute(MyReportView(reportId: reportId), settings.name);
    case newReportRoute:
      return _getPageRoute(NewReportView(), settings.name);
    case profileRoute:
      return _getPageRoute(AuthProfile(), settings.name);
    case freeReportFormRoute:
      return _getPageRoute(FreeReport(), settings.name);
    case freeReportTimelineRoute:
      return _getPageRoute(FreeReportTimelineScreen(), settings.name);
    case freeReportResultsRoute:
      return _getPageRoute(FreeReportResultScreen(), settings.name);
    default:
      return _getPageRoute(MyHome(), settings.name);
  }
}

PageRoute _getPageRoute(Widget child, String? routeName) {
  return _NoTransitionRoute(child: child, routeName: routeName);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String? routeName;
  _FadeRoute({required this.child, this.routeName})
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                child,
            settings: RouteSettings(name: routeName),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                FadeTransition(
                  opacity: animation,
                  child: child,
                ));
}

class _NoTransitionRoute extends PageRouteBuilder {
  final Widget child;
  final String? routeName;

  _NoTransitionRoute({required this.child, this.routeName})
      : super(
          pageBuilder: (_, __, ___) => child,
          settings: RouteSettings(name: routeName),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, child) => child,
        );
}
