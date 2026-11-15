import 'dart:async';

import 'package:gse_base_app/core/environments/env_config.dart';
import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/api/error_mapping.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/services/storage/utils/token_manager.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/auth/auth_failures.dart';
import 'package:gse_base_app/data/storage/user_manager.dart';

const String _repositoryName = 'AuthRepository';

enum AuthStatus { authenticated, unauthenticated, unknown }

class AuthRepository {
  new({
    required this._apiClient,
    required this._tokenManager,
    required this._userManager,
  });

  final ApiClient _apiClient;
  final TokenManager _tokenManager;
  final UserManager _userManager;

  final _authStatusController = StreamController<AuthStatus>.broadcast();

  AuthStatus _currentStatus = AuthStatus.unknown;

  /// Último estado de autenticación conocido. Usado por el router para
  /// evaluar redirects sin necesidad de leer el BLoC.
  AuthStatus get currentStatus => _currentStatus;

  /// Stream del estado de autenticación. El router escucha este stream para
  /// re-evaluar redirects solo cuando cambia el estado de autenticación.
  Stream<AuthStatus> get authStatusStream => _authStatusController.stream;

  void _emitStatus(AuthStatus status) {
    _currentStatus = status;
    _authStatusController.add(status);
  }

  /// Ends the local session: emits `unauthenticated` (the router sends to
  /// login) and clears the tokens and the saved user.
  ///
  /// Also called by the refresh-token interceptor when the session can no
  /// longer be renewed. If the session is already closed it does nothing, so
  /// several failed requests at once do not log out several times.
  Future<void> forceLogout() async {
    if (_currentStatus == AuthStatus.unauthenticated) return;
    _emitStatus(AuthStatus.unauthenticated);
    try {
      await _tokenManager.clearTokens();
    } catch (e, stack) {
      AppLogger.e('Error clearing tokens', error: e, stackTrace: stack);
    }
    try {
      await _userManager.clearUserData();
    } catch (e, stack) {
      AppLogger.e('Error clearing user', error: e, stackTrace: stack);
    }
  }

  void dispose() => _authStatusController.close();

  Future<Result<void, AuthFailure>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (EnvConfig.useMockAuth) {
      await _tokenManager.saveAccessToken('mock-access-token');
      await _tokenManager.saveRefreshToken('mock-refresh-token');
      await _tokenManager.saveUserSub('mock-user');
      _emitStatus(AuthStatus.authenticated);
      return const Success(null);
    }

    try {
      final body = {
        'email': email,
        'password': password,
      };

      final data = await _apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: body,
      );

      await _saveTokens(data);
      _emitStatus(AuthStatus.authenticated);

      return const Success(null);
    } catch (e, stack) {
      AppLogger.e(
        _repositoryName,
        error: e,
        stackTrace: stack,
      );
      return Failure(
        switch (e) {
          NetworkException(isTimeout: true) => AuthFailure.timeout,
          NetworkException() => AuthFailure.network,
          ApiHttpException(statusCode: 401) => AuthFailure.unauthorized,
          ApiHttpException(statusCode: 403) => AuthFailure.forbidden,
          ApiHttpException(statusCode: 400) => AuthFailure.client,
          ApiHttpException(statusCode: >= 500) => AuthFailure.server,
          _ => AuthFailure.unknown,
        },
      );
    }
  }

  /// Checks the whole response before saving, so an incomplete one never
  /// leaves half a session stored.
  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final accessToken = data['access_token'];
    final refreshToken = data['refresh_token'];
    final sub = data['sub'];
    if (accessToken is! String ||
        accessToken.isEmpty ||
        refreshToken is! String ||
        refreshToken.isEmpty ||
        sub is! String ||
        sub.isEmpty) {
      throw const FormatException('Login response without tokens');
    }

    await _tokenManager.saveAccessToken(accessToken);
    await _tokenManager.saveRefreshToken(refreshToken);
    await _tokenManager.saveUserSub(sub);
  }

  /// Checks at startup whether there is a session and emits the result.
  ///
  /// It does not call the server: having a refresh token is enough. If the
  /// access token expired, the first request gets 401 and
  /// `RefreshTokenInterceptor` renews it, or expires the session when it can
  /// no longer be renewed (single place for the refresh logic). This also
  /// keeps the session when the app opens without internet.
  Future<void> isUserLogged() async {
    try {
      final refreshToken = await _tokenManager.getRefreshToken();
      final hasSession = refreshToken != null && refreshToken.isNotEmpty;
      _emitStatus(
        hasSession ? AuthStatus.authenticated : AuthStatus.unauthenticated,
      );
    } catch (e, stack) {
      AppLogger.e(
        '$_repositoryName.isUserLogged',
        error: e,
        stackTrace: stack,
      );
      _emitStatus(AuthStatus.unauthenticated);
    }
  }

  /// Ends the session: notifies the server (best effort) and always closes
  /// the local session, even if the request or the storage fails. It never
  /// fails, so there is no [Result] to check.
  Future<void> logout() async {
    if (!EnvConfig.useMockAuth) {
      try {
        final accessToken = await _tokenManager.getAccessToken();
        await _apiClient.post<void>(
          '/auth/logout',
          data: {'access_token': accessToken},
        );
      } catch (e, stack) {
        // A failed server logout must not keep the user logged in locally.
        AppLogger.e('$_repositoryName.logout', error: e, stackTrace: stack);
      }
    }

    await forceLogout();
  }
}
