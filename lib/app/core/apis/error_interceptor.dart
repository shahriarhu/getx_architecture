import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/routes/app_routes.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

class ErrorInterceptor extends Interceptor {
  static bool _redirecting = false;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = _mapException(err);

    final status = mapped.response?.statusCode;
    if (status == 401) {
      _handleUnauthorizedOnce();
    }

    handler.next(mapped);
  }

  DioException _mapException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionError:
        return _build(err, "errorOnConnectivity".tr);

      case DioExceptionType.connectionTimeout:
        return _build(err, "errorOnConnectionTimeout".tr);

      case DioExceptionType.sendTimeout:
        return _build(err, "errorOnSendTimeout".tr);

      case DioExceptionType.receiveTimeout:
        return _build(err, "errorOnReceiveTimeout".tr);

      case DioExceptionType.cancel:
        return _build(err, "dioCancel".tr);

      case DioExceptionType.badCertificate:
        return _build(err, "dioBadCertificate".tr);

      case DioExceptionType.badResponse:
        return _handleBadResponse(err);

      case DioExceptionType.unknown:
      default:
        return _build(err, "dioUnknown".tr);
    }
  }

  DioException _handleBadResponse(DioException err) {
    final code = err.response?.statusCode ?? 0;

    final messages = {
      400: "dioBadRequest".tr,
      401: "dioUnauthorized".tr,
      403: "dioForbidden".tr,
      404: "dioNotFound".tr,
      409: "dioConflict".tr,
      429: "dioTooManyRequests".tr,
      500: "dioInternalServerError".tr,
      502: "dioBadGateway".tr,
      503: "dioServiceUnavailable".tr,
      504: "dioGatewayTimeout".tr,
    };

    final message = messages[code] ?? "dioInvalidStatus".trParams({"statusCode": code.toString()});

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

    UserProvider.removeUser();

    // Use microtask to avoid navigation during interceptor stack
    Future.microtask(() {
      Get.offAllNamed(AppRoutes.signIn);
      _redirecting = false;
    });
  }
}
