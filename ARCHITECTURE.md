# Architecture & Conventions

This document is the contract for the codebase. Follow it and every feature
will look the same, which is the point: you should be able to open any folder
six months from now and know where everything is.

---

## 1. The shape

Four top-level ideas, no more:

| Folder | Answers | Rule |
| --- | --- | --- |
| `app/` | How is the app assembled? | Startup, routes, global DI. Nothing feature-specific. |
| `core/` | What does every feature need? | Infrastructure. Must not import `features/`. |
| `theme/` + `widgets/` | What does the app look like? | Design tokens and shared UI. No business logic. |
| `features/` | What does the app *do*? | One folder per feature. May import anything above. |

**Dependency rule:** `features/` → `core/`, `theme/`, `widgets/`; never the
reverse. `core/session/user.dart` lives in core (not in the auth feature)
precisely because the session is cross-cutting.

There is no `domain/` layer, no use-case classes and no repository interfaces.
A repository *is* the abstraction over the network. Adding an interface on top
of it buys nothing when there is exactly one implementation — and tests fake the
concrete class just as easily (`implements AuthRepository`).

---

## 2. Anatomy of a feature

```text
features/<feature>/
├── data/
│   ├── <feature>_repository.dart   # server calls, JSON → models
│   └── <model>.dart                # immutable model + fromJson/toJson
├── <screen>_binding.dart           # what this screen needs
├── <screen>_controller.dart        # screen state and actions
├── <screen>_view.dart              # widgets only
└── widgets/                        # widgets used only by this feature
```

A feature with several screens nests them (`auth/sign_in/`, `auth/sign_up/`)
and shares `auth/data/`.

### Responsibilities

**Repository** — the only place that talks to `ApiClient`. Parses JSON, returns
models, throws `AppException`. No `Rx`, no widgets, no navigation.

**Controller** — owns screen state and user actions. Depends on repositories
through the constructor. Never imports `dio`, never builds widgets.

**View** — reads controller state and renders. `GetView<T>` gives you
`controller` for free. No business logic; no `Get.find()` inside `build` unless
the widget is a private helper that cannot receive it another way.

**Binding** — declares what the route needs. `Get.lazyPut` so nothing is built
until the screen opens; GetX disposes it when the route closes.

---

## 3. Adding a feature — the checklist

1. `mkdir lib/features/orders/{data,widgets}`
2. **Model** — `data/order.dart`: immutable, `const` constructor, `fromJson`,
   `toJson`, `copyWith`, value equality on the id.
3. **Endpoint** — add the path to `ApiEndpoints`.
4. **Repository** — `data/order_repository.dart`, takes `ApiClient` in the
   constructor, returns models.
5. **Controller** — `orders_controller.dart`:
   ```dart
   final Rx<ViewState<List<Order>>> orders =
       Rx<ViewState<List<Order>>>(const IdleState());

   Future<void> load() => orders.runAsync(
         () => _repository.fetchOrders(),
         isEmpty: (items) => items.isEmpty,
       );
   ```
6. **Binding** — `Get.lazyPut` the repository and controller.
7. **View** — wrap the reactive part in `Obx` + `StateView`.
8. **Route** — add a constant to `AppRoutes` and a `GetPage` to `AppPages`,
   with `middlewares: [AuthMiddleware()]` if it needs a session.
9. **Strings** — add keys to `LocaleKeys` and every locale map.
10. **Test** — a controller test with a fake repository (see
    `test/unit/home_controller_test.dart`).

---

## 4. State management

- **`Rx` + `Obx` for screen state.** `GetBuilder` only when you have measured a
  rebuild problem.
- **Wrap the smallest possible subtree in `Obx`.** An `Obx` around a whole page
  rebuilds the whole page.
- **Every async load goes through `ViewState<T>` + `runAsync`.** Do not
  hand-roll `isLoading` / `errorMessage` / `data` triplets — they drift out of
  sync, and `StateView` already renders all five cases.
- **`ViewState` is sealed**, so `switch` over it is exhaustive and adding a
  state is a compile error everywhere it matters.
- **Dispose what you create.** `TextEditingController`, `Debouncer`,
  `StreamSubscription` → `onClose()`.
- **Never name a controller method `refresh`** — `GetxController` already has
  one. (`refreshArticles`, not `refresh`.)
- **Never `await` a navigation call.** `Get.offAllNamed` completes when the
  *new* route is popped, so awaiting it hangs the caller forever. Use
  `unawaited(...)`.

---

## 5. Networking & errors

```text
View → Controller → Repository → ApiClient → Dio(interceptors) → server
```

- Only `ApiClient` imports `dio`. Everything above handles `AppException`.
- Interceptor order in `AppBindings` is deliberate:
  `AuthInterceptor` (attach/refresh token) → `RetryInterceptor` (backoff) →
  `LoggingInterceptor` (log the final request).
- **Token refresh is single-flight.** Ten parallel 401s trigger one refresh, and
  each request is retried at most once before the session ends.
- **Retries are only automatic for idempotent verbs.** A `POST` is retried only
  when it carries an `Idempotency-Key` header — a payment must never be
  submitted twice by a retry.
- **Logs are redacted.** Passwords, tokens, card numbers and auth headers are
  masked, and logging is off in release builds.
- Mark public endpoints with `options: ApiClient.publicRequest` so the auth
  interceptor skips them.

Catch errors at the boundary that can *do* something:

```dart
try {
  await _repository.signIn(...);
} on AppException catch (error) {
  AppSnackbar.failure(error);   // already localized
}
```

Use `error.type` to branch, `error.message` to display, `error.fieldErrors` to
map server validation back onto form fields.

---

## 6. Dependency injection

- **Constructor injection everywhere.** A class names what it needs; the binding
  supplies it. This is what makes fakes possible without a mocking package.
- `Get.find()` belongs in **bindings**, not in controllers or repositories.
- Global, app-lifetime services → `AppBindings` with `permanent: true`.
- Screen-scoped objects → the feature's binding with `Get.lazyPut`.
- Use `fenix: true` for a repository shared by several routes so it can be
  rebuilt after disposal.

---

## 7. Theming & UI

- **No hardcoded colors, sizes or font sizes in widgets.** Use
  `context.colors` (Material scheme), `context.semantic` (success/warning/info),
  `AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`.
- **Text goes through `AppText`.** `AppText.titleMedium(...)`, never
  `Text(..., style: TextStyle(fontSize: 16))`.
- **Rebranding is one line:** `AppColors.seed`.
- **Responsive = layout, not scaling.** Use `context.responsive(mobile:, tablet:,
  desktop:)`, `ResponsiveLayout` and `ConstrainedBody`. Do not scale spacing
  constants off screen height — values captured at startup are wrong after a
  rotation or resize and unusable in tests.
- Screens use `AppScaffold` (keyboard dismissal, safe area, page padding).
- Prefer a shimmer skeleton that mirrors the real layout over a bare spinner.

---

## 8. Localization

- **Never write a raw key string.** `LocaleKeys.signIn.tr`, not `'sign_in'.tr` —
  a typo in the second form silently renders the key.
- Add a new string to `LocaleKeys` **and every map** in `l10n/locales/`.
- Locale map keys must equal `Locale.toString()` — `en_US`, not `en_us`.
- Parameters use GetX syntax: `LocaleKeys.validationMinLength.trParams({'min': '8'})`.

---

## 9. Naming & style

| Thing | Convention | Example |
| --- | --- | --- |
| Files | `snake_case`, suffix by role | `sign_in_controller.dart` |
| Classes | `PascalCase` | `SignInController` |
| Shared widgets | `App` prefix | `AppButton`, `AppTextField` |
| Private widgets | `_` prefix, same file | `_AccountCard` |
| Booleans | `is` / `has` / `can` | `isSubmitting`, `canRefresh` |
| Constants classes | `abstract final class` | `AppSpacing` |
| Async methods | verb, returns `Future` | `fetchArticles()` |

Also:

- Relative imports inside `lib/` (enforced by the analyzer); `package:` imports
  in `test/`.
- Prefer `final`, `const`, and immutable models.
- Public API gets a doc comment that explains **why**, not what.
- Run `dart format .` before committing; `analysis_options.yaml` is the
  style authority.

---

## 10. Testing

- `test/unit/` — pure logic: validators, error mapping, controllers, services,
  and the interceptor chain (via `FakeHttpAdapter`, which serves canned
  responses so auth-refresh and retry behaviour is tested without a server).
- `test/widget/` — rendering and interaction, plus `app_smoke_test.dart`, which
  boots the real `App` and is the cheapest guard against a broken DI graph.
- `test/helpers/` — `setUpTestApp()` (config + translations) and fakes.

Rules:

- **Hand-written fakes, no mocking package.** `implements` the concrete class;
  it stays readable and refactor-safe.
- Use `InMemoryKeyValueStore` and `InMemoryTokenStore` — never touch disk or
  platform channels in a test.
- Widget tests that use snackbars, dialogs or named routes must run inside
  `pumpApp` (a real `GetMaterialApp`).
- Call `tearDownTestApp()` so GetX state cannot leak between tests.
- Let timers expire before a test ends (`await tester.pump(Duration(seconds: 6))`
  after a snackbar), otherwise the binding reports a pending timer.

---

## 11. Things deliberately left out

| Not here | Why | Add it when |
| --- | --- | --- |
| Clean Architecture layers | Use cases and repository interfaces triple the file count for a solo developer with one backend | A second data source or team boundary appears |
| `freezed` / `json_serializable` | Requires `build_runner` on every checkout for a handful of models | Models pass ~15, or unions start appearing |
| A DI framework | GetX already does DI | Never, while GetX stays |
| Global `navigatorKey` | GetX navigates without context | Never |
| Local database | Not every app needs one | Real offline support is required — add Drift/Isar behind a repository |
