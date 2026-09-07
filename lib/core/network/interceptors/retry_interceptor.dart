import 'dart:math';

import 'package:dio/dio.dart';

import '../../logging/app_logger.dart';
import '../api_client.dart';

/// Retries transient failures with exponential backoff and jitter.
///
/// Only idempotent verbs are retried automatically; a non-idempotent request
/// must opt in by sending an `Idempotency-Key`, so a payment can never be
/// submitted twice by a retry.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 2,
    this.baseDelay = const Duration(milliseconds: 300),
  }) : _dio = dio;

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;

  static const _idempotentMethods = {'GET', 'HEAD', 'OPTIONS'};
  static const _retryableStatuses = {408, 425, 429, 500, 502, 503, 504};

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final attempt = (request.extra[AuthRequestFlags.retryCount] as int?) ?? 0;

    if (attempt >= maxRetries || !_isRetryable(err)) return handler.next(err);

    request.extra[AuthRequestFlags.retryCount] = attempt + 1;
    await Future<void>.delayed(_backoff(attempt));

    AppLogger.d(
      'Retry ${attempt + 1}/$maxRetries → ${request.method} ${request.path}',
      name: 'HTTP',
    );

    try {
      handler.resolve(await _dio.fetch<dynamic>(request));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _isRetryable(DioException err) {
    if (err.type == DioExceptionType.cancel) return false;

    final request = err.requestOptions;
    final safeToRepeat =
        _idempotentMethods.contains(request.method.toUpperCase()) ||
        request.headers.containsKey('Idempotency-Key');
    if (!safeToRepeat) return false;

    final isTransportError = switch (err.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => true,
      _ => false,
    };

    return isTransportError ||
        _retryableStatuses.contains(err.response?.statusCode);
  }

  Duration _backoff(int attempt) => Duration(
    milliseconds:
        (baseDelay.inMilliseconds * pow(2, attempt)).toInt() +
        Random().nextInt(120),
  );
}
