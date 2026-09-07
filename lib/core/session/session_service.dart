import 'package:get/get.dart';

import '../constants/storage_keys.dart';
import '../logging/app_logger.dart';
import '../storage/key_value_store.dart';
import 'auth_tokens.dart';
import 'token_store.dart';
import 'user.dart';

/// Owns "who is signed in" for the whole app.
///
/// Tokens live in secure storage; the (non-sensitive) profile is cached in
/// local storage so the UI can render immediately on a cold start. The
/// in-memory [isAuthenticated] flag is what route guards read, because
/// middleware must decide synchronously.
class SessionService extends GetxService {
  SessionService({required TokenStore tokenStore, required KeyValueStore store})
    : _tokenStore = tokenStore,
      _store = store;

  final TokenStore _tokenStore;
  final KeyValueStore _store;

  final Rxn<User> user = Rxn<User>();
  final RxBool _authenticated = false.obs;

  /// Invoked after the session ends. The app layer assigns navigation here so
  /// this service stays independent of the router.
  void Function()? onSignedOut;

  bool get isAuthenticated => _authenticated.value;

  /// Reactive form of [isAuthenticated], for `Obx` widgets.
  RxBool get authenticated => _authenticated;

  /// Restores a previous session from disk. Call once, from the splash screen.
  Future<bool> restore() async {
    try {
      final tokens = await _tokenStore.read();
      _authenticated.value = tokens?.canRefresh ?? false;

      if (_authenticated.value) user.value = _readCachedUser();
      return _authenticated.value;
    } catch (error, stackTrace) {
      AppLogger.e(
        'Session restore failed',
        name: 'SESSION',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Reads the cached profile defensively: a stale or malformed cache is worth
  /// a missing name, never a forced sign-out.
  User? _readCachedUser() {
    try {
      final cached = _store.read<Object>(StorageKeys.cachedUser);
      if (cached is! Map) return null;
      return User.fromJson(Map<String, dynamic>.from(cached));
    } catch (error) {
      AppLogger.w('Discarding unreadable cached user: $error', name: 'SESSION');
      return null;
    }
  }

  /// Persists a freshly authenticated session.
  Future<void> start({required AuthTokens tokens, required User user}) async {
    await _tokenStore.save(tokens);
    await _store.write(StorageKeys.cachedUser, user.toJson());
    this.user.value = user;
    _authenticated.value = true;
  }

  /// Updates the cached profile without touching credentials.
  Future<void> updateUser(User user) async {
    await _store.write(StorageKeys.cachedUser, user.toJson());
    this.user.value = user;
  }

  /// Clears everything session-related and notifies [onSignedOut].
  Future<void> signOut() async {
    await _tokenStore.clear();
    await _store.remove(StorageKeys.cachedUser);
    user.value = null;
    _authenticated.value = false;
    onSignedOut?.call();
  }
}
