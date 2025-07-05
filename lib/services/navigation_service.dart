// // import 'package:flutter/material.dart';
// // import 'package:web/web.dart' as web;

// // class NavigationService {
// //   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// //   // Future<T?> navigateTo<T extends Object?>(
// //   //   String routeName, {
// //   //   Object? arguments,
// //   // }) {
// //   //   final nav = navigatorKey.currentState;
// //   //   if (nav == null) return Future.value(null);
// //   //   return nav.pushNamed<T>(routeName, arguments: arguments);
// //   // }

// //   Future<dynamic> navigateTo(String routeName, {Map<String, String>? queryParams}) {
// //     final nav = navigatorKey.currentState;
// //     if (nav == null) return Future.value(null);
// //     if (queryParams != null) {
// //       routeName = Uri(path: routeName, queryParameters: queryParams).toString();
// //     }
// //     return nav.pushNamed(routeName);
// //   }

// //   // Future<bool> goBack<T extends Object?>({T? result}) {
// //   //   final nav = navigatorKey.currentState;
// //   //   if (nav == null) return Future.value(false);
// //   //   return nav.maybePop(result);
// //   // }

// //   void goBack() {
// //     web.window.history.back();
// //   }

// //   void goForward() {
// //     web.window.history.forward();
// //   }

// // }

// import 'package:flutter/material.dart';

// class NavigationService {
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   // Optional: Manage custom navigation history
//   final List<RouteSettings> _history = [];
//   int _currentIndex = -1;

//   Future<dynamic> navigateTo(String routeName, {Map<String, String>? queryParams}) {
//     final nav = navigatorKey.currentState;
//     if (nav == null) return Future.value(null);

//     if (queryParams != null) {
//       routeName = Uri(path: routeName, queryParameters: queryParams).toString();
//     }

//     // Store in history
//     _currentIndex++;
//     _history.length = _currentIndex; // Trim forward history
//     _history.add(RouteSettings(name: routeName));

//     return nav.pushNamed(routeName);
//   }

//   Future<bool> goBack<T extends Object?>({T? result}) {
//     final nav = navigatorKey.currentState;
//     if (nav == null) return Future.value(false);

//     if (_currentIndex > 0) _currentIndex--; // Move back in history

//     return nav.maybePop(result);
//   }

//   Future<void> goForward() async {
//     final nav = navigatorKey.currentState;
//     if (nav == null) return;

//     if (_currentIndex + 1 < _history.length) {
//       _currentIndex++;
//       final route = _history[_currentIndex];
//       await nav.pushNamed(route.name!);
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:web/web.dart' as web;

// class NavigationService {
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   Future<dynamic> navigateTo(String routeName, {Map<String, String>? queryParams}) {
//     final nav = navigatorKey.currentState;
//     if (nav == null) return Future.value(null);

//     if (queryParams != null) {
//       routeName = Uri(path: routeName, queryParameters: queryParams).toString();
//     }

//     // Pushes a new entry in the browser history (which allows forward/back)
//     // web.window.history.pushState(null, '', routeName);
//     // return nav.pushNamed(routeName);
//     return nav.restorablePushNamed(routeName);

//   }

//   Future<bool> goBack<T extends Object?>({T? result}) {
//     web.window.history.back(); // Trigger browser history back
//     return Future.value(true);
//   }

//   void goForward() {
//     web.window.history.forward(); // Trigger browser history forward
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  late BuildContext _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  void navigateTo(String routeName, {Map<String, String>? queryParams}) {
    final uri = Uri(path: routeName, queryParameters: queryParams);
    _context.go(uri.toString());
  }

  void push(String routeName, {Map<String, String>? queryParams}) {
    final uri = Uri(path: routeName, queryParameters: queryParams);
    _context.push(uri.toString());
  }

  void goBack() {
    if (GoRouter.of(_context).canPop()) {
      GoRouter.of(_context).pop();
    }
  }
}

