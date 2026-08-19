import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dio/dio.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';

/// Attaches the Cognito token to business-API requests.
///
/// The token comes from the current Amplify session (Amplify owns refresh);
/// this interceptor never stores or renews tokens.
class BearerTokenInterceptor extends Interceptor {
  BearerTokenInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.headers.containsKey('Authorization')) {
      try {
        final token = await _currentToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        AppLogger.e('BearerTokenInterceptor: error getting token: $e');
      }
    }
    handler.next(options);
  }

  Future<String?> _currentToken() async {
    final session =
        await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
    if (!session.isSignedIn) return null;
    // idToken carries the user claims most backends expect. Switch to
    // `accessToken` here if the API validates the Cognito access token.
    return session.userPoolTokensResult.valueOrNull?.idToken.raw;
  }
}
