import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  final int? milliseconds;
  late VoidCallback action;
  late Timer _timer;

  Debouncer({this.milliseconds = 600}) {
    _timer = Timer(const Duration(milliseconds: 0), () {});
  }

  void run(VoidCallback action) {
    _timer.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}
