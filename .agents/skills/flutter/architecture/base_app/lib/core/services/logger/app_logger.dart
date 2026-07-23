import 'dart:developer';

import 'package:flutter/foundation.dart';

class AppLogger {
  static void i(String message, {String? logName}) {
    if (kDebugMode) {
      log(message, name: logName ?? 'AppLogger_info', level: 800);
    }
  }

  static void w(String message, {String? logName}) {
    if (kDebugMode) {
      log(message, name: logName ?? 'AppLogger_warning', level: 900);
    }
  }

  static void e(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? logName,
  }) {
    if (kDebugMode) {
      log(
        message,
        name: logName ?? 'AppLogger_error',
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
