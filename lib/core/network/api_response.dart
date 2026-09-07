import '../../l10n/translation_keys.dart';
import '../errors/app_exception.dart';

/// Normalizes the two response shapes an API usually returns:
///
/// * an envelope — `{"success": true, "data": {...}, "message": "..."}`
/// * a bare payload — `{...}` or `[...]`
///
/// Repositories therefore parse the same way regardless of backend style.
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.fieldErrors = const {},
  });

  factory ApiResponse.fromJson(
    Object? json,
    T Function(Object? payload) parse, {
    int? statusCode,
  }) {
    final isEnvelope =
        json is Map &&
        (json.containsKey('success') || json.containsKey('data'));

    if (!isEnvelope) {
      return ApiResponse<T>(
        success: true,
        data: parse(json),
        statusCode: statusCode,
      );
    }

    final payload = json.containsKey('data') ? json['data'] : json;
    final success = json['success'] as bool? ?? true;

    return ApiResponse<T>(
      success: success,
      data: success && payload != null ? parse(payload) : null,
      message: json['message'] as String?,
      statusCode: statusCode ?? (json['code'] as num?)?.toInt(),
    );
  }

  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, String> fieldErrors;

  /// Returns the payload, or throws a descriptive [AppException] when the
  /// server reported failure inside a 2xx body.
  T get requireData {
    final value = data;
    if (!success || value == null) {
      throw AppException(
        type: AppErrorType.server,
        messageKey: LocaleKeys.errorServer,
        serverMessage: message,
        statusCode: statusCode,
        fieldErrors: fieldErrors,
      );
    }
    return value;
  }
}
