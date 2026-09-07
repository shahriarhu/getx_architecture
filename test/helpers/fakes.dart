import 'package:getx_architecture/core/errors/app_exception.dart';
import 'package:getx_architecture/core/session/auth_tokens.dart';
import 'package:getx_architecture/core/session/session_service.dart';
import 'package:getx_architecture/core/session/user.dart';
import 'package:getx_architecture/features/auth/data/auth_repository.dart';

/// Hand-written fake — no mocking package needed.
///
/// This is the payoff of constructor injection: a controller can be exercised
/// against a repository that never touches the network.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.session, this.error, this.user = _defaultUser});

  static const _defaultUser = User(
    id: '1',
    name: 'Ada Lovelace',
    email: 'ada@example.com',
  );

  /// When set, [signIn] starts a real session so navigation can be asserted.
  final SessionService? session;

  /// When set, [signIn] throws it instead of succeeding.
  final AppException? error;

  final User user;

  final List<({String email, String password})> signInCalls = [];
  int signOutCalls = 0;

  @override
  Future<User> signIn({required String email, required String password}) async {
    signInCalls.add((email: email, password: password));
    if (error != null) throw error!;

    await session?.start(
      tokens: AuthTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiry: DateTime.now().add(const Duration(hours: 1)),
      ),
      user: user,
    );
    return user;
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    await session?.signOut();
  }

  @override
  Future<User> fetchProfile() async => user;
}
