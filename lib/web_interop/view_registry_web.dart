// view_registry_web.dart

// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

import 'package:web/web.dart' as web;

typedef ViewFactory = Object Function(int viewId);

void registerViewFactory(String viewType, ViewFactory factory) {
  ui_web.platformViewRegistry.registerViewFactory(viewType, factory);
}
