import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

import 'environment.dart';

class RequestInterceptor extends Interceptor {
  final Dio dio;

  RequestInterceptor(this.dio);

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
    options.headers["Accept"] = "application/json";
    options.headers["Content-Type"] = "application/json";

    final token = UserProvider.userCred.token;
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
  }

  void _logRequest(RequestOptions options) {
    if (EnvironmentConfig.environment != Environment.production) {
      final logMessage = '\n⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄REQUEST⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄'
          '\n-----------------------------'
          '\n REQUEST: [${options.method}]'
          '\n-----------------------------'
          '\nENVIRONMENT: ${EnvironmentConfig.environment}'
          '\nPATH: ${options.path}'
          '\nHEADERS: ${options.headers}'
          '\nParams: ${options.queryParameters}'
          '\nBODY: ${options.data}'
          '\n⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃REQUEST⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃';
      log(logMessage);
    }
  }

  void _logResponse(Response response) {
    if (EnvironmentConfig.environment != Environment.production) {
      RequestOptions options = response.requestOptions;

      final logMessage = '\n⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄RESPONSE⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄'
          '\n-----------------------------'
          '\n RESPONSE:  ${response.statusCode}'
          '\n-----------------------------'
          '\nENVIRONMENT: ${EnvironmentConfig.environment}'
          '\nREQUEST: [${options.method}]'
          '\nPATH: ${options.path}'
          '\nHEADERS: ${options.headers}'
          '\nParams: ${options.queryParameters}'
          '\nRESPONSE_STATUS_CODE: ${response.statusCode}'
          '\nRESPONSE_STATUS_MESSAGE: ${response.statusMessage}'
          '\nRESPONSE_DATA: $response'
          '\n⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃RESPONSE⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃';

      log(logMessage);
    }
  }

  void _logError(DioException error) {
    if (EnvironmentConfig.environment != Environment.production) {
      RequestOptions options = error.requestOptions;

      final logMessage = '\n⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄ERROR⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄'
          '\n-----------------------------'
          '\n ERROR:  ${error.response?.statusCode}'
          '\n-----------------------------'
          '\nENVIRONMENT: ${EnvironmentConfig.environment}'
          '\nREQUEST: [${options.method}]'
          '\nPATH: ${options.path}'
          '\nHEADERS: ${options.headers}'
          '\nParams: ${options.queryParameters}'
          '\nRESPONSE_STATUS_CODE: ${error.response?.statusCode}'
          '\nERROR_TYPE: ${error.type}'
          '\nERROR: ${error.error}'
          '\nERROR_MESSAGE: ${error.message}'
          '\nRESPONSE_DATA: ${error.response}'
          '\n⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃ERROR⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃';

      log(logMessage);
    }
  }
}
