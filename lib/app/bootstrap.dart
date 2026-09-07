import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/config/app_config.dart';
import '../core/logging/app_logger.dart';
import '../core/storage/key_value_store.dart';
import '../l10n/translation_keys.dart';
import '../widgets/states/status_views.dart';
import 'app_bindings.dart';

/// Everything that must happen before the first frame.
///
/// Kept out of `main.dart` so tests (and any future flavour entry points such
/// as `main_staging.dart`) can reuse the exact same startup path.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.instance = AppConfig.fromEnvironment();
  AppLogger.enabled = !AppConfig.instance.isProd;

  _installErrorHandlers();

  // Orientation is left free so the responsive layouts in `widgets/layouts/`
  // are actually reachable. To lock a phone-only app to portrait:
  // await SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  // );

  await GetStorageAdapter.init();

  AppBindings().dependencies();
  await AppBindings.initAsyncServices();

  AppLogger.i(
    'Started ${AppConfig.instance.appName} '
    '(${AppConfig.instance.flavor.name}) → ${AppConfig.instance.apiBaseUrl}',
  );
}

/// Routes framework and platform errors into [AppLogger], which is the single
/// place to attach Crashlytics/Sentry later.
void _installErrorHandlers() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    AppLogger.reportError(
      details.exception,
      details.stack,
      reason: details.context?.toDescription(),
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.e('Uncaught async error', error: error, stackTrace: stack);
    return true;
  };

  // A red screen is useful in debug and alarming in production.
  if (kReleaseMode) {
    ErrorWidget.builder =
        (details) => Material(
          child: MessageView(
            icon: Icons.error_outline_rounded,
            title: LocaleKeys.somethingWentWrong.tr,
          ),
        );
  }
}
