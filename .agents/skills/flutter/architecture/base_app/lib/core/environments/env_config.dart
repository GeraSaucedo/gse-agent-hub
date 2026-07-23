enum Environment { dev, stg, prod, unknown }

class EnvConfig {
  static const String apiUrl = String.fromEnvironment('API_URL');
  static const String _env = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'null',
  );
  static const bool useMockAuth = bool.fromEnvironment('USE_MOCK_AUTH');

  static Environment get environment => switch (_env) {
    'dev' => Environment.dev,
    'stg' => Environment.stg,
    'prod' => Environment.prod,
    _ => Environment.unknown,
  };

  static bool get isDev => environment == Environment.dev;
  static bool get isStg => environment == Environment.stg;
  static bool get isProd => environment == Environment.prod;
}
