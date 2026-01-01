import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:getx_architecture/app/core/apis/environment.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _addHeaders(options);
    _logRequest(options);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logError(err);
    handler.next(err);
  }

  void _addHeaders(RequestOptions options) {
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    final token = UserProvider.userCred.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  void _logRequest(RequestOptions options) {
    if (EnvironmentConfig.isProd) return;

    final safeHeaders = Map<String, dynamic>.from(options.headers);
    if (safeHeaders.containsKey('Authorization')) {
      safeHeaders['Authorization'] = 'Bearer ***';
    }

    log(
      [
        '',
        '⬇️⬇️⬇️ REQUEST ⬇️⬇️⬇️',
        '[${options.method}] ${options.uri}',
        'Headers: $safeHeaders',
        'Query: ${options.queryParameters}',
        'Body: ${options.data}',
        '⬆️⬆️⬆️ REQUEST ⬆️⬆️⬆️',
      ].join('\n'),
    );
  }

  void _logResponse(Response response) {
    if (EnvironmentConfig.isProd) return;

    log(
      [
        '',
        '✅✅✅ RESPONSE ✅✅✅',
        '[${response.requestOptions.method}] ${response.requestOptions.uri}',
        'Status: ${response.statusCode}',
        'Data: ${response.data}',
        '✅✅✅ RESPONSE ✅✅✅',
      ].join('\n'),
    );
  }

  void _logError(DioException error) {
    if (EnvironmentConfig.isProd) return;

    log(
      [
        '',
        '⛔⛔⛔ ERROR ⛔⛔⛔',
        '[${error.requestOptions.method}] ${error.requestOptions.uri}',
        'Type: ${error.type}',
        'Status: ${error.response?.statusCode}',
        'Message: ${error.message}',
        'Data: ${error.response?.data}',
        '⛔⛔⛔ ERROR ⛔⛔⛔',
      ].join('\n'),
    );
  }
}
