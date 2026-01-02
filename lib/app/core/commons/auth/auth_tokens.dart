import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getx_architecture/app/utils/local_storage_key.dart';

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final DateTime accessExpiry;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiry,
  });

  bool isExpiringSoon(Duration buffer) => DateTime.now().isAfter(accessExpiry.subtract(buffer));
}

abstract class TokenStore {
  Future<AuthTokens?> read();

  Future<void> save(AuthTokens t);

  Future<void> clear();
}

class SecureTokenStoreImpl implements TokenStore {
  static const _storage = FlutterSecureStorage();

  @override
  Future<AuthTokens?> read() async {
    final access = await _storage.read(key: LocalStorageKey.accessToken);
    final refresh = await _storage.read(key: LocalStorageKey.refreshToken);
    final expiryRaw = await _storage.read(key: LocalStorageKey.accessExpiry);

    if (access == null || refresh == null || expiryRaw == null) {
      return null;
    }

    return AuthTokens(
      accessToken: access,
      refreshToken: refresh,
      accessExpiry: DateTime.fromMillisecondsSinceEpoch(int.parse(expiryRaw)),
    );
  }

  @override
  Future<void> save(AuthTokens t) async {
    await _storage.write(key: LocalStorageKey.accessToken, value: t.accessToken);
    await _storage.write(key: LocalStorageKey.accessExpiry, value: t.accessExpiry.millisecondsSinceEpoch.toString());
    await _storage.write(key: LocalStorageKey.refreshToken, value: t.refreshToken);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: LocalStorageKey.accessToken);
    await _storage.delete(key: LocalStorageKey.refreshToken);
    await _storage.delete(key: LocalStorageKey.accessExpiry);
  }
}
