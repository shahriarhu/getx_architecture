import 'dart:developer';

import 'package:dio/dio.dart' as d;
import 'package:dio/dio.dart';
import 'package:getx_architecture/app/core/apis/environment.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

class RequestInterceptor extends d.Interceptor {
  final d.Dio dio;
  final Environment environment;

  RequestInterceptor(this.dio, {this.environment = Environment.production});

  @override
  void onRequest(d.RequestOptions options, d.RequestInterceptorHandler handler) async {
    // Add common headers
    _addHeaders(options);

    // Log request
    _logRequest(options);

    return handler.next(options);
  }

  @override
  void onResponse(d.Response response, d.ResponseInterceptorHandler handler) {
    _logResponse(response);
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logError(err);
    return handler.next(err);
  }

  void _addHeaders(RequestOptions options) {
    options.headers["Accept"] = "application/json";
    options.headers["Content-Type"] = "application/json";

    if (UserProvider.userCred.token != null && (UserProvider.userCred.token ?? "").isNotEmpty) {
      options.headers["Authorization"] = "Bearer ${UserProvider.userCred.token}";
    }
  }

  void _logRequest(RequestOptions options) {
    final logMessage = '\n⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄REQUEST⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄'
        '\n-----------------------------'
        '\n REQUEST: [${options.method}]'
        '\n-----------------------------'
        '\nENVIRONMENT: $environment'
        '\nPATH: ${options.path}'
        '\nHEADERS: ${options.headers}'
        '\nParams: ${options.queryParameters}'
        '\nBODY: ${options.data}'
        '\n⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃REQUEST⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃';
    log(logMessage);
  }

  void _logResponse(d.Response response) {
    RequestOptions options = response.requestOptions;

    final logMessage = '\n⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄RESPONSE⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄'
        '\n-----------------------------'
        '\n RESPONSE:  ${response.statusCode}'
        '\n-----------------------------'
        '\nENVIRONMENT: $environment'
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

  void _logError(DioException err) {
    RequestOptions options = err.requestOptions;
    final logMessage = '\n⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄ERROR⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄⌄'
        '\n-----------------------------'
        '\n ERROR:  ${err.response?.statusCode}'
        '\n-----------------------------'
        '\nENVIRONMENT: $environment'
        '\nREQUEST: [${options.method}]'
        '\nPATH: ${options.path}'
        '\nHEADERS: ${options.headers}'
        '\nParams: ${options.queryParameters}'
        '\nRESPONSE_STATUS_CODE: ${err.response?.statusCode}'
        '\nERROR_TYPE: ${err.type}'
        '\nERROR: ${err.error}'
        '\nERROR_MESSAGE: ${err.message}'
        '\nRESPONSE_DATA: ${err.response}'
        '\n⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃ERROR⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃⌃';

    log(logMessage);
  }
}
