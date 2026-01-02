import 'package:dio/dio.dart';
import 'package:getx_architecture/app/core/commons/auth/auth_tokens.dart';
import 'package:getx_architecture/app/core/commons/auth/auth_api.dart';

class RequestInterceptor extends Interceptor {
  RequestInterceptor({
    required this.tokenStore,
    required this.authApi,
    required this.mainDio,
    required this.onSessionExpired,
    this.proactiveBuffer = const Duration(seconds: 60),
  });

  final TokenStore tokenStore;
  final AuthApi authApi; // should call refresh via refreshDio internally
  final Dio mainDio;
  final void Function() onSessionExpired;
  final Duration proactiveBuffer;

  Future<AuthTokens>? _refreshFuture; // single-flight lock
  static const _kRetried = '__auth_retried_once__';
  static const _kSkipAuth = '__skip_auth__';

  /// You can mark any request to skip auth:
  /// dio.get('/public', options: Options(extra: { '__skip_auth__': true }))
  bool _shouldSkip(RequestOptions o) {
    final skip = o.extra[_kSkipAuth] == true;
    if (skip) return true;

    // Always skip for login/refresh endpoints
    final p = o.path;
    return p.contains('/auth/refresh') || p.contains('/signin') || p.contains('/login');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      options.headers["Accept"] = "application/json";
      options.headers["Content-Type"] = "application/json";

      if (_shouldSkip(options)) return handler.next(options);

      final tokens = await tokenStore.read();
      if (tokens == null) return handler.next(options);

      // ✅ Proactive refresh if expiring soon
      final finalTokens =
          tokens.isExpiringSoon(proactiveBuffer) ? await _refreshSingleFlight(tokens.refreshToken) : tokens;

      options.headers["Authorization"] = "Bearer ${finalTokens.accessToken}";
      handler.next(options);
    } catch (_) {
      // Don’t block request if anything fails here — reactive 401 may still handle.
      handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final req = err.requestOptions;
    final status = err.response?.statusCode;

    // Only handle 401 and only if not skipped
    if (status != 401 || _shouldSkip(req)) {
      return handler.next(err);
    }

    // ✅ Retry only once guard
    if (req.extra[_kRetried] == true) {
      await tokenStore.clear();
      onSessionExpired();
      return handler.next(err);
    }

    try {
      final tokens = await tokenStore.read();
      if (tokens == null || tokens.refreshToken.isEmpty) {
        await tokenStore.clear();
        onSessionExpired();
        return handler.next(err);
      }

      // ✅ Reactive refresh (single-flight queue)
      final newTokens = await _refreshSingleFlight(tokens.refreshToken);

      // Retry original request once with the new token
      final retry = _clone(req);
      retry.extra[_kRetried] = true;
      retry.headers["Authorization"] = "Bearer ${newTokens.accessToken}";

      final response = await mainDio.fetch(retry);
      return handler.resolve(response);
    } catch (_) {
      // Refresh failed => session expired
      await tokenStore.clear();
      onSessionExpired();
      return handler.next(err);
    }
  }

  Future<AuthTokens> _refreshSingleFlight(String refreshToken) {
    _refreshFuture ??= authApi.refresh(refreshToken).then((t) async {
      await tokenStore.save(t);
      return t;
    }).whenComplete(() {
      _refreshFuture = null; // release lock
    });

    return _refreshFuture!;
  }

  RequestOptions _clone(RequestOptions r) {
    final o = RequestOptions(
      path: r.path,
      method: r.method,
      baseUrl: r.baseUrl,
      queryParameters: Map<String, dynamic>.from(r.queryParameters),
      data: r.data,
      headers: Map<String, dynamic>.from(r.headers),
      extra: Map<String, dynamic>.from(r.extra),
      contentType: r.contentType,
      responseType: r.responseType,
      receiveTimeout: r.receiveTimeout,
      sendTimeout: r.sendTimeout,
      connectTimeout: r.connectTimeout,
      followRedirects: r.followRedirects,
      receiveDataWhenStatusError: r.receiveDataWhenStatusError,
      validateStatus: r.validateStatus,
    );

    // preserve cancellation
    o.cancelToken = r.cancelToken;

    return o;
  }
}
