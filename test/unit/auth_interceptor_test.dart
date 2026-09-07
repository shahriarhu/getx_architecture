import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_architecture/core/network/api_client.dart';
import 'package:getx_architecture/core/network/interceptors/auth_interceptor.dart';
import 'package:getx_architecture/core/session/auth_tokens.dart';
import 'package:getx_architecture/core/session/token_refresher.dart';
import 'package:getx_architecture/core/session/token_store.dart';

import '../helpers/fake_http_adapter.dart';
import '../helpers/test_app.dart';

class FakeTokenRefresher implements TokenRefresher {
  FakeTokenRefresher({this.delay = Duration.zero});

  /// Simulates network latency, so single-flight coalescing can be observed.
  final Duration delay;
  int calls = 0;

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    calls++;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    return AuthTokens(
      accessToken: 'fresh-access',
      refreshToken: 'fresh-refresh',
      accessExpiry: DateTime.now().add(const Duration(hours: 1)),
    );
  }
}

AuthTokens tokens({
  String access = 'old-access',
  String refresh = 'old-refresh',
  Duration validFor = const Duration(hours: 1),
}) => AuthTokens(
  accessToken: access,
  refreshToken: refresh,
  accessExpiry: DateTime.now().add(validFor),
);

void main() {
  setUp(setUpTestApp);

  late InMemoryTokenStore store;
  late FakeTokenRefresher refresher;
  late int expiredCalls;

  ({Dio dio, FakeHttpAdapter adapter}) buildClient(FakeHttpAdapter adapter) {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'));
    dio.httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(
        tokenStore: store,
        refresher: refresher,
        retryClient: dio,
        onSessionExpired: () async => expiredCalls++,
      ),
    );
    return (dio: dio, adapter: adapter);
  }

  setUp(() {
    store = InMemoryTokenStore();
    refresher = FakeTokenRefresher();
    expiredCalls = 0;
  });

  test('attaches the access token as a bearer header', () async {
    await store.save(tokens());
    final client = buildClient(
      FakeHttpAdapter.sequence([(status: 200, body: '{}')]),
    );

    await client.dio.get<dynamic>('/profile');

    expect(
      client.adapter.requests.single.headers['Authorization'],
      'Bearer old-access',
    );
  });

  test('sends no token for public endpoints', () async {
    await store.save(tokens());
    final client = buildClient(
      FakeHttpAdapter.sequence([(status: 200, body: '{}')]),
    );

    await client.dio.post<dynamic>('/auth/login', data: const {});

    expect(
      client.adapter.requests.single.headers.containsKey('Authorization'),
      isFalse,
    );
    expect(refresher.calls, 0);
  });

  test('refreshes proactively when the token is about to expire', () async {
    await store.save(tokens(validFor: const Duration(seconds: 5)));
    final client = buildClient(
      FakeHttpAdapter.sequence([(status: 200, body: '{}')]),
    );

    await client.dio.get<dynamic>('/profile');

    expect(refresher.calls, 1);
    expect(
      client.adapter.requests.single.headers['Authorization'],
      'Bearer fresh-access',
    );
    expect((await store.read())?.accessToken, 'fresh-access');
  });

  test('recovers from a 401 by refreshing and replaying the request', () async {
    await store.save(tokens());
    final client = buildClient(
      FakeHttpAdapter.sequence([
        (status: 401, body: '{"message":"expired"}'),
        (status: 200, body: '{"ok":true}'),
      ]),
    );

    final response = await client.dio.get<Map<String, dynamic>>('/profile');

    expect(response.statusCode, 200);
    expect(refresher.calls, 1);
    expect(client.adapter.requests, hasLength(2));
    expect(
      client.adapter.requests.last.headers['Authorization'],
      'Bearer fresh-access',
    );
    expect(expiredCalls, 0);
  });

  test('ends the session when the replay is also rejected', () async {
    await store.save(tokens());
    final client = buildClient(
      FakeHttpAdapter.sequence([(status: 401, body: '{}')]),
    );

    await expectLater(
      client.dio.get<dynamic>('/profile'),
      throwsA(isA<DioException>()),
    );

    expect(refresher.calls, 1, reason: 'refresh must not loop');
    expect(expiredCalls, 1);
    expect(await store.read(), isNull, reason: 'credentials must be cleared');
  });

  test('coalesces concurrent 401s into a single refresh', () async {
    await store.save(tokens());
    // The refresh must still be in flight when the other 401s arrive —
    // otherwise the test would pass even without single-flight.
    refresher = FakeTokenRefresher(delay: const Duration(milliseconds: 50));
    var served = 0;
    final adapter = FakeHttpAdapter((options) async {
      served++;
      // The first three calls are the original requests; everything after is
      // a replay with the refreshed token.
      return FakeHttpAdapter.jsonResponse(served <= 3 ? 401 : 200, '{}');
    });
    final client = buildClient(adapter);

    await Future.wait([
      client.dio.get<dynamic>('/a'),
      client.dio.get<dynamic>('/b'),
      client.dio.get<dynamic>('/c'),
    ]);

    expect(refresher.calls, 1);
    expect(expiredCalls, 0);
  });

  test('signs out immediately when there is no refresh token', () async {
    await store.save(tokens(refresh: ''));
    final client = buildClient(
      FakeHttpAdapter.sequence([(status: 401, body: '{}')]),
    );

    await expectLater(
      client.dio.get<dynamic>('/profile'),
      throwsA(isA<DioException>()),
    );

    expect(refresher.calls, 0);
    expect(expiredCalls, 1);
  });

  test('honours an explicit skip-auth flag', () async {
    await store.save(tokens());
    final client = buildClient(
      FakeHttpAdapter.sequence([(status: 200, body: '{}')]),
    );

    await client.dio.get<dynamic>(
      '/public/config',
      options: ApiClient.publicRequest,
    );

    expect(
      client.adapter.requests.single.headers.containsKey('Authorization'),
      isFalse,
    );
  });
}
