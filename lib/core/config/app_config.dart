import 'package:flutter/foundation.dart';

/// Build flavours. Selected at build time with
/// `--dart-define=APP_FLAVOR=dev|staging|prod`.
enum AppFlavor { dev, staging, prod }

/// Immutable, environment-driven application configuration.
///
/// Everything that changes between environments lives here and *only* here.
/// Values come from `--dart-define` so no secrets or URLs are hardcoded per
/// build; see README for the full list of keys.
@immutable
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    this.connectTimeout = const Duration(seconds: 20),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.enableNetworkLogs = true,
    this.maxApiRetries = 2,
  });

  /// Reads the configuration from `--dart-define` values, falling back to
  /// development defaults so `flutter run` works with zero arguments.
  factory AppConfig.fromEnvironment() {
    const rawFlavor = String.fromEnvironment('APP_FLAVOR', defaultValue: 'dev');
    final flavor = AppFlavor.values.firstWhere(
      (f) => f.name == rawFlavor,
      orElse: () => AppFlavor.dev,
    );

    const defaultUrls = {
      'dev': 'https://jsonplaceholder.typicode.com',
      'staging': 'https://staging.api.example.com',
      'prod': 'https://api.example.com',
    };

    return AppConfig(
      flavor: flavor,
      appName: switch (flavor) {
        AppFlavor.dev => 'Starter Dev',
        AppFlavor.staging => 'Starter Staging',
        AppFlavor.prod => 'Starter',
      },
      apiBaseUrl:
          const String.fromEnvironment('API_BASE_URL').isNotEmpty
              ? const String.fromEnvironment('API_BASE_URL')
              : defaultUrls[flavor.name]!,
      enableNetworkLogs: const bool.fromEnvironment(
        'ENABLE_NETWORK_LOGS',
        defaultValue: !kReleaseMode,
      ),
    );
  }

  final AppFlavor flavor;
  final String appName;
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final bool enableNetworkLogs;
  final int maxApiRetries;

  bool get isProd => flavor == AppFlavor.prod;

  /// Developer affordances (flavour banner, demo shortcuts) are only shown
  /// outside production builds.
  bool get showDevTools => !isProd;

  /// Set once during [bootstrap]. Tests may assign a custom instance.
  static late AppConfig instance;
}
