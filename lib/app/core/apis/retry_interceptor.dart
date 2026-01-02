import 'dart:math';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 2,
    this.baseDelayMs = 300,
  });

  final Dio dio;
  final int maxRetries;
  final int baseDelayMs;

  static const _kRetryCount = '__net_retry_count__';

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final req = err.requestOptions;

    if (err.type == DioExceptionType.cancel) return handler.next(err);
    if (!_isRetryable(err, req)) return handler.next(err);

    final count = (req.extra[_kRetryCount] as int?) ?? 0;
    if (count >= maxRetries) return handler.next(err);

    req.extra[_kRetryCount] = count + 1;

    await Future.delayed(_delay(count));

    try {
      final res = await dio.fetch(req);
      return handler.resolve(res);
    } catch (_) {
      return handler.next(err);
    }
  }

  bool _isRetryable(DioException err, RequestOptions req) {
    final method = req.method.toUpperCase();
    final idempotent = method == 'GET' || method == 'HEAD' || method == 'OPTIONS';
    final hasIdempotencyKey = req.headers.containsKey('Idempotency-Key');

    // fintech safety: POST retry only with idempotency key
    if (!idempotent && !hasIdempotencyKey) return false;

    final status = err.response?.statusCode;
    final net = err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;

    final server = status == 502 || status == 503 || status == 504;

    return net || server;
  }

  Duration _delay(int retryCount) {
    final ms = (baseDelayMs * pow(2, retryCount)).toInt();
    final jitter = Random().nextInt(100);
    return Duration(milliseconds: ms + jitter);
  }
}
