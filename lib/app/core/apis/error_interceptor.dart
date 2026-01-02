import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  static bool _redirecting = false;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = _mapException(err);

    // final status = mapped.response?.statusCode;
    // if (status == 401) {
    //   _handleUnauthorizedOnce();
    // }

    handler.next(mapped);
  }

  DioException _mapException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionError:
        return _build(err, "errorOnConnectivity");

      case DioExceptionType.connectionTimeout:
        return _build(err, "errorOnConnectionTimeout");

      case DioExceptionType.sendTimeout:
        return _build(err, "errorOnSendTimeout");

      case DioExceptionType.receiveTimeout:
        return _build(err, "errorOnReceiveTimeout");

      case DioExceptionType.cancel:
        return _build(err, "dioCancel");

      case DioExceptionType.badCertificate:
        return _build(err, "dioBadCertificate");

      case DioExceptionType.badResponse:
        return _handleBadResponse(err);

      case DioExceptionType.unknown:
      default:
        return _build(err, "dioUnKnown");
    }
  }

  DioException _handleBadResponse(DioException err) {
    final code = err.response?.statusCode ?? 0;

    final messages = {
      400: "dioBadRequest",
      401: "dioUnauthorized",
      403: "dioForbidden",
      404: "dioNotFound",
      409: "dioConflict",
      429: "dioTooManyRequests",
      500: "dioInternalServerError",
      502: "dioBadGateway",
      503: "dioServiceUnavailable",
      504: "dioGatewayTimeout",
    };

    final message = messages[code] ?? "dioInvalidStatusCode";

    return _build(err, message);
  }

  DioException _build(DioException err, String message) {
    return DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: err.error,
      message: message,
    );
  }

  void _handleUnauthorizedOnce() {
    if (_redirecting) return;
    _redirecting = true;

    // UserProvider.clearProfile();

    /// Use microtask to avoid navigation during interceptor stack
    Future.microtask(() {
      // navigatorKey.currentState?.pushNamedAndRemoveUntil(
      //   AppRoutes.signIn,
      //   (route) => false,
      // );
      _redirecting = false;
    });
  }
}
