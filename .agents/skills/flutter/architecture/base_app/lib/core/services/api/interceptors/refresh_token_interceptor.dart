import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gse_base_app/core/environments/env_config.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/services/storage/utils/token_manager.dart';

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(
    this._tokenManager, {
    required this.onRefreshFailed,
  });

  final TokenManager _tokenManager;
  final VoidCallback onRefreshFailed;
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
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

        final result = await _dio.post<Map<String, dynamic>>(
          '${EnvConfig.apiUrl}/auth/refresh-token',
          data: {'sub': sub, 'refresh_token': refreshToken},
        );

        final token = (result.data ?? {})['access_token'] as String?;
        if (token == null) {
          throw Exception('access_token missing in refresh response');
        }
        await _tokenManager.saveAccessToken(token);

        final retryFutures = _requestsQueue.map((item) async {
          final (requestErr, requestHandler) = item;
          requestErr.requestOptions.headers['Authorization'] =
              'Bearer $token';
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
        onRefreshFailed();
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
