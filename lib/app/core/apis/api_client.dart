import 'package:dio/dio.dart';
import 'package:getx_architecture/app/core/apis/environment.dart';
import 'package:getx_architecture/app/core/apis/error_interceptor.dart';
import 'package:getx_architecture/app/core/apis/request_interceptor.dart';

class ApiClient {
  final Dio dio;

  ApiClient._internal(this.dio);

  /// Factory constructor to create a pre-configured Dio instance
  factory ApiClient() {
    final dio = Dio(BaseOptions(
      baseUrl: EnvironmentConfig.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      responseType: ResponseType.json,
      contentType: 'application/json',
    ));

    dio.interceptors.addAll([
      RequestInterceptor(dio),
      ErrorInterceptor(dio),
    ]);

    return ApiClient._internal(dio);
  }
}
