import 'package:dio/dio.dart';
import 'package:getx_architecture/app/core/apis/error_interceptor.dart';
import 'package:getx_architecture/app/core/apis/redacted_log_interceptor.dart';
import 'package:getx_architecture/app/core/apis/request_interceptor.dart';
import 'package:getx_architecture/app/core/apis/retry_interceptor.dart';
import 'package:getx_architecture/app/core/commons/auth/auth_tokens.dart';
import 'package:getx_architecture/app/core/commons/auth/auth_api.dart';

class ApiClient {
  final Dio dio;

  ApiClient({
    required this.dio,
    required TokenStore tokenStore,
    required AuthApi authApi,
    required Dio mainDio,
    required void Function() onSessionExpired,
  }) {
    dio.interceptors.addAll([
      RedactedLogInterceptor(),
      RequestInterceptor(
        tokenStore: tokenStore,
        authApi: authApi,
        mainDio: mainDio,
        onSessionExpired: onSessionExpired,
      ),
      RetryInterceptor(dio: dio),
      ErrorInterceptor(),
    ]);
  }
}
