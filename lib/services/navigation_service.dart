// import 'package:flutter/material.dart';

// class NavigationService {
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   Future<dynamic> navigateTo(String routeName) {
//     return navigatorKey.currentState.pushNamed(routeName);
//   }

//   bool goBack() {
//     return navigatorKey.currentState.pop();
//   }
// }

import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?> navigateTo<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    final nav = navigatorKey.currentState;
    if (nav == null) return Future.value(null);
    return nav.pushNamed<T>(routeName, arguments: arguments);
  }

  Future<bool> goBack<T extends Object?>({T? result}) {
    final nav = navigatorKey.currentState;
    if (nav == null) return Future.value(false);
    return nav.maybePop(result);
  }
}
