import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gse_base_app/core/environments/env_config.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/services/storage/utils/token_manager.dart';

class _SessionExpired implements Exception {
  const _SessionExpired(this.reason);
  final String reason;

  @override
  String toString() => '_SessionExpired($reason)';
}

bool _isSessionExpired(Object e) {
  if (e is _SessionExpired) return true;
  if (e is DioException) {
    return const {400, 401, 403}.contains(e.response?.statusCode);
  }
  // Malformed refresh response (e.g. missing access_token).
  return true;
}

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(
    this._tokenManager, {
    required this.onRefreshFailed,
    Dio? refreshClient,
  }) : _dio =
           refreshClient ??
           Dio(
             BaseOptions(
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 20),
             ),
           );

  final TokenManager _tokenManager;
  final VoidCallback onRefreshFailed;
  // Separate client (no interceptors) for the refresh call and retries.
  final Dio _dio;
  bool _isRefreshing = false;
  final List<(DioException, ErrorInterceptorHandler)> _requestsQueue = [];

  static const _whitelistRoutes = [
    '/auth/login',
    '/auth/refresh-token',
    '/auth/logout',
  ];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final wasRetried = err.requestOptions.extra['wasRetried'] == true;
    final isUnauthorized = err.response?.statusCode == 401;
    final isWhitelisted = _whitelistRoutes.any(
      (path) => err.requestOptions.path.contains(path),
    );

    if (EnvConfig.useMockAuth) {
      if (!handler.isCompleted) handler.next(err);
      return;
    }

    if (isUnauthorized && !isWhitelisted && !wasRetried) {
      if (_isRefreshing) {
        _requestsQueue.add((err, handler));
        return;
      }

      _isRefreshing = true;
      _requestsQueue.add((err, handler));
      try {
        final refreshToken = await _tokenManager.getRefreshToken();
        final sub = await _tokenManager.getUserSub();
        if (refreshToken == null || sub == null) {
          throw const _SessionExpired('no stored refresh credentials');
        }

        final result = await _dio.post<Map<String, dynamic>>(
          '${EnvConfig.apiUrl}/auth/refresh-token',
          data: {'sub': sub, 'refresh_token': refreshToken},
        );

        final token = (result.data ?? {})['access_token'] as String?;
        if (token == null) {
          throw Exception('access_token missing in refresh response');
        }
        await _tokenManager.saveAccessToken(token);
        // The server may rotate the refresh token; keep the new one.
        final newRefreshToken = (result.data ?? {})['refresh_token'] as String?;
        if (newRefreshToken != null) {
          await _tokenManager.saveRefreshToken(newRefreshToken);
        }

        final retryFutures = _requestsQueue.map((item) async {
          final (requestErr, requestHandler) = item;
          requestErr.requestOptions.headers['Authorization'] = 'Bearer $token';
          requestErr.requestOptions.extra['wasRetried'] = true;
          try {
            final response = await _dio.fetch<dynamic>(
              requestErr.requestOptions,
            );
            requestHandler.resolve(response);
          } catch (e) {
            requestHandler.next(requestErr);
          }
        }).toList();

        await Future.wait(retryFutures);
        _requestsQueue.clear();
        return;
      } catch (e) {
        AppLogger.e('RefreshTokenInterceptor | refresh failed: $e');
        // Only end the session when the server rejected the credentials.
        // Network errors, timeouts and 5xx must not log the user out.
        if (_isSessionExpired(e)) onRefreshFailed();
        for (final (requestErr, requestHandler) in _requestsQueue) {
          requestHandler.reject(requestErr);
        }
        _requestsQueue.clear();
      } finally {
        _isRefreshing = false;
      }
    }

    if (!handler.isCompleted) {
      handler.next(err);
    }
  }
}
