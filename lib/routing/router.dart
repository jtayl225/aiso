import 'package:aiso/Home/views/home_view.dart';
import 'package:aiso/Store/views/store_view.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(MyHome(), settings.name);
    case AboutRoute:
      return _getPageRoute(MyHome(), settings.name);
    case StoreRoute:
      return _getPageRoute(MyStore(), settings.name);
    default:
      return _getPageRoute(MyHome(), settings.name);
  }
}

PageRoute _getPageRoute(Widget child, String? routeName) {
  return _FadeRoute(child: child, routeName: routeName);
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