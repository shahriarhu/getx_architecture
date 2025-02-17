import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/routes/app_routes.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

class ErrorInterceptor extends Interceptor {
  final Dio dio;
  ErrorInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    DioException dioException;

    switch (err.type) {
      case DioExceptionType.connectionError:
        dioException = DioException(
          error: err,
          response: err.response,
          message: "errorOnConnectivity".tr,
          requestOptions: err.requestOptions,
          type: DioExceptionType.connectionError,
        );
        _handleConnectivityError(dioException);
        break;

      case DioExceptionType.connectionTimeout:
        dioException = DioException(
          error: err,
          response: err.response,
          message: "errorOnConnectionTimeout".tr,
          requestOptions: err.requestOptions,
          type: DioExceptionType.connectionTimeout,
        );
        _handleConnectivityError(dioException);
        break;

      case DioExceptionType.sendTimeout:
        dioException = DioException(
          error: err,
          response: err.response,
          message: "errorOnSendTimeout".tr,
          requestOptions: err.requestOptions,
          type: DioExceptionType.sendTimeout,
        );
        break;

      case DioExceptionType.receiveTimeout:
        dioException = DioException(
          error: err,
          response: err.response,
          message: "errorOnReceiveTimeout".tr,
          requestOptions: err.requestOptions,
          type: DioExceptionType.receiveTimeout,
        );
        break;

      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            dioException = DioException(
              error: err,
              response: err.response,
              message: "dioBadRequest".tr,
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
            );
            break;

          case 401:
            dioException = DioException(
              error: err,
              response: err.response,
              message: "dioUnauthorized".tr,
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
            );
            _handleAuthorizationError(dioException);
            break;

          case 403:
            dioException = DioException(
              error: err,
              response: err.response,
              message: "dioForbidden".tr,
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
            );
            break;

          case 404:
            dioException = DioException(
              error: err,
              response: err.response,
              message: "dioNotFound".tr,
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
            );
            break;

          case 409:
            dioException = DioException(
              error: err,
              response: err.response,
              message: "dioConflict".tr,
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
            );
            break;

          case 429:
            dioException = DioException(
              error: err,
              message: "dioTooManyRequests".tr,
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
            );
            break;

          case 500:
            dioException = DioException(
              error: err,
              response: err.response,
              message: "dioInternalServerError".tr,
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
            );
            break;

          case 502:
            dioException = DioException(
              error: err,
              response: err.response,
              message: "dioBadGateway".tr,
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
            );
            break;

          case 503:
            dioException = DioException(
              error: err,
              response: err.response,
              message: "dioServiceUnavailable".tr,
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
            );
            break;

          case 504:
            dioException = DioException(
              error: err,
              response: err.response,
              message: "dioGatewayTimeout".tr,
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
            );
            break;

          default:
            dioException = DioException(
              error: err,
              response: err.response,
              message: "dioInvalidStatus".trParams({"statusCode": (err.response?.statusCode ?? 000).toString()}),
              requestOptions: err.requestOptions,
              type: DioExceptionType.badResponse,
            );
            break;
        }
        break;

      case DioExceptionType.cancel:
        dioException = DioException(
          error: err,
          response: err.response,
          message: "dioCancel".tr,
          requestOptions: err.requestOptions,
          type: DioExceptionType.cancel,
        );
        break;

      case DioExceptionType.badCertificate:
        dioException = DioException(
          error: err,
          response: err.response,
          message: "dioBadCertificate".tr,
          requestOptions: err.requestOptions,
          type: DioExceptionType.badCertificate,
        );
        break;

      case DioExceptionType.unknown:
      default:
        dioException = DioException(
          error: err,
          response: err.response,
          message: "dioUnknown".tr,
          requestOptions: err.requestOptions,
          type: DioExceptionType.unknown,
        );
        break;
    }

    return handler.next(dioException);
  }

  _handleAuthorizationError(DioException err) {
    UserProvider.removeUser();
    Get.offAllNamed(AppRoutes.signIn);
    return;
  }

  _handleConnectivityError(DioException err) async {
    // ArgumentModel<DioException> argumentModel = ArgumentModel(
    //   prevRoute: Get.currentRoute,
    //   data: err,
    // );
    // Get.offNamed(Routes.CONNECTIVITY_ERROR, arguments: argumentModel);
  }
}
