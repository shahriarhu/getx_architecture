import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'environment.dart';

class RedactedLogInterceptor extends Interceptor {
  RedactedLogInterceptor({
    this.logRequestBody = true,
    this.logResponseBody = true,
    this.maxBodyChars = 4000,
  });

  final bool logRequestBody;
  final bool logResponseBody;
  final int maxBodyChars;

  static const _redactHeaders = {
    'authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
    'idempotency-key',
  };

  static const _redactKeys = {
    'password',
    'pass',
    'pin',
    'otp',
    'code',
    'token',
    'access_token',
    'refresh_token',
    'secret',
    'client_secret',
    'card',
    'card_number',
    'cvv',
    'cvc',
    'pan',
    'account',
    'account_number',
    'iban',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (EnvironmentConfig.isProd) return handler.next(options);

    final safeHeaders = _sanitizeHeaders(options.headers);
    final safeQuery = _sanitizeAny(options.queryParameters);

    final sb = StringBuffer()
      ..writeln('[REQ] ${options.method} ${options.uri}')
      ..writeln('headers: $safeHeaders')
      ..writeln('query: $safeQuery');

    if (logRequestBody) {
      final safeBody = _sanitizeAny(options.data);
      sb.writeln('body: ${_truncate(_pretty(safeBody))}');
    }

    log(sb.toString());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (EnvironmentConfig.isProd) return handler.next(response);

    final options = response.requestOptions;
    final sb = StringBuffer()..writeln('[RES] ${response.statusCode} ${options.method} ${options.uri}');

    if (logResponseBody) {
      final safeData = _sanitizeAny(response.data);
      sb.writeln('data: ${_truncate(_pretty(safeData))}');
    }

    log(sb.toString());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!EnvironmentConfig.isProd) {
      final o = err.requestOptions;
      final sb = StringBuffer()
        ..writeln('[ERR] ${o.method} ${o.uri}')
        ..writeln('status: ${err.response?.statusCode} type: ${err.type}')
        ..writeln('message: ${err.message}');

      // Optional: log response body for debugging failures
      if (logResponseBody && err.response?.data != null) {
        final safeErr = _sanitizeAny(err.response?.data);
        sb.writeln('error_data: ${_truncate(_pretty(safeErr))}');
      }

      log(sb.toString());
    }

    handler.next(err);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final out = <String, dynamic>{};
    headers.forEach((k, v) {
      final key = k.toLowerCase();
      out[k] = _redactHeaders.contains(key) ? '***' : v;
    });
    return out;
  }

  dynamic _sanitizeAny(dynamic value) {
    if (value == null) return null;

    if (value is Map) {
      final out = <String, dynamic>{};
      value.forEach((k, v) {
        final key = k.toString().toLowerCase();
        out[k.toString()] = _redactKeys.contains(key) ? '***' : _sanitizeAny(v);
      });
      return out;
    }

    if (value is List) {
      return value.map(_sanitizeAny).toList();
    }

    // If it's already JSON string, try decode & sanitize
    if (value is String) {
      final trimmed = value.trim();
      if ((trimmed.startsWith('{') && trimmed.endsWith('}')) || (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
        try {
          final decoded = jsonDecode(value);
          return _sanitizeAny(decoded);
        } catch (_) {
          // not valid JSON, fallthrough
        }
      }
    }

    return value;
  }

  String _pretty(dynamic data) {
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  String _truncate(String s) {
    if (s.length <= maxBodyChars) return s;
    return '${s.substring(0, maxBodyChars)}…(truncated)';
  }
}
