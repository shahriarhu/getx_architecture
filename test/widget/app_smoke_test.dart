import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/app.dart';
import 'package:getx_architecture/core/network/api_client.dart';
import 'package:getx_architecture/core/session/auth_tokens.dart';
import 'package:getx_architecture/core/session/session_service.dart';
import 'package:getx_architecture/core/session/token_store.dart';
import 'package:getx_architecture/core/session/user.dart';
import 'package:getx_architecture/core/storage/key_value_store.dart';
import 'package:getx_architecture/features/auth/sign_in/sign_in_view.dart';
import 'package:getx_architecture/features/splash/splash_view.dart';
import 'package:getx_architecture/l10n/locale_controller.dart';
import 'package:getx_architecture/theme/theme_controller.dart';

import '../helpers/test_app.dart';

/// Boots the real [App] — route table, bindings, theme and localization
/// included — against in-memory storage.
///
/// This is the cheapest guard against a broken dependency graph: if a binding
/// asks for something nobody registered, this test fails immediately.
void main() {
  setUp(setUpTestApp);
  tearDown(tearDownTestApp);

  late InMemoryTokenStore tokenStore;

  void registerGraph() {
    final store = Get.put<KeyValueStore>(InMemoryKeyValueStore());
    tokenStore = InMemoryTokenStore();
    Get.put<TokenStore>(tokenStore);
    Get.put(SessionService(tokenStore: tokenStore, store: store));
    Get.put(ApiClient(Dio()));
    Get.put(ThemeController(store));
    Get.put(LocaleController(store));
  }

  /// `pumpAndSettle` cannot be used here: the splash spinner and the list
  /// shimmer animate forever, so the tree never "settles".
  Future<void> settleStartup(WidgetTester tester) async {
    // Enough frames for: the splash's post-frame `onReady`, the session
    // restore future, the minimum-splash delay, and the route transition.
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 400));
    }
  }

  testWidgets('cold start with no session lands on sign-in', (tester) async {
    registerGraph();

    await tester.pumpWidget(const App());
    expect(find.byType(SplashView), findsOneWidget);

    await settleStartup(tester);

    expect(find.byType(SignInView), findsOneWidget);
    expect(Get.currentRoute, '/sign-in');
  });

  testWidgets('a restored session skips sign-in', (tester) async {
    registerGraph();
    await Get.find<SessionService>().start(
      tokens: AuthTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiry: DateTime.now().add(const Duration(hours: 1)),
      ),
      user: const User(id: '1', name: 'Ada Lovelace'),
    );

    await tester.pumpWidget(const App());
    await settleStartup(tester);

    expect(Get.currentRoute, '/home');
    expect(find.byType(SignInView), findsNothing);
  });
}
