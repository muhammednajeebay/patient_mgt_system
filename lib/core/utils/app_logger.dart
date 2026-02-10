import 'package:flutter/foundation.dart';

class AppLogger {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';

  static void log(dynamic message) {
    if (kDebugMode) {
      print('$_blue[LOG] $message$_reset');
    }
  }


  static void info(dynamic message) {
    if (kDebugMode) {
      print('$_cyan[INFO] $message$_reset');
    }
  }

  static void success(dynamic message) {
    if (kDebugMode) {
      print('$_green[SUCCESS] $message$_reset');
    }
  }

  static void warning(dynamic message) {
    if (kDebugMode) {
      print('$_yellow[WARNING] $message$_reset');
    }
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('$_red[ERROR] $message$_reset');
      if (error != null) print('$_red$error$_reset');
      if (stackTrace != null) print('$_red$stackTrace$_reset');
    }
  }

  static void debug(dynamic message) {
    if (kDebugMode) {
      print('$_magenta[DEBUG] $message$_reset');
    }
  }
}
