import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/core/errors/app_exception.dart';
import 'package:getx_architecture/core/state/view_state.dart';
import 'package:getx_architecture/l10n/translation_keys.dart';
import 'package:getx_architecture/widgets/states/state_view.dart';
import 'package:getx_architecture/widgets/states/status_views.dart';

import '../helpers/test_app.dart';

void main() {
  setUp(setUpTestApp);
  tearDown(tearDownTestApp);

  Future<void> pumpState(
    WidgetTester tester,
    ViewState<String> state, {
    VoidCallback? onRetry,
  }) {
    return pumpApp(
      tester,
      Scaffold(
        body: StateView<String>(
          state: state,
          onRetry: onRetry,
          builder: Text.new,
        ),
      ),
    );
  }

  testWidgets('idle renders nothing', (tester) async {
    await pumpState(tester, const IdleState());
    expect(find.byType(LoadingView), findsNothing);
    expect(find.byType(MessageView), findsNothing);
  });

  testWidgets('loading renders the default spinner', (tester) async {
    await pumpState(tester, const LoadingState());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('success renders the builder output', (tester) async {
    await pumpState(tester, const SuccessState('hello'));
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('empty renders the shared empty view', (tester) async {
    await pumpState(tester, const EmptyState());
    expect(find.text(LocaleKeys.noDataFound.tr), findsOneWidget);
  });

  testWidgets('error shows the message and a retry action', (tester) async {
    var retries = 0;
    await pumpState(
      tester,
      const ErrorState(
        AppException(
          type: AppErrorType.server,
          messageKey: LocaleKeys.errorServer,
          serverMessage: 'Database is on fire',
        ),
      ),
      onRetry: () => retries++,
    );

    expect(find.text('Database is on fire'), findsOneWidget);
    await tester.tap(find.text(LocaleKeys.retry.tr));
    expect(retries, 1);
  });

  testWidgets('offline errors get the offline treatment', (tester) async {
    await pumpState(
      tester,
      const ErrorState(
        AppException(
          type: AppErrorType.network,
          messageKey: LocaleKeys.errorNoConnection,
        ),
      ),
    );

    expect(find.text(LocaleKeys.offline.tr), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
  });
}
