import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/core/errors/app_exception.dart';
import 'package:getx_architecture/core/state/view_state.dart';

import '../helpers/test_app.dart';

void main() {
  setUp(setUpTestApp);

  Rx<ViewState<List<int>>> newState() =>
      Rx<ViewState<List<int>>>(const IdleState());

  test('emits loading then success', () async {
    final state = newState();
    final seen = <ViewState<List<int>>>[];
    state.listen(seen.add);

    await state.runAsync(() async => [1, 2, 3]);

    expect(seen.map((s) => s.runtimeType), [
      LoadingState<List<int>>,
      SuccessState<List<int>>,
    ]);
    expect(state.value.dataOrNull, [1, 2, 3]);
  });

  test('maps an empty result to EmptyState when isEmpty says so', () async {
    final state = newState();

    await state.runAsync(
      () async => <int>[],
      isEmpty: (items) => items.isEmpty,
    );

    expect(state.value, isA<EmptyState<List<int>>>());
  });

  test('captures thrown errors as AppException', () async {
    final state = newState();

    await state.runAsync(
      () async =>
          throw const AppException(
            type: AppErrorType.server,
            messageKey: 'error_server',
          ),
    );

    expect(state.value, isA<ErrorState<List<int>>>());
    expect(state.value.errorOrNull?.type, AppErrorType.server);
    expect(state.value.hasError, isTrue);
  });

  test('normalizes non-AppException throws', () async {
    final state = newState();

    await state.runAsync(() async => throw StateError('boom'));

    expect(state.value.errorOrNull?.type, AppErrorType.unknown);
  });

  test('showLoading: false keeps the previous value visible', () async {
    final state = newState()..value = const SuccessState([1]);
    final seen = <ViewState<List<int>>>[];
    state.listen(seen.add);

    await state.runAsync(() async => [1, 2], showLoading: false);

    expect(seen.whereType<LoadingState<List<int>>>(), isEmpty);
    expect(state.value.dataOrNull, [1, 2]);
  });
}
