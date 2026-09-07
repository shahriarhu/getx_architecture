import 'package:dio/dio.dart';

import '../config/app_config.dart';

/// Builds pre-configured [Dio] instances.
///
/// Kept separate from `ApiClient` because the token-refresh call needs a *bare*
/// Dio: routing it through the authenticated client would recurse.
abstract final class DioFactory {
  static Dio create(AppConfig config) => Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      headers: const {'Accept': 'application/json'},
    ),
  );
}
