import 'package:dio/dio.dart';

import '../../logging/app_logger.dart';
import '../../session/auth_tokens.dart';
import '../../session/token_refresher.dart';
import '../../session/token_store.dart';
import '../api_client.dart';
import '../api_endpoints.dart';

/// Attaches the access token, refreshes it when it is about to expire, and
/// recovers from a 401 exactly once before ending the session.
///
/// Concurrent requests share a single refresh call (single-flight), so a burst
/// of 401s cannot trigger a burst of refreshes.
///
/// `retryClient` must be the same `Dio` this interceptor is installed on: the
/// replayed request goes back through the chain, which is what makes the
/// "second 401 ends the session" rule fire exactly once.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStore tokenStore,
    required TokenRefresher refresher,
    required Dio retryClient,
    required Future<void> Function() onSessionExpired,
    Duration expiryBuffer = const Duration(seconds: 30),
  }) : _tokenStore = tokenStore,
       _refresher = refresher,
       _retryClient = retryClient,
       _onSessionExpired = onSessionExpired,
       _expiryBuffer = expiryBuffer;

  final TokenStore _tokenStore;
  final TokenRefresher _refresher;
  final Dio _retryClient;
  final Future<void> Function() _onSessionExpired;
  final Duration _expiryBuffer;

  Future<AuthTokens>? _inFlightRefresh;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_skipsAuth(options)) return handler.next(options);

    try {
      final tokens = await _tokenStore.read();
      if (tokens == null || !tokens.isValid) return handler.next(options);

      final fresh =
          tokens.isExpiringWithin(_expiryBuffer) && tokens.canRefresh
              ? await _refreshOnce(tokens.refreshToken)
              : tokens;

      options.headers['Authorization'] = 'Bearer ${fresh.accessToken}';
      handler.next(options);
    } catch (error) {
      // Never block the request here: the reactive 401 path below is the
      // authoritative recovery, and some endpoints tolerate anonymous calls.
      AppLogger.w('Proactive token refresh failed: $error', name: 'AUTH');
      handler.next(options);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;

    if (err.response?.statusCode != 401 || _skipsAuth(request)) {
      return handler.next(err);
    }

    // A second 401 after a successful refresh means the session is genuinely
    // dead — do not loop.
    if (request.extra[AuthRequestFlags.retried] == true) {
      await _endSession();
      return handler.next(err);
    }

    try {
      final tokens = await _tokenStore.read();
      if (tokens == null || !tokens.canRefresh) {
        await _endSession();
        return handler.next(err);
      }

      final fresh = await _refreshOnce(tokens.refreshToken);
      final retry = _copyWithToken(request, fresh.accessToken);

      handler.resolve(await _retryClient.fetch<dynamic>(retry));
    } on DioException catch (retryError) {
      // The replay runs back through this same interceptor, so the branch
      // above already ended the session if it came back 401. Ending it here
      // too would sign the user out — and show the message — twice.
      handler.next(retryError);
    } catch (error, stackTrace) {
      AppLogger.e(
        'Token refresh failed',
        name: 'AUTH',
        error: error,
        stackTrace: stackTrace,
      );
      await _endSession();
      handler.next(err);
    }
  }

  bool _skipsAuth(RequestOptions options) =>
      options.extra[AuthRequestFlags.skipAuth] == true ||
      ApiEndpoints.public.any(options.path.contains);

  /// Coalesces concurrent refreshes into one network call.
  Future<AuthTokens> _refreshOnce(String refreshToken) {
    return _inFlightRefresh ??= _refresher
        .refresh(refreshToken)
        .then((tokens) async {
          await _tokenStore.save(tokens);
          return tokens;
        })
        .whenComplete(() => _inFlightRefresh = null);
  }

  Future<void> _endSession() async {
    await _tokenStore.clear();
    await _onSessionExpired();
  }

  RequestOptions _copyWithToken(RequestOptions source, String accessToken) {
    return source.copyWith(
      headers: {...source.headers, 'Authorization': 'Bearer $accessToken'},
      extra: {...source.extra, AuthRequestFlags.retried: true},
    );
  }
}
