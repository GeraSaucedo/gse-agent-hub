import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gse_base_app/core/environments/env_config.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/services/storage/utils/token_manager.dart';

/// Result of a refresh attempt.
enum _RefreshOutcome {
  /// A new access token was obtained and saved.
  refreshed,

  /// The session can no longer be renewed (refresh token missing, rejected or
  /// invalid response). The user must log in again.
  sessionExpired,

  /// The refresh could not be completed for a temporary reason (no network,
  /// timeout, server error). The session is kept so the user can retry.
  transientError,
}

/// Renews the access token when a request fails with 401 and retries it.
///
/// - Only requests sent with a Bearer token are handled. A 401 for a request
///   without a token (public endpoint used while logged out) or with its own
///   credentials (e.g. `Basic` for a third-party API) is passed through as is.
/// - Routes in `_whitelistRoutes` are never refreshed. A 401 always means
///   "invalid token" here: if an authenticated endpoint uses 401 for a
///   business error (e.g. wrong current password), add it to that list or,
///   better, have the backend use 400/403/422 for it.
/// - Concurrent 401s share a single refresh call; every request waits for it
///   and then retries on its own, so no request is left without a response.
/// - A request that was sent with an older token than the one currently
///   stored is retried with the current token, without refreshing again.
/// - If the server rotates the refresh token, the new one is saved.
/// - [onSessionExpired] is called only when the session really can't be
///   renewed: the refresh is rejected, or a request still gets 401 with the
///   freshly renewed token. Network errors and timeouts don't log the user out.
class RefreshTokenInterceptor extends Interceptor {
  new(
    this._tokenManager, {
    required this.onSessionExpired,
    Dio? refreshDio,
  }) : _dio =
           refreshDio ??
           Dio(
             BaseOptions(
               // Empty only when API_URL is not defined (e.g. tests).
               // ignore: avoid_redundant_argument_values
               baseUrl: EnvConfig.apiUrl,
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 20),
             ),
           );

  final TokenManager _tokenManager;
  final VoidCallback onSessionExpired;

  /// Dio without interceptors, used for the refresh call and the retries so
  /// they don't go through this interceptor again.
  final Dio _dio;

  /// The refresh currently in progress, shared by all requests that got 401.
  Future<_RefreshOutcome>? _ongoingRefresh;

  static const _wasRetriedKey = 'wasRetried';
  static const _refreshPath = '/auth/refresh-token';

  /// Matched against the end of the request path, so `/auth/login` also
  /// matches `/v1/auth/login` but not `/auth/login-history`.
  static const List<String> _whitelistRoutes = [
    '/auth/login',
    _refreshPath,
    '/auth/logout',
  ];

  /// Status codes from the refresh endpoint that mean the refresh token is
  /// no longer valid.
  static const _refreshRejectedCodes = {400, 401, 403};

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final sentHeader = options.headers['Authorization'];
    final sentWithBearer =
        sentHeader is String && sentHeader.startsWith('Bearer ');
    final isUnauthorized = err.response?.statusCode == 401;
    final isWhitelisted = _whitelistRoutes.any(options.uri.path.endsWith);

    if (EnvConfig.useMockAuth ||
        !isUnauthorized ||
        !sentWithBearer ||
        isWhitelisted) {
      handler.next(err);
      return;
    }

    // Still 401 with a freshly renewed token: the session is not valid.
    if (options.extra[_wasRetriedKey] == true) {
      _expireSession('request rejected after token refresh');
      handler.next(err);
      return;
    }

    final currentToken = await _tokenManager.getAccessToken();
    final sentWithOlderToken =
        currentToken != null && sentHeader != 'Bearer $currentToken';

    final String? token;
    if (sentWithOlderToken) {
      // Another request already refreshed the token while this one was
      // in flight; just retry with the current one.
      token = currentToken;
    } else {
      final outcome = await (_ongoingRefresh ??= _refresh().whenComplete(
        () => _ongoingRefresh = null,
      ));
      token = outcome == _RefreshOutcome.refreshed
          ? await _tokenManager.getAccessToken()
          : null;
    }

    if (token == null) {
      handler.next(err);
      return;
    }

    await _retry(options, token, err, handler);
  }

  Future<void> _retry(
    RequestOptions options,
    String token,
    DioException originalError,
    ErrorInterceptorHandler handler,
  ) async {
    options.headers['Authorization'] = 'Bearer $token';
    options.extra[_wasRetriedKey] = true;
    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _expireSession('request rejected after token refresh');
      }
      handler.next(e);
    } on Object catch (e) {
      AppLogger.e('RefreshTokenInterceptor | retry failed: $e');
      handler.next(originalError);
    }
  }

  Future<_RefreshOutcome> _refresh() async {
    final refreshToken = await _tokenManager.getRefreshToken();
    final sub = await _tokenManager.getUserSub();
    if (refreshToken == null || refreshToken.isEmpty) {
      _expireSession('no refresh token stored');
      return _RefreshOutcome.sessionExpired;
    }

    try {
      final result = await _dio.post<Map<String, dynamic>>(
        _refreshPath,
        data: {'sub': sub, 'refresh_token': refreshToken},
      );
      final data = result.data ?? const <String, dynamic>{};

      final accessToken = data['access_token'];
      if (accessToken is! String || accessToken.isEmpty) {
        _expireSession('access_token missing in refresh response');
        return _RefreshOutcome.sessionExpired;
      }
      await _tokenManager.saveAccessToken(accessToken);

      // Save the new refresh token if the server rotates it.
      final newRefreshToken = data['refresh_token'];
      if (newRefreshToken is String && newRefreshToken.isNotEmpty) {
        await _tokenManager.saveRefreshToken(newRefreshToken);
      }
      return _RefreshOutcome.refreshed;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (_refreshRejectedCodes.contains(status)) {
        _expireSession('refresh rejected with $status');
        return _RefreshOutcome.sessionExpired;
      }
      AppLogger.e('RefreshTokenInterceptor | refresh failed (transient): $e');
      return _RefreshOutcome.transientError;
    } on Object catch (e) {
      AppLogger.e('RefreshTokenInterceptor | refresh failed (transient): $e');
      return _RefreshOutcome.transientError;
    }
  }

  void _expireSession(String reason) {
    AppLogger.i('RefreshTokenInterceptor | session expired: $reason');
    onSessionExpired();
  }
}
