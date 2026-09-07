import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Serves canned HTTP responses so interceptors can be tested without a server.
///
/// `Dio` calls its adapter last, after the whole interceptor chain — swapping
/// it out is therefore the honest way to test auth refresh and retry behaviour.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this._handler);

  /// Responds with a fixed sequence, repeating the final entry once exhausted.
  factory FakeHttpAdapter.sequence(List<({int status, String body})> steps) {
    var index = 0;
    return FakeHttpAdapter((_) async {
      final step = steps[index < steps.length ? index : steps.length - 1];
      index++;
      return jsonResponse(step.status, step.body);
    });
  }

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  /// Every request that reached the wire, in order.
  final List<RequestOptions> requests = [];

  static ResponseBody jsonResponse(int status, String body) =>
      ResponseBody.fromString(
        body,
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    requests.add(options);
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}
