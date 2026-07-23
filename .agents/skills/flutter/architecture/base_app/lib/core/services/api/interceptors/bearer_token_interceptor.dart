import 'package:dio/dio.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/services/storage/utils/token_manager.dart';

class BearerTokenInterceptor extends Interceptor {
  BearerTokenInterceptor(this._tokenManager);

  final TokenManager _tokenManager;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.headers.containsKey('Authorization')) {
      try {
        final accessToken = await _tokenManager.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
      } catch (e) {
        AppLogger.e('BearerTokenInterceptor: error getting token: $e');
      }
    }
    handler.next(options);
  }
}
