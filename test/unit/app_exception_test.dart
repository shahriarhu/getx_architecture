import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_architecture/core/errors/app_exception.dart';
import 'package:getx_architecture/l10n/translation_keys.dart';

import '../helpers/test_app.dart';

DioException _badResponse(int status, {Object? body}) {
  final options = RequestOptions(path: '/test');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<Object?>(
      requestOptions: options,
      statusCode: status,
      data: body,
    ),
  );
}

void main() {
  setUp(setUpTestApp);

  test('maps transport failures to typed errors', () {
    final options = RequestOptions(path: '/test');

    expect(
      AppException.from(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        ),
      ).type,
      AppErrorType.network,
    );
    expect(
      AppException.from(
        DioException(
          requestOptions: options,
          type: DioExceptionType.receiveTimeout,
        ),
      ).type,
      AppErrorType.timeout,
    );
  });

  test('maps status codes to typed errors', () {
    expect(
      AppException.from(_badResponse(401)).type,
      AppErrorType.unauthorized,
    );
    expect(AppException.from(_badResponse(403)).type, AppErrorType.forbidden);
    expect(AppException.from(_badResponse(404)).type, AppErrorType.notFound);
    expect(AppException.from(_badResponse(422)).type, AppErrorType.validation);
    expect(AppException.from(_badResponse(503)).type, AppErrorType.server);
  });

  test('prefers the server message over the localized fallback', () {
    final withMessage = AppException.from(
      _badResponse(400, body: {'message': 'Email already taken'}),
    );
    expect(withMessage.message, 'Email already taken');

    final withoutMessage = AppException.from(_badResponse(400));
    expect(withoutMessage.message, isNot(LocaleKeys.errorBadRequest));
    expect(withoutMessage.message, isNotEmpty);
  });

  test('extracts field errors from both common shapes', () {
    final mapShape = AppException.from(
      _badResponse(
        422,
        body: {
          'errors': {
            'email': ['is taken'],
          },
        },
      ),
    );
    expect(mapShape.fieldErrors['email'], 'is taken');

    final listShape = AppException.from(
      _badResponse(
        422,
        body: {
          'errors': [
            {'field': 'password', 'message': 'too short'},
          ],
        },
      ),
    );
    expect(listShape.fieldErrors['password'], 'too short');
  });

  test('marks only transient failures as retryable', () {
    expect(AppException.from(_badResponse(500)).isRetryable, isTrue);
    expect(AppException.from(_badResponse(403)).isRetryable, isFalse);
  });

  test('passes an existing AppException through unchanged', () {
    const original = AppException(
      type: AppErrorType.conflict,
      messageKey: LocaleKeys.errorConflict,
    );
    expect(identical(AppException.from(original), original), isTrue);
  });
}
