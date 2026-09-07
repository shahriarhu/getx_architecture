import 'package:flutter_test/flutter_test.dart';
import 'package:getx_architecture/core/session/auth_tokens.dart';

void main() {
  test('isExpiringWithin respects the buffer', () {
    final tokens = AuthTokens(
      accessToken: 'a',
      refreshToken: 'r',
      accessExpiry: DateTime.now().add(const Duration(seconds: 20)),
    );

    expect(tokens.isExpiringWithin(const Duration(seconds: 30)), isTrue);
    expect(tokens.isExpiringWithin(const Duration(seconds: 5)), isFalse);
  });

  test('fromJson derives the expiry from expires_in', () {
    final tokens = AuthTokens.fromJson(const {
      'access_token': 'a',
      'refresh_token': 'r',
      'expires_in': 3600,
    });

    expect(tokens.accessToken, 'a');
    expect(tokens.canRefresh, isTrue);
    expect(
      tokens.accessExpiry.difference(DateTime.now()).inMinutes,
      closeTo(60, 1),
    );
  });

  test('fromJson falls back to the previous refresh token', () {
    final tokens = AuthTokens.fromJson(
      const {'access_token': 'a', 'expires_in': 60},
      fallbackRefresh: 'previous',
    );

    expect(tokens.refreshToken, 'previous');
  });
}
