import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import '../core/network/connectivity_service.dart';
import '../core/network/dio_factory.dart';
import '../core/network/interceptors/auth_interceptor.dart';
import '../core/network/interceptors/logging_interceptor.dart';
import '../core/network/interceptors/retry_interceptor.dart';
import '../core/session/session_service.dart';
import '../core/session/token_refresher.dart';
import '../core/session/token_store.dart';
import '../core/storage/key_value_store.dart';
import '../l10n/locale_controller.dart';
import '../l10n/translation_keys.dart';
import '../theme/theme_controller.dart';
import '../widgets/feedback/app_snackbar.dart';
import 'routes/app_routes.dart';

/// Application-wide dependency graph.
///
/// Everything long-lived is registered here, once, and wired by constructor
/// injection — so any class can be built with fakes in a test without touching
/// the service locator. Feature-scoped objects belong in that feature's
/// binding instead.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    final config = AppConfig.instance;

    // Storage
    final store = Get.put<KeyValueStore>(GetStorageAdapter(), permanent: true);
    final tokenStore = Get.put<TokenStore>(
      const SecureTokenStore(),
      permanent: true,
    );

    // Session
    final session = Get.put(
      SessionService(tokenStore: tokenStore, store: store),
      permanent: true,
    );
    session.onSignedOut = () => Get.offAllNamed<void>(AppRoutes.signIn);

    // Networking: one bare client for refresh calls, one interceptor-wired
    // client for everything else. Refreshing through the authenticated client
    // would recurse on 401.
    final refreshClient = DioFactory.create(config);
    final apiDio = DioFactory.create(config);

    apiDio.interceptors.addAll([
      AuthInterceptor(
        tokenStore: tokenStore,
        refresher: ApiTokenRefresher(refreshClient),
        retryClient: apiDio,
        onSessionExpired: () async {
          AppSnackbar.error(LocaleKeys.sessionExpired.tr);
          await session.signOut();
        },
      ),
      RetryInterceptor(dio: apiDio, maxRetries: config.maxApiRetries),
      LoggingInterceptor(),
    ]);

    Get.put<Dio>(refreshClient, tag: 'refresh', permanent: true);
    Get.put(ApiClient(apiDio), permanent: true);

    // App-wide UI state
    Get.put(ThemeController(store), permanent: true);
    Get.put(LocaleController(store), permanent: true);
  }

  /// Services that need `await` before the first frame.
  static Future<void> initAsyncServices() async {
    await Get.putAsync<ConnectivityService>(
      () => ConnectivityService().init(),
      permanent: true,
    );
  }
}
