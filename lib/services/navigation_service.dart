import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Future<T?> navigateTo<T extends Object?>(
  //   String routeName, {
  //   Object? arguments,
  // }) {
  //   final nav = navigatorKey.currentState;
  //   if (nav == null) return Future.value(null);
  //   return nav.pushNamed<T>(routeName, arguments: arguments);
  // }

  Future<dynamic> navigateTo(String routeName, {Map<String, String>? queryParams}) {
    final nav = navigatorKey.currentState;
    if (nav == null) return Future.value(null);
    if (queryParams != null) {
      routeName = Uri(path: routeName, queryParameters: queryParams).toString();
    }
    return nav.pushNamed(routeName);
  }

  Future<bool> goBack<T extends Object?>({T? result}) {
    final nav = navigatorKey.currentState;
    if (nav == null) return Future.value(false);
    return nav.maybePop(result);
  }
}
