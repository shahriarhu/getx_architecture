import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';
import 'auth_tokens.dart';

/// Where session credentials are persisted.
///
/// Abstracted so tests can run without platform channels.
abstract interface class TokenStore {
  Future<AuthTokens?> read();

  Future<void> save(AuthTokens tokens);

  Future<void> clear();
}

/// Production implementation — Keychain on iOS, EncryptedSharedPreferences on
/// Android.
class SecureTokenStore implements TokenStore {
  const SecureTokenStore([
    this._storage = const FlutterSecureStorage(
      // Keychain data stays unavailable until the device is first unlocked
      // after boot, so background work cannot read it from a locked device.
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  ]);

  final FlutterSecureStorage _storage;

  @override
  Future<AuthTokens?> read() async {
    final access = await _storage.read(key: StorageKeys.accessToken);
    final refresh = await _storage.read(key: StorageKeys.refreshToken);
    final expiry = await _storage.read(key: StorageKeys.accessExpiry);

    if (access == null || refresh == null || expiry == null) return null;

    final expiryMs = int.tryParse(expiry);
    if (expiryMs == null) return null;

    return AuthTokens(
      accessToken: access,
      refreshToken: refresh,
      accessExpiry: DateTime.fromMillisecondsSinceEpoch(expiryMs),
    );
  }

  @override
  Future<void> save(AuthTokens tokens) async {
    await Future.wait([
      _storage.write(key: StorageKeys.accessToken, value: tokens.accessToken),
      _storage.write(key: StorageKeys.refreshToken, value: tokens.refreshToken),
      _storage.write(
        key: StorageKeys.accessExpiry,
        value: tokens.accessExpiry.millisecondsSinceEpoch.toString(),
      ),
    ]);
  }

  @override
  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: StorageKeys.accessToken),
      _storage.delete(key: StorageKeys.refreshToken),
      _storage.delete(key: StorageKeys.accessExpiry),
    ]);
  }
}

/// Test double.
class InMemoryTokenStore implements TokenStore {
  InMemoryTokenStore([this._tokens]);

  AuthTokens? _tokens;

  @override
  Future<AuthTokens?> read() async => _tokens;

  @override
  Future<void> save(AuthTokens tokens) async => _tokens = tokens;

  @override
  Future<void> clear() async => _tokens = null;
}
