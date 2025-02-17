import 'package:dio/dio.dart';
import 'package:getx_architecture/app/core/apis/environment.dart';
import 'package:getx_architecture/app/core/apis/request_interceptor.dart';

import 'error_interceptor.dart';

class ApiClient {
  late Dio dio;
  static const environment = Environment.production;

  ApiClient() {
    dio = Dio();

    dio.options = BaseOptions(
      baseUrl: _getBaseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      responseType: ResponseType.json,
      contentType: "application/json",
    );

    // Add custom interceptors
    dio.interceptors.addAll({
      RequestInterceptor(dio, environment: environment),
      ErrorInterceptor(dio),
    });
  }

  String get _getBaseUrl {
    switch (environment) {
      case Environment.local:
        return 'http://localhost:8080'; // Local URL
      case Environment.development:
        return "https://api.hr-infozilion.pitetris.com/v1/mak/"; // Local development URL
      case Environment.production:
      default:
        return "https://api.hr-infozilion.pitetris.com/v1/mak/"; // Production URL
    }
  }
}
