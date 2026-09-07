import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/session/session_service.dart';
import '../app_routes.dart';

/// Blocks routes that require a signed-in user.
///
/// Guarding at the route level (rather than inside each controller) means a
/// deep link into a protected page is handled the same way as in-app
/// navigation. [SessionService.isAuthenticated] reads an in-memory flag, which
/// is what lets this stay synchronous.
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) =>
      Get.find<SessionService>().isAuthenticated
          ? null
          : const RouteSettings(name: AppRoutes.signIn);
}

/// The inverse: keeps an already-authenticated user out of the sign-in flow.
class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) =>
      Get.find<SessionService>().isAuthenticated
          ? const RouteSettings(name: AppRoutes.home)
          : null;
}
