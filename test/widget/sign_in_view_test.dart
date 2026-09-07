import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/routes/app_routes.dart';
import 'package:getx_architecture/core/errors/app_exception.dart';
import 'package:getx_architecture/core/session/session_service.dart';
import 'package:getx_architecture/core/session/token_store.dart';
import 'package:getx_architecture/core/storage/key_value_store.dart';
import 'package:getx_architecture/features/auth/sign_in/sign_in_controller.dart';
import 'package:getx_architecture/features/auth/sign_in/sign_in_view.dart';
import 'package:getx_architecture/l10n/translation_keys.dart';

import '../helpers/fakes.dart';
import '../helpers/test_app.dart';

void main() {
  setUp(setUpTestApp);
  tearDown(tearDownTestApp);

  late SessionService session;

  setUp(() {
    session = SessionService(
      tokenStore: InMemoryTokenStore(),
      store: InMemoryKeyValueStore(),
    );
  });

  SignInController register(FakeAuthRepository repository) => Get.put(
    SignInController(repository: repository, session: session),
  );

  Future<void> pumpSignIn(WidgetTester tester) => pumpApp(
    tester,
    const SignInView(),
    pages: [
      GetPage<void>(
        name: AppRoutes.home,
        page: () => const Scaffold(body: Text('home-stub')),
      ),
    ],
  );

  Future<void> submit(WidgetTester tester) async {
    final button = find.widgetWithText(ElevatedButton, LocaleKeys.signIn.tr);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  testWidgets('blocks submission and shows errors for an empty form', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    register(repository);
    await pumpSignIn(tester);

    await submit(tester);

    expect(find.text(LocaleKeys.validationRequired.tr), findsNWidgets(2));
    expect(repository.signInCalls, isEmpty);
  });

  testWidgets('rejects a malformed email before calling the API', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    register(repository);
    await pumpSignIn(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await submit(tester);

    expect(find.text(LocaleKeys.validationEmail.tr), findsOneWidget);
    expect(repository.signInCalls, isEmpty);
  });

  testWidgets('sends trimmed credentials and navigates on success', (
    tester,
  ) async {
    final repository = FakeAuthRepository(session: session);
    final controller = register(repository);
    await pumpSignIn(tester);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      '  ada@example.com  ',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await submit(tester);

    expect(repository.signInCalls.single.email, 'ada@example.com');
    expect(repository.signInCalls.single.password, 'secret123');
    expect(controller.isSubmitting.value, isFalse);
    expect(session.isAuthenticated, isTrue);
    expect(find.text('home-stub'), findsOneWidget);
  });

  testWidgets('surfaces API failures without navigating', (tester) async {
    final repository = FakeAuthRepository(
      error: const AppException(
        type: AppErrorType.unauthorized,
        messageKey: LocaleKeys.errorUnauthorized,
        serverMessage: 'Invalid credentials',
      ),
    );
    final controller = register(repository);
    await pumpSignIn(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'ada@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await submit(tester);

    expect(find.text('Invalid credentials'), findsOneWidget);
    expect(find.text('home-stub'), findsNothing);
    expect(controller.isSubmitting.value, isFalse);
    expect(session.isAuthenticated, isFalse);

    // Let the snackbar's auto-dismiss timer expire before the tree is torn
    // down, otherwise the test binding reports a pending timer.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
  });
}
