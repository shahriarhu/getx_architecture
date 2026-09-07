import 'package:flutter_test/flutter_test.dart';
import 'package:getx_architecture/core/constants/storage_keys.dart';
import 'package:getx_architecture/core/session/auth_tokens.dart';
import 'package:getx_architecture/core/session/session_service.dart';
import 'package:getx_architecture/core/session/token_store.dart';
import 'package:getx_architecture/core/session/user.dart';
import 'package:getx_architecture/core/storage/key_value_store.dart';

import '../helpers/test_app.dart';

AuthTokens _tokens({String refresh = 'refresh-token'}) => AuthTokens(
  accessToken: 'access-token',
  refreshToken: refresh,
  accessExpiry: DateTime.now().add(const Duration(hours: 1)),
);

const _user = User(id: '1', name: 'Ada Lovelace', email: 'ada@example.com');

void main() {
  setUp(setUpTestApp);

  late InMemoryTokenStore tokenStore;
  late InMemoryKeyValueStore store;
  late SessionService session;

  setUp(() {
    tokenStore = InMemoryTokenStore();
    store = InMemoryKeyValueStore();
    session = SessionService(tokenStore: tokenStore, store: store);
  });

  test('starts unauthenticated', () {
    expect(session.isAuthenticated, isFalse);
    expect(session.user.value, isNull);
  });

  test('start() persists tokens and the profile', () async {
    await session.start(tokens: _tokens(), user: _user);

    expect(session.isAuthenticated, isTrue);
    expect(session.user.value, _user);
    expect(await tokenStore.read(), isNotNull);
    expect(store.read<Map<String, dynamic>>(StorageKeys.cachedUser), isNotNull);
  });

  test('restore() rehydrates a saved session', () async {
    await tokenStore.save(_tokens());
    await store.write(StorageKeys.cachedUser, _user.toJson());

    expect(await session.restore(), isTrue);
    expect(session.user.value, _user);
  });

  test('restore() reports false when the refresh token is missing', () async {
    await tokenStore.save(_tokens(refresh: ''));

    expect(await session.restore(), isFalse);
    expect(session.isAuthenticated, isFalse);
  });

  test('signOut() clears credentials, profile and notifies', () async {
    var notified = false;
    session.onSignedOut = () => notified = true;
    await session.start(tokens: _tokens(), user: _user);

    await session.signOut();

    expect(session.isAuthenticated, isFalse);
    expect(session.user.value, isNull);
    expect(await tokenStore.read(), isNull);
    expect(store.contains(StorageKeys.cachedUser), isFalse);
    expect(notified, isTrue);
  });

  test('updateUser() refreshes the profile without touching tokens', () async {
    await session.start(tokens: _tokens(), user: _user);

    await session.updateUser(_user.copyWith(name: 'Ada B. Lovelace'));

    expect(session.user.value?.name, 'Ada B. Lovelace');
    expect(await tokenStore.read(), isNotNull);
  });
}
