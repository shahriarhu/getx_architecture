import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

/// Thin wrapper over `dart:developer` logging.
///
/// Centralised so that swapping in Crashlytics/Sentry later is a change to
/// [reportError] only, not to every call site.
abstract final class AppLogger {
  /// Silenced in release builds; flip per-environment if you ship a remote sink.
  static bool enabled = !kReleaseMode;

  /// Hook for a crash reporter. Assign during bootstrap, e.g.
  /// `AppLogger.onError = FirebaseCrashlytics.instance.recordError;`
  static void Function(Object error, StackTrace? stackTrace, {String? reason})?
  onError;

  static void d(Object? message, {String name = 'APP'}) =>
      _log(LogLevel.debug, message, name);

  static void i(Object? message, {String name = 'APP'}) =>
      _log(LogLevel.info, message, name);

  static void w(Object? message, {String name = 'APP'}) =>
      _log(LogLevel.warning, message, name);

  static void e(
    Object? message, {
    String name = 'APP',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message, name, error: error, stackTrace: stackTrace);
    if (error != null) {
      reportError(error, stackTrace, reason: message?.toString());
    }
  }

  /// Forwards a non-fatal error to the configured crash reporter.
  static void reportError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
  }) => onError?.call(error, stackTrace, reason: reason);

  static void _log(
    LogLevel level,
    Object? message,
    String name, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!enabled) return;
    developer.log(
      '${_prefix(level)} $message',
      name: name,
      level: _severity(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static String _prefix(LogLevel level) => switch (level) {
    LogLevel.debug => '🐛',
    LogLevel.info => 'ℹ️',
    LogLevel.warning => '⚠️',
    LogLevel.error => '⛔',
  };

  static int _severity(LogLevel level) => switch (level) {
    LogLevel.debug => 500,
    LogLevel.info => 800,
    LogLevel.warning => 900,
    LogLevel.error => 1000,
  };
}
