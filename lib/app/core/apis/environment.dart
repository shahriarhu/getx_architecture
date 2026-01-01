enum Environment { production, development, local }

class EnvironmentConfig {
  static late Environment environment;

  /// Initialize the environment at app startup
  static void init(Environment env) {
    environment = env;
  }

  /// Returns base URL based on the environment
  static String get baseUrl {
    switch (environment) {
      case Environment.local:
        return 'http://localhost:8080';
      case Environment.development:
        return 'https://api.dev.shahriarhu.com';
      case Environment.production:
        return 'https://api.shahriarhu.com';
    }
  }

  static bool get isProd => environment == Environment.production;
}
