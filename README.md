# Flutter + GetX Starter

A production-ready starting point for Flutter apps built with GetX — state
management, dependency injection and routing — without Clean Architecture's
layer tax.

Everything a real app needs on day one is already wired: theming and design
tokens, networking with token refresh and retries, typed errors, secure
storage, localization, form validation, loading/empty/error states, logging
and a test setup.

---

## Requirements

Flutter 3.44+ with JDK 17 or newer (Android Studio's bundled JBR is fine —
`flutter doctor --verbose` reports which Java it uses). The Android module
targets the current Flutter template: Gradle 9.1, AGP 9.0.1, Kotlin 2.3.20,
Java 17, compileSdk/targetSdk 36, minSdk 24.

## Quick start

```bash
flutter pub get
flutter run
```

The dev flavour points at [jsonplaceholder](https://jsonplaceholder.typicode.com),
so the home screen loads real data immediately. Sign-in needs your own backend —
until then, use the **Skip sign in (demo)** button, which appears in non-production
builds only.

Point it at your API:

```bash
flutter run --dart-define=API_BASE_URL=https://api.yourapp.com
```

### Build flavours

Configuration comes from `--dart-define`, so no secrets or URLs are compiled in
per environment. See `lib/core/config/app_config.dart`.

| Key                  | Values                  | Default                    |
| -------------------- | ----------------------- | -------------------------- |
| `APP_FLAVOR`         | `dev`, `staging`, `prod`| `dev`                      |
| `API_BASE_URL`       | any URL                 | per flavour                |
| `ENABLE_NETWORK_LOGS`| `true`, `false`         | `true` outside release     |

```bash
flutter build apk --release \
  --dart-define=APP_FLAVOR=prod \
  --dart-define=API_BASE_URL=https://api.yourapp.com
```

### Checks

```bash
flutter analyze && flutter test
```

---

## Project structure

```text
lib/
├── main.dart                  # entry point — bootstrap, then runApp
├── app/                       # how the app is assembled
│   ├── app.dart               # GetMaterialApp
│   ├── app_bindings.dart      # global dependency graph
│   ├── bootstrap.dart         # pre-first-frame setup, error handlers
│   └── routes/                # route names, page table, middlewares
├── core/                      # cross-cutting infrastructure
│   ├── config/                # environment-driven configuration
│   ├── constants/             # asset paths, storage keys, magic numbers
│   ├── errors/                # AppException — the app's only error type
│   ├── extensions/            # BuildContext, String?, num, DateTime helpers
│   ├── logging/               # AppLogger (+ crash-reporter hook)
│   ├── network/               # ApiClient, endpoints, interceptors
│   ├── session/               # tokens, secure store, SessionService, User
│   ├── state/                 # ViewState<T> and runAsync
│   ├── storage/               # KeyValueStore (+ in-memory fake)
│   └── utils/                 # validators, debouncer
├── features/                  # one folder per feature — where you work
│   ├── auth/
│   │   ├── data/              # repository + models
│   │   └── sign_in/           # binding, controller, view, widgets
│   ├── home/
│   ├── settings/
│   ├── splash/
│   └── not_found/
├── l10n/                      # typed keys + locale maps + LocaleController
├── theme/                     # colors, typography, spacing, ThemeController
└── widgets/                   # shared, feature-agnostic UI
```

Read a feature top-to-bottom in one folder; reach into `core/`, `theme/` and
`widgets/` for anything shared. That is the whole mental model.

---

## What's included

| Area | Where | Notes |
| --- | --- | --- |
| Theme & design system | `theme/` | Seeded Material 3 scheme, light + dark from one builder |
| Design tokens | `theme/app_spacing.dart` | Spacing, radius, sizes, durations, breakpoints |
| Typography | `theme/app_typography.dart` | Full M3 type scale |
| Semantic colors | `theme/app_colors.dart` | `ThemeExtension` for success/warning/info |
| Routing & guards | `app/routes/` | Named routes, per-page bindings, auth middleware |
| DI | `app/app_bindings.dart` | Constructor injection, feature-scoped bindings |
| Networking | `core/network/` | Dio + auth refresh, retry/backoff, redacted logging |
| Error handling | `core/errors/` | One `AppException`, localized messages, field errors |
| Local storage | `core/storage/` | `KeyValueStore` + secure token store |
| Session | `core/session/` | Restore, start, sign out, route-guard flag |
| Config | `core/config/` | Flavours via `--dart-define` |
| Logging | `core/logging/` | Level-based, release-silent, crash-reporter hook |
| Localization | `l10n/` | Typed keys, English + Bangla, device-locale detection |
| Validation | `core/utils/validators.dart` | Composable `FormFieldValidator`s |
| UI states | `widgets/states/` | `StateView` renders loading/empty/error/success |
| Shared widgets | `widgets/` | Text, buttons, inputs, images, shimmer, dialogs |
| Testing | `test/` | 66 tests, hand-written fakes, no mocking package |

---

## Conventions

Coding conventions are documented in **[ARCHITECTURE.md](ARCHITECTURE.md)** and
enforced by `analysis_options.yaml`. Start there before adding your first
feature.

## Replacing the demo content

The `home` feature and the demo sign-in shortcut exist to show the patterns.
To start your own app:

1. Delete `lib/features/home/` and `lib/features/not_found/` if you do not want them.
2. Remove `continueAsDemoUser` from `SignInController` and its button in `SignInView`.
3. Point `ApiEndpoints` at your API and adjust `User.fromJson` to your payload.
4. Change `AppColors.seed` to your brand color.
