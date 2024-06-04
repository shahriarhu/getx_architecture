import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/routes/app_routes.dart';
import 'package:getx_architecture/app/utils/dialogue_utils.dart';
import 'package:getx_architecture/app/utils/network_connectivity.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

class ApiClient {
  late Dio dio;
  final Connectivity _connectivity = Connectivity();

  ApiClient() {
    dio = Dio();

    dio.options = BaseOptions(
      baseUrl: 'https://my-api/',
      connectTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 40),
      responseType: ResponseType.json,
      contentType: 'application/json',
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';
          handler.next(options);
          if (UserProvider.userCred.token != null) {
            options.headers["Authorization"] = "Bearer ${UserProvider.userCred.token}";
          }
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (DioException error, handler) {
          log('==============================');
          log(error.response.toString());
          log('==============================');
          log(error.message.toString());
          log('==============================');
          log(error.error.toString());
          log('==============================');

          if (error.response?.statusCode == 401) {
            UserProvider.removeUser();
            if (error.response?.data['key'] != 'mobile_not_verified' && error.response?.data['key'] != 'login_failed') {
              Get.offAllNamed(Routes.signIn);
              return;
            }
          }

          if (error.type == DioExceptionType.connectionTimeout) {
            _handleTimeoutError(error);
          } else if (error.type == DioExceptionType.connectionError) {
            _handleConnectivityError(error);
          } else {
            throw error;
          }
        },
      ),
    );
  }


  Future<void> _handleNoInternet(APIParams apiParams) async {
    NetworkConnectionCheck.instance.apiStack.add(apiParams);

    if (DialogUtils.isPresentedDialog == false) {
      DialogUtils.isPresentedDialog = true;
      WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          DialogUtils.showConnectionLostAlertDialogue(
            onTap: () {
              if (NetworkConnectionCheck.instance.hasInternet == true) {
                Get.back();
                DialogUtils.isPresentedDialog = false;
                for (var element in NetworkConnectionCheck.instance.apiStack) {
                  // post, get, put api call as well
                }
                NetworkConnectionCheck.instance.apiStack = [];
              } else {
                Get.back();
                DialogUtils.isPresentedDialog = false;
              }
            },
          );
        },
      );
    }
  }



  Future<void> _handleConnectivityError(DioException error) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw DioException(
        error: error.response,
        message: 'No internet connection',
        requestOptions: error.requestOptions,
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<void> _handleTimeoutError(DioException error) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw DioException(
        error: error.response,
        message: 'No internet connection',
        requestOptions: error.requestOptions,
        type: DioExceptionType.connectionError,
      );
    } else {
      throw DioException(
        error: error.response,
        message: 'Connection timeout',
        requestOptions: error.requestOptions,
        type: DioExceptionType.connectionTimeout,
      );
    }
  }
}
