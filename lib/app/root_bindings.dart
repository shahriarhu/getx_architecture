import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_architecture/app/core/apis/environment.dart';
import 'package:getx_architecture/app/routes/app_routes.dart';
import 'package:getx_architecture/app/translations/language_controller.dart';
import 'package:getx_architecture/app/ui/theme/theme_controller.dart';

import 'core/apis/api_client.dart';
import 'core/commons/auth/auth_api.dart';
import 'core/commons/auth/auth_tokens.dart';

class RootBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    EnvironmentConfig.init(Environment.development);

    await GetStorage.init();

    Get.lazyPut<TokenStore>(() => SecureTokenStoreImpl(), fenix: true);

    /// Refresh Dio (no interceptors)
    Get.lazyPut<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: EnvironmentConfig.baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          responseType: ResponseType.json,
          contentType: 'application/json',
        ),
      ),
      tag: 'refreshDio',
      fenix: true,
    );

    /// AuthApi uses refreshDio
    Get.lazyPut<AuthApi>(
      () => AuthApi(Get.find<Dio>(tag: 'refreshDio')),
      fenix: true,
    );

    /// Main Dio
    Get.lazyPut<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: EnvironmentConfig.baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          responseType: ResponseType.json,
          contentType: 'application/json',
        ),
      ),
      tag: 'mainDio',
      fenix: true,
    );

    /// ApiClient wires interceptors into main dio
    Get.lazyPut<ApiClient>(
      () => ApiClient(
        dio: Get.find<Dio>(tag: 'mainDio'),
        tokenStore: Get.find<TokenStore>(),
        authApi: Get.find(),
        mainDio: Get.find<Dio>(tag: 'mainDio'),
        onSessionExpired: () {
          /// GetX global route reset (no context / no key)
          Get.offAllNamed(AppRoutes.signIn);
        },
      ),
      fenix: true,
    );

    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    Get.lazyPut<LanguageController>(() => LanguageController(), fenix: true);
  }
}
