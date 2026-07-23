import 'dart:async';

import 'package:gse_base_app/core/environments/env_config.dart';
import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/api/error_mapping.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/services/storage/utils/token_manager.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/auth/auth_failures.dart';
import 'package:gse_base_app/data/repositories/auth/jwt_utils.dart';

const String _repositoryName = 'AuthRepository';

enum AuthStatus { authenticated, unauthenticated, unknown }

class AuthRepository {
  AuthRepository({
    required ApiClient apiClient,
    required TokenManager tokenManager,
  }) : _apiClient = apiClient,
       _tokenManager = tokenManager;

  final ApiClient _apiClient;
  final TokenManager _tokenManager;

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

  /// Llamar desde el interceptor de refresh token cuando ambos tokens expiran.
  void forceLogout() => _emitStatus(AuthStatus.unauthenticated);

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
        '${EnvConfig.apiUrl}/auth/login',
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
          UnauthorizedException() => AuthFailure.unauthorized,
          ForbiddenException() => AuthFailure.forbidden,
          BadRequestException() => AuthFailure.client,
          ServerException() => AuthFailure.server,
          NoInternetException() => AuthFailure.network,
          TimeoutException() => AuthFailure.timeout,
          _ => AuthFailure.unknown,
        },
      );
    }
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    await _tokenManager.saveAccessToken(data['access_token'] as String);
    await _tokenManager.saveRefreshToken(data['refresh_token'] as String);
    await _tokenManager.saveUserSub(data['sub'] as String);
  }

  /// Verifica si el usuario tiene una sesión activa y emite el resultado
  /// al stream de autenticación.
  Future<void> isUserLogged() async {
    if (EnvConfig.useMockAuth) {
      final token = await _tokenManager.getAccessToken();
      _emitStatus(
        token != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      );
      return;
    }

    final accessToken = await _verifyTokenValidation();
    _emitStatus(
      accessToken != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
    );
  }

  /// Valida el access token almacenado. Si expiró, intenta hacer refresh.
  /// Retorna el access token vigente o `null` si no se pudo obtener uno válido.
  Future<String?> _verifyTokenValidation() async {
    try {
      final accessToken = await _tokenManager.getAccessToken();
      final refreshToken = await _tokenManager.getRefreshToken();

      if (accessToken == null || refreshToken == null) return null;

      if (await JwtUtils.isTokenValid(accessToken)) return accessToken;

      // Access token expirado → intentar refresh
      final sub = await _tokenManager.getUserSub();
      if (sub == null || sub.isEmpty) return null;

      final data = await _apiClient.post<Map<String, dynamic>>(
        '${EnvConfig.apiUrl}/auth/refresh-token',
        data: {'refresh_token': refreshToken, 'sub': sub},
      );

      final newAccessToken = data['access_token'] as String;

      await _tokenManager.saveAccessToken(newAccessToken);

      // Si el servidor emite un nuevo refresh token, también lo guardamos
      if (data['refresh_token'] != null) {
        await _tokenManager.saveRefreshToken(data['refresh_token'] as String);
      }

      return newAccessToken;
    } catch (e, stack) {
      AppLogger.e(
        '$_repositoryName._verifyTokenValidation()',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  /// Delete all data saved on the storages services
  Future<Result<void, AuthFailure>> logout() async {
    if (EnvConfig.useMockAuth) {
      await _tokenManager.clearTokens();
      _emitStatus(AuthStatus.unauthenticated);
      return const Success(null);
    }

    try {
      final accessToken = await _tokenManager.getAccessToken();

      final body = {
        'access_token': accessToken,
      };

      try {
        await _apiClient.post<void>(
          '${EnvConfig.apiUrl}/auth/logout',
          data: body,
        );
      } catch (e, stack) {
        AppLogger.e('Error on request logout', error: e, stackTrace: stack);
      }

      await _tokenManager.clearTokens();
      _emitStatus(AuthStatus.unauthenticated);
      return const Success(null);
    } catch (e, stack) {
      AppLogger.e('Error on logout', error: e, stackTrace: stack);
      return const Failure(AuthFailure.unknown);
    }
  }
}
