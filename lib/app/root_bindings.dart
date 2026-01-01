import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_architecture/app/core/apis/api_client.dart';
import 'package:getx_architecture/app/core/apis/environment.dart';
import 'package:getx_architecture/app/core/apis/error_interceptor.dart';
import 'package:getx_architecture/app/core/apis/request_interceptor.dart';
import 'package:getx_architecture/app/translations/language_controller.dart';
import 'package:getx_architecture/app/ui/theme/theme_controller.dart';

class RootBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    EnvironmentConfig.init(Environment.development);

    await GetStorage.init();

    final dio = Dio(
      BaseOptions(
        baseUrl: EnvironmentConfig.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.addAll([RequestInterceptor(), ErrorInterceptor()]);

    Get.put<Dio>(dio, permanent: true);
    Get.put<ApiClient>(ApiClient(dio: dio), permanent: true);

    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    Get.lazyPut<LanguageController>(() => LanguageController(), fenix: true);
  }
}
