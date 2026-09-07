import 'dart:async';

import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/constants/app_constants.dart';
import '../../core/session/session_service.dart';

/// Decides where the app opens.
///
/// Restoring the session is asynchronous (secure storage), so it happens here
/// rather than in `main` — that keeps startup non-blocking and gives route
/// guards a settled [SessionService] to read from.
class SplashController extends GetxController {
  SplashController(this._session);

  final SessionService _session;

  @override
  void onReady() {
    super.onReady();
    _resolveStartRoute();
  }

  Future<void> _resolveStartRoute() async {
    final stopwatch = Stopwatch()..start();
    final isSignedIn = await _session.restore();

    // Avoid a jarring flash when restore finishes in a few milliseconds.
    final remaining = AppConstants.splashMinimumDuration - stopwatch.elapsed;
    if (remaining > Duration.zero) await Future<void>.delayed(remaining);

    // Not awaited: `Get.offAllNamed` only completes when the pushed route is
    // popped, which never happens for the app's root screen.
    unawaited(
      Get.offAllNamed<void>(isSignedIn ? AppRoutes.home : AppRoutes.signIn),
    );
  }
}
