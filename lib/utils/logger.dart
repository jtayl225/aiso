import 'package:flutter/foundation.dart';

void printDebug(String message) {
  if (kDebugMode) {
    debugPrint('DEBUG: $message');
  }
}

void printInfo(String message) {
  if (kDebugMode) {
    debugPrint('INFO: $message');
  }
}

void printError(String message) {
  if (kDebugMode) {
    debugPrint('ERROR: $message');
  }
}
