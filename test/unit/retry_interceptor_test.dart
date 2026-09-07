import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_architecture/core/network/interceptors/retry_interceptor.dart';

import '../helpers/fake_http_adapter.dart';
import '../helpers/test_app.dart';

void main() {
  setUp(setUpTestApp);

  ({Dio dio, FakeHttpAdapter adapter}) buildClient(
    FakeHttpAdapter adapter, {
    int maxRetries = 2,
  }) {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'));
    dio.httpClientAdapter = adapter;
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        maxRetries: maxRetries,
        baseDelay: const Duration(milliseconds: 1),
      ),
    );
    return (dio: dio, adapter: adapter);
  }

  test('retries a failed GET until it succeeds', () async {
    final client = buildClient(
      FakeHttpAdapter.sequence([
        (status: 503, body: '{}'),
        (status: 200, body: '{"ok":true}'),
      ]),
    );

    final response = await client.dio.get<Map<String, dynamic>>('/articles');

    expect(response.statusCode, 200);
    expect(client.adapter.requests, hasLength(2));
  });

  test('gives up after maxRetries attempts', () async {
    final client = buildClient(
      FakeHttpAdapter.sequence([(status: 503, body: '{}')]),
    );

    await expectLater(
      client.dio.get<dynamic>('/articles'),
      throwsA(isA<DioException>()),
    );

    expect(client.adapter.requests, hasLength(3), reason: '1 try + 2 retries');
  });

  test('never retries a plain POST', () async {
    final client = buildClient(
      FakeHttpAdapter.sequence([(status: 503, body: '{}')]),
    );

    await expectLater(
      client.dio.post<dynamic>('/payments', data: const {'amount': 100}),
      throwsA(isA<DioException>()),
    );

    expect(
      client.adapter.requests,
      hasLength(1),
      reason: 'a non-idempotent request must not be replayed automatically',
    );
  });

  test('retries a POST that carries an idempotency key', () async {
    final client = buildClient(
      FakeHttpAdapter.sequence([
        (status: 503, body: '{}'),
        (status: 200, body: '{"ok":true}'),
      ]),
    );

    final response = await client.dio.post<Map<String, dynamic>>(
      '/payments',
      data: const {'amount': 100},
      options: Options(headers: const {'Idempotency-Key': 'abc-123'}),
    );

    expect(response.statusCode, 200);
    expect(client.adapter.requests, hasLength(2));
  });

  test('does not retry client errors', () async {
    final client = buildClient(
      FakeHttpAdapter.sequence([(status: 400, body: '{}')]),
    );

    await expectLater(
      client.dio.get<dynamic>('/articles'),
      throwsA(isA<DioException>()),
    );

    expect(client.adapter.requests, hasLength(1));
  });

  test('does not retry a cancelled request', () async {
    final token = CancelToken();
    final client = buildClient(
      FakeHttpAdapter((_) async {
        token.cancel();
        return FakeHttpAdapter.jsonResponse(503, '{}');
      }),
    );

    await expectLater(
      client.dio.get<dynamic>('/articles', cancelToken: token),
      throwsA(isA<DioException>()),
    );

    expect(client.adapter.requests, hasLength(1));
  });
}
