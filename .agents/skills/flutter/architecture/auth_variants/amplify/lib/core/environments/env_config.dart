enum Environment { dev, stg, prod, unknown }

class EnvConfig {
  static const String apiUrl = String.fromEnvironment('API_URL');
  static const String _env = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'null',
  );
  static const bool useMockAuth = bool.fromEnvironment('USE_MOCK_AUTH');

  // Cognito (per-flavor). Values come from .vscode/defines/<flavor>.json and
  // are interpolated into lib/amplifyconfiguration.dart. Treat as opaque config.
  static const String cognitoRegion = String.fromEnvironment('COGNITO_REGION');
  static const String cognitoUserPoolId =
      String.fromEnvironment('COGNITO_USER_POOL_ID');
  static const String cognitoAppClientId =
      String.fromEnvironment('COGNITO_APP_CLIENT_ID');
  static const String cognitoHostedUiDomain =
      String.fromEnvironment('COGNITO_HOSTED_UI_DOMAIN');
  static const String cognitoRedirectScheme =
      String.fromEnvironment('COGNITO_REDIRECT_SCHEME');

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
