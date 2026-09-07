import 'package:dio/dio.dart';

import '../network/api_endpoints.dart';
import 'auth_tokens.dart';

/// Exchanges a refresh token for a new access token.
///
/// Uses a *bare* Dio (no auth interceptor) on purpose — refreshing through the
/// authenticated client would recurse on every 401.
abstract interface class TokenRefresher {
  Future<AuthTokens> refresh(String refreshToken);
}

class ApiTokenRefresher implements TokenRefresher {
  const ApiTokenRefresher(this._dio);

  final Dio _dio;

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
    );

    return AuthTokens.fromJson(
      response.data ?? const {},
      fallbackRefresh: refreshToken,
    );
  }
}
