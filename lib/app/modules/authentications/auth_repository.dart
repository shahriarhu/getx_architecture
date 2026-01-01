import 'dart:convert';

import 'package:getx_architecture/app/core/commons/models/response_model.dart';
import 'package:getx_architecture/app/modules/authentications/auth_services.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

class AuthRepository {
  final AuthServices _authService;

  AuthRepository(this._authService);

  Future<ResponseModel> signIn(String email, String password) async {
    final data = await _authService.signIn(email, password);

    UserProvider.setUser(jsonEncode(data));

    return ResponseModel();
  }
}
