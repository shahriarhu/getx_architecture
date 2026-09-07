import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../l10n/translation_keys.dart';

/// The kinds of failure the UI may need to react to differently.
enum AppErrorType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  conflict,
  rateLimited,
  server,
  cancelled,
  parsing,
  unknown,
}

/// The single error type the rest of the app deals with.
///
/// `ApiClient` converts every `DioException` into an [AppException], so
/// repositories, controllers and views never import Dio just to handle errors.
class AppException implements Exception {
  const AppException({
    required this.type,
    required this.messageKey,
    this.serverMessage,
    this.statusCode,
    this.fieldErrors = const {},
    this.cause,
    this.stackTrace,
  });

  /// Normalizes anything thrown inside the data layer into an [AppException].
  factory AppException.from(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) return error;
    if (error is DioException) return AppException._fromDio(error, stackTrace);
    if (error is FormatException || error is TypeError) {
      return AppException(
        type: AppErrorType.parsing,
        messageKey: LocaleKeys.errorParsing,
        cause: error,
        stackTrace: stackTrace,
      );
    }
    return AppException(
      type: AppErrorType.unknown,
      messageKey: LocaleKeys.errorUnexpected,
      cause: error,
      stackTrace: stackTrace,
    );
  }

  factory AppException._fromDio(DioException error, StackTrace? stackTrace) {
    final response = error.response;

    AppException build(AppErrorType type, String key) => AppException(
      type: type,
      messageKey: key,
      serverMessage: _extractMessage(response?.data),
      statusCode: response?.statusCode,
      fieldErrors: _extractFieldErrors(response?.data),
      cause: error,
      stackTrace: stackTrace ?? error.stackTrace,
    );

    return switch (error.type) {
      DioExceptionType.connectionError => build(
        AppErrorType.network,
        LocaleKeys.errorNoConnection,
      ),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => build(
        AppErrorType.timeout,
        LocaleKeys.errorTimeout,
      ),
      DioExceptionType.cancel => build(
        AppErrorType.cancelled,
        LocaleKeys.errorCancelled,
      ),
      DioExceptionType.badCertificate => build(
        AppErrorType.network,
        LocaleKeys.errorBadCertificate,
      ),
      DioExceptionType.badResponse => _fromStatus(
        response?.statusCode ?? 0,
        build,
      ),
      DioExceptionType.unknown => build(
        AppErrorType.unknown,
        LocaleKeys.errorUnexpected,
      ),
    };
  }

  final AppErrorType type;

  /// Translation key used when the server gives us nothing better.
  final String messageKey;

  /// Human-readable message returned by the API, when present.
  final String? serverMessage;

  final int? statusCode;

  /// Field-level validation errors, keyed by form field name.
  final Map<String, String> fieldErrors;

  final Object? cause;
  final StackTrace? stackTrace;

  /// Message to show the user: the server's wording when it is usable,
  /// otherwise our localized fallback.
  String get message {
    final server = serverMessage?.trim();
    return (server == null || server.isEmpty) ? messageKey.tr : server;
  }

  bool get isAuthError =>
      type == AppErrorType.unauthorized || type == AppErrorType.forbidden;

  /// Retrying only makes sense for transient failures.
  bool get isRetryable =>
      type == AppErrorType.network ||
      type == AppErrorType.timeout ||
      type == AppErrorType.server;

  static AppException _fromStatus(
    int status,
    AppException Function(AppErrorType, String) build,
  ) => switch (status) {
    400 => build(AppErrorType.validation, LocaleKeys.errorBadRequest),
    401 => build(AppErrorType.unauthorized, LocaleKeys.errorUnauthorized),
    403 => build(AppErrorType.forbidden, LocaleKeys.errorForbidden),
    404 => build(AppErrorType.notFound, LocaleKeys.errorNotFound),
    409 => build(AppErrorType.conflict, LocaleKeys.errorConflict),
    422 => build(AppErrorType.validation, LocaleKeys.errorValidation),
    429 => build(AppErrorType.rateLimited, LocaleKeys.errorTooManyRequests),
    >= 500 && < 600 => build(AppErrorType.server, LocaleKeys.errorServer),
    _ => build(AppErrorType.unknown, LocaleKeys.errorUnexpected),
  };

  /// Pulls a message out of the most common API error shapes.
  static String? _extractMessage(Object? data) {
    if (data is String && data.trim().isNotEmpty && data.length < 300) {
      return data;
    }
    if (data is! Map) return null;
    for (final key in const [
      'message',
      'error',
      'detail',
      'error_description',
    ]) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value;
    }
    return null;
  }

  /// Supports both `{"errors": {"email": ["taken"]}}` and
  /// `{"errors": [{"field": "email", "message": "taken"}]}`.
  static Map<String, String> _extractFieldErrors(Object? data) {
    if (data is! Map) return const {};
    final errors = data['errors'];

    if (errors is Map) {
      return {
        for (final entry in errors.entries)
          entry.key.toString(): switch (entry.value) {
            final List<Object?> list when list.isNotEmpty => '${list.first}',
            final Object value => '$value',
            null => '',
          },
      }..removeWhere((_, value) => value.isEmpty);
    }

    if (errors is List) {
      return {
        for (final item in errors)
          if (item is Map && item['field'] != null && item['message'] != null)
            item['field'].toString(): item['message'].toString(),
      };
    }

    return const {};
  }

  @override
  String toString() =>
      'AppException(${type.name}, status: $statusCode, message: '
      '${serverMessage ?? messageKey})';
}
