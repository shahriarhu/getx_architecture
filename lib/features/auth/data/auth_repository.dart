import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../../../core/session/auth_tokens.dart';
import '../../../core/session/session_service.dart';
import '../../../core/session/user.dart';

/// All auth-related server calls.
///
/// A repository is the only place a feature talks to the network. Controllers
/// depend on this class, which is what makes them testable with a hand-written
/// fake — no HTTP mocking required.
class AuthRepository {
  const AuthRepository({
    required ApiClient api,
    required SessionService session,
  }) : _api = api,
       _session = session;

  final ApiClient _api;
  final SessionService _session;

  /// Signs in and persists the resulting session.
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiEndpoints.signIn,
      data: {'email': email, 'password': password},
      options: ApiClient.publicRequest,
    );

    final payload =
        ApiResponse.fromJson(
          response.data,
          (data) => data as Map<String, dynamic>,
        ).requireData;

    final user = User.fromJson(
      (payload['user'] as Map<String, dynamic>?) ?? payload,
    );

    await _session.start(tokens: AuthTokens.fromJson(payload), user: user);
    return user;
  }

  /// Signs out. The local session is cleared even when the server call fails —
  /// a user who taps "sign out" must never stay signed in on the device.
  Future<void> signOut() async {
    try {
      await _api.post<void>(ApiEndpoints.signOut);
    } catch (error) {
      AppLogger.w('Remote sign-out failed, clearing locally: $error');
    } finally {
      await _session.signOut();
    }
  }

  /// Refreshes the cached profile.
  Future<User> fetchProfile() async {
    final response = await _api.get<Map<String, dynamic>>(ApiEndpoints.profile);
    final user =
        ApiResponse.fromJson(
          response.data,
          (data) => User.fromJson(data as Map<String, dynamic>),
        ).requireData;

    await _session.updateUser(user);
    return user;
  }
}
