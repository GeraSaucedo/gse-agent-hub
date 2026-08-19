import 'package:gse_base_app/core/environments/env_config.dart';

/// Amplify (Cognito) configuration for the GSE base auth.
///
/// The per-environment values are injected by the active flavor through
/// `--dart-define-from-file .vscode/defines/<flavor>.json` and surfaced by
/// [EnvConfig]. Fill each flavor's JSON with the values of the EXISTING Cognito
/// User Pool (see the keys below). Treat pool/client IDs as opaque config.
///
/// The redirect scheme (`COGNITO_REDIRECT_SCHEME`) MUST match the native
/// deep-link config:
///   - iOS:     ios/Runner/Info.plist          (CFBundleURLSchemes)
///   - Android: android/app/src/main/AndroidManifest.xml (intent-filter scheme)
///
/// Social providers (Google, Sign in with Apple) must already be enabled on the
/// pool's Hosted UI; this client only triggers the federated flow.
String buildAmplifyConfig() {
  const region = EnvConfig.cognitoRegion;
  const poolId = EnvConfig.cognitoUserPoolId;
  const clientId = EnvConfig.cognitoAppClientId;
  const domain = EnvConfig.cognitoHostedUiDomain;
  const scheme = EnvConfig.cognitoRedirectScheme;

  return '''
{
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify-cli/0.1.0",
        "Version": "0.1.0",
        "IdentityManager": {
          "Default": {}
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "$poolId",
            "AppClientId": "$clientId",
            "Region": "$region"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH",
            "socialProviders": [
              "GOOGLE",
              "SIGN_IN_WITH_APPLE"
            ],
            "usernameAttributes": [
              "EMAIL"
            ],
            "signupAttributes": [
              "EMAIL",
              "NAME"
            ],
            "passwordProtectionSettings": {
              "passwordPolicyMinLength": 8,
              "passwordPolicyCharacters": []
            },
            "mfaConfiguration": "OFF",
            "verificationMechanisms": [
              "EMAIL"
            ],
            "OAuth": {
              "WebDomain": "$domain",
              "AppClientId": "$clientId",
              "SignInRedirectURI": "$scheme://",
              "SignOutRedirectURI": "$scheme://",
              "Scopes": [
                "email",
                "openid",
                "profile",
                "aws.cognito.signin.user.admin"
              ]
            }
          }
        }
      }
    }
  }
}''';
}
