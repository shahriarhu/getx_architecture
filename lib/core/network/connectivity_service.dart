import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../logging/app_logger.dart';

/// Tracks device reachability so the UI can show an offline state instead of
/// waiting for a request to time out.
///
/// This reports whether a *network interface* exists, not whether the API is
/// reachable — treat it as a hint, never as a substitute for error handling.
class ConnectivityService extends GetxService {
  ConnectivityService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final RxBool isOnline = true.obs;

  Future<ConnectivityService> init() async {
    _apply(await _connectivity.checkConnectivity());
    _subscription = _connectivity.onConnectivityChanged.listen(
      _apply,
      onError:
          (Object error) =>
              AppLogger.w('Connectivity stream error: $error', name: 'NET'),
    );
    return this;
  }

  void _apply(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    if (isOnline.value != online) {
      AppLogger.i(
        'Connectivity: ${online ? 'online' : 'offline'}',
        name: 'NET',
      );
    }
    isOnline.value = online;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
