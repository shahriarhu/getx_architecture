import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/routes/app_routes.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

class ErrorInterceptor extends Interceptor {
  final Dio dio;

  ErrorInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final dioException = _mapException(err);

    /// Handle special cases
    if (dioException.response?.statusCode == 401) {
      _handleAuthorizationError(dioException);
    }

    if (dioException.type == DioExceptionType.connectionError ||
        dioException.type == DioExceptionType.connectionTimeout) {
      _handleConnectivityError(dioException);
    }

    handler.next(dioException);
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
      error: err,
      response: err.response,
      message: message,
      requestOptions: err.requestOptions,
      type: err.type,
    );
  }

  void _handleAuthorizationError(DioException err) {
    UserProvider.removeUser();
    Get.offAllNamed(AppRoutes.signIn);
  }

  void _handleConnectivityError(DioException err) async {
    /// navigate to a connectivity error screen if needed
    // ArgumentModel<DioException> argumentModel = ArgumentModel(
    //   prevRoute: Get.currentRoute,
    //   data: err,
    // );
    // Get.offNamed(Routes.CONNECTIVITY_ERROR, arguments: err);
  }
}
