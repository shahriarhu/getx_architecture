import 'dart:async';

import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';

/// Delays an action until the caller stops firing — search fields, autosave.
///
/// Always [dispose] it from `GetxController.onClose`, otherwise a pending
/// timer can fire against a disposed controller.
class Debouncer {
  Debouncer({this.duration = AppConstants.searchDebounce});

  final Duration duration;
  Timer? _timer;

  bool get isPending => _timer?.isActive ?? false;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Runs a pending action immediately (e.g. on submit).
  void flush(VoidCallback action) {
    cancel();
    action();
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() => cancel();
}
