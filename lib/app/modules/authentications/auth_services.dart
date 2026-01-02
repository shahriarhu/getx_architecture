import 'dart:developer';

import 'package:getx_architecture/app/core/apis/api_client.dart';
import 'package:getx_architecture/app/core/apis/api_endpoints.dart';
import 'package:getx_architecture/app/core/commons/models/auth_user_model.dart';

class AuthServices {
  final ApiClient _apiClient;

  AuthServices({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<AuthUserModel> signIn({required String mobileNumber, required String password}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.signIn,
        data: {
          'mobile_number': mobileNumber,
          'password': password,
        },
      );

      log('-------------------------------');
      log(response.toString());
      log('-------------------------------');
      log(response.statusCode.toString());
      log('-------------------------------');
      log(response.data.toString());
      log('-------------------------------');
      log(response.statusMessage.toString());
      log('-------------------------------');

      return AuthUserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
