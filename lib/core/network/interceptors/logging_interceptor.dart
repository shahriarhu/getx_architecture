import 'dart:convert';

import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../../logging/app_logger.dart';

/// Logs traffic with credentials and PII redacted.
///
/// Plain request logging is a data-leak waiting to happen — tokens, passwords
/// and card numbers end up in device logs and crash reports. This interceptor
/// masks known-sensitive keys and is disabled entirely in release builds.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.maxBodyChars = 2000});

  final int maxBodyChars;

  static const _sensitiveHeaders = {
    'authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
    'proxy-authorization',
  };

  static const _sensitiveKeys = {
    'password',
    'new_password',
    'old_password',
    'confirm_password',
    'pin',
    'otp',
    'code',
    'token',
    'access_token',
    'refresh_token',
    'id_token',
    'secret',
    'client_secret',
    'api_key',
    'card',
    'card_number',
    'cvv',
    'cvc',
    'pan',
    'account_number',
    'iban',
    'ssn',
  };

  bool get _enabled => AppConfig.instance.enableNetworkLogs;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_enabled) return handler.next(options);

    AppLogger.d(
      '→ ${options.method} ${options.uri}\n'
      'headers: ${_maskHeaders(options.headers)}\n'
      'body: ${_format(options.data)}',
      name: 'HTTP',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (!_enabled) return handler.next(response);

    final request = response.requestOptions;
    AppLogger.d(
      '← ${response.statusCode} ${request.method} ${request.uri}\n'
      'body: ${_format(response.data)}',
      name: 'HTTP',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!_enabled) return handler.next(err);

    final request = err.requestOptions;
    AppLogger.w(
      '✖ ${err.response?.statusCode ?? err.type.name} '
      '${request.method} ${request.uri}\n'
      'message: ${err.message}\n'
      'body: ${_format(err.response?.data)}',
      name: 'HTTP',
    );
    handler.next(err);
  }

  Map<String, dynamic> _maskHeaders(Map<String, dynamic> headers) => {
    for (final entry in headers.entries)
      entry.key:
          _sensitiveHeaders.contains(entry.key.toLowerCase())
              ? '***'
              : entry.value,
  };

  Object? _mask(Object? value) {
    if (value is Map) {
      return {
        for (final entry in value.entries)
          entry.key.toString():
              _sensitiveKeys.contains(entry.key.toString().toLowerCase())
                  ? '***'
                  : _mask(entry.value),
      };
    }
    if (value is Iterable) return value.map(_mask).toList();
    if (value is FormData) {
      return {
        for (final field in value.fields)
          field.key:
              _sensitiveKeys.contains(field.key.toLowerCase())
                  ? '***'
                  : field.value,
        'files': value.files.map((f) => f.key).toList(),
      };
    }
    if (value is String) {
      final trimmed = value.trim();
      final looksLikeJson =
          (trimmed.startsWith('{') && trimmed.endsWith('}')) ||
          (trimmed.startsWith('[') && trimmed.endsWith(']'));
      if (looksLikeJson) {
        try {
          return _mask(jsonDecode(trimmed) as Object?);
        } on FormatException {
          return value;
        }
      }
    }
    return value;
  }

  String _format(Object? data) {
    if (data == null) return 'null';
    final masked = _mask(data);
    String text;
    try {
      text = const JsonEncoder.withIndent('  ').convert(masked);
    } on JsonUnsupportedObjectError {
      text = masked.toString();
    }
    return text.length <= maxBodyChars
        ? text
        : '${text.substring(0, maxBodyChars)}… (truncated)';
  }
}
