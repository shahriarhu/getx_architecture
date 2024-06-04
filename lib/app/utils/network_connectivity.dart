import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetworkConnectionCheck {
  static NetworkConnectionCheck? _networkConnectionCheck;

  NetworkConnectionCheck._();

  static NetworkConnectionCheck get instance =>
      _networkConnectionCheck ??= NetworkConnectionCheck._();
  bool hasInternet = true;

  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        return true;
      } else {
        return false;
      }
    } on PlatformException {
      return false;
    } catch (e) {
      return false;
    }
  }

  internetAvailable() async {
    hasInternet = await hasInternetConnection();
    debugPrint("Internet connected :: $hasInternet");
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          // Got a new connectivity status!
          if (result == ConnectivityResult.none) {
            hasInternet = false;
            debugPrint("Internet connected  :: $hasInternet");
          } else {
            hasInternet = true;
            debugPrint("Internet connected  :: $hasInternet");
          }
        } as void Function(List<ConnectivityResult> event)?);

    /// This Delay is require for sync the result value with UI.
    /// In iOS first rebuild the UI after that
    /// the Internet value is process thats why we show the connection Error Dialog
    await Future.delayed(const Duration(seconds: 1));
  }

  List<APIParams> apiStack = [];
}

//check api params for calling the api while internet will be available
class APIParams {
  String url;
  Method method;
  Map<String, dynamic> variables;
  Function(Response<dynamic>) onSuccessFunction;

  APIParams({
    required this.url,
    required this.method,
    required this.variables,
    required this.onSuccessFunction,
  });
}

enum Method {
  POST,
  GET,
  PUT,
  DELETE,
  PATCH,
  DOWNLOAD,
}
