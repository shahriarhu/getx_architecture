import 'package:dio/dio.dart';

import '../errors/app_exception.dart';

/// The app's only HTTP entry point.
///
/// Its single job is to run requests and translate every transport failure into
/// an [AppException], so nothing above this layer imports Dio.
class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  /// Escape hatch for cases the helpers below do not cover (downloads, custom
  /// `fetch`). Prefer the typed methods.
  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) => _guard(
    () => _dio.get<T>(
      path,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    ),
  );

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) => _guard(
    () => _dio.post<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    ),
  );

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) => _guard(
    () => _dio.put<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    ),
  );

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) => _guard(
    () => _dio.patch<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    ),
  );

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
  }) => _guard(
    () => _dio.delete<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    ),
  );

  /// Marks a request as public so `AuthInterceptor` skips token handling.
  ///
  /// The map is intentionally mutable: interceptors write bookkeeping flags
  /// into `RequestOptions.extra`, and a const map would throw.
  static Options get publicRequest =>
      Options(extra: <String, dynamic>{AuthRequestFlags.skipAuth: true});

  Future<Response<T>> _guard<T>(Future<Response<T>> Function() send) async {
    try {
      return await send();
    } catch (error, stackTrace) {
      throw AppException.from(error, stackTrace);
    }
  }
}

/// Flags read from `RequestOptions.extra` by the interceptors.
abstract final class AuthRequestFlags {
  static const skipAuth = 'skip_auth';
  static const retried = 'auth_retried';
  static const retryCount = 'net_retry_count';
}
