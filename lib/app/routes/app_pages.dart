import 'package:get/get.dart';

import '../../features/auth/sign_in/sign_in_binding.dart';
import '../../features/auth/sign_in/sign_in_view.dart';
import '../../features/home/home_binding.dart';
import '../../features/home/home_view.dart';
import '../../features/not_found/not_found_view.dart';
import '../../features/settings/settings_binding.dart';
import '../../features/settings/settings_view.dart';
import '../../features/splash/splash_binding.dart';
import '../../features/splash/splash_view.dart';
import 'app_routes.dart';
import 'middlewares/auth_middleware.dart';

/// The route table.
///
/// Every page declares its own binding, so a screen's dependencies are created
/// when it opens and disposed when it closes — no global registry of
/// controllers, and no manual cleanup.
abstract final class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: SplashView.new,
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: SignInView.new,
      binding: SignInBinding(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: AppRoutes.home,
      page: HomeView.new,
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.settings,
      page: SettingsView.new,
      binding: SettingsBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];

  /// Shown for any unregistered route, including bad deep links.
  static final GetPage<dynamic> unknown = GetPage(
    name: AppRoutes.notFound,
    page: NotFoundView.new,
  );
}
