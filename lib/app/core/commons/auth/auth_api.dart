import 'package:dio/dio.dart';
import 'package:getx_architecture/app/core/apis/api_endpoints.dart';
import 'package:getx_architecture/app/core/commons/auth/auth_tokens.dart';

class AuthApi {
  final Dio refreshDio;

  AuthApi(this.refreshDio);

  Future<AuthTokens> refresh(String refreshToken) async {
    final res = await refreshDio.post(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
      options: Options(headers: {'Authorization': null}),
    );

    final data = res.data as Map<String, dynamic>;
    return AuthTokens(
      accessToken: data['access_token'] as String,
      refreshToken: (data['refresh_token'] as String?) ?? refreshToken,
      accessExpiry: DateTime.now().add(Duration(seconds: (data['expires_in'] as num).toInt())),
    );
  }
}
