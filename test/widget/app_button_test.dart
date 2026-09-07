import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_architecture/widgets/buttons/app_button.dart';

import '../helpers/test_app.dart';

void main() {
  setUp(setUpTestApp);
  tearDown(tearDownTestApp);

  testWidgets('renders its label and forwards taps', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      Scaffold(
        body: AppButton(label: 'Continue', onPressed: () => taps++),
      ),
    );

    expect(find.text('Continue'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(taps, 1);
  });

  testWidgets('swallows taps and shows a spinner while loading', (
    tester,
  ) async {
    var taps = 0;
    await pumpApp(
      tester,
      Scaffold(
        body: AppButton(
          label: 'Submit',
          loading: true,
          onPressed: () => taps++,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(taps, 0, reason: 'a loading button must not fire twice');
  });

  testWidgets('is disabled when onPressed is null', (tester) async {
    await pumpApp(
      tester,
      const Scaffold(body: AppButton(label: 'Disabled')),
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('variants map to the matching Material button', (tester) async {
    await pumpApp(
      tester,
      Scaffold(
        body: Column(
          children: [
            AppButton.outlined(label: 'Outlined', onPressed: () {}),
            AppButton.text(label: 'Text', onPressed: () {}),
            AppButton.danger(label: 'Danger', onPressed: () {}),
          ],
        ),
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
