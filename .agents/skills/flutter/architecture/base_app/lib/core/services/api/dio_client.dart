import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gse_base_app/core/services/api/error_mapping.dart';
import 'package:gse_base_app/core/services/api/interceptors/bearer_token_interceptor.dart';
import 'package:gse_base_app/core/services/api/interceptors/logger_interceptor.dart';
import 'package:gse_base_app/core/services/api/interceptors/refresh_token_interceptor.dart';
import 'package:gse_base_app/core/services/storage/utils/token_manager.dart';

/// A client for making HTTP requests to a REST API.
///
/// This client handles authentication, request formation, and response parsing.
class ApiClient {
  /// Creates an [ApiClient] instance.
  ///
  /// [_dio] and [tokenManager] are required and allow for dependency injection.
  /// [onRefreshFailed] is called when token refresh fails (e.g. force logout).
  ApiClient({
    required this._dio,
    required TokenManager tokenManager,
    required VoidCallback onRefreshFailed,
  }) {
    _dio.options
      ..connectTimeout = const Duration(seconds: 30)
      ..sendTimeout = const Duration(minutes: 5)
      ..receiveTimeout = const Duration(minutes: 3);
    _dio.interceptors.add(
      RefreshTokenInterceptor(tokenManager, onRefreshFailed: onRefreshFailed),
    );
    _dio.interceptors.add(BearerTokenInterceptor(tokenManager));
    if (kDebugMode) _dio.interceptors.add(LoggerInterceptor());
  }

  final Dio _dio;

  Future<T> _request<T>({
    required HttpMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    try {
      final response = await _dio.request<T>(
        path,
        options: Options(
          method: method.name.toUpperCase(),
          headers: headers,
        ),
        queryParameters: queryParameters,
        data: data,
      );

      return response.data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) => _request<T>(
    method: HttpMethod.get,
    path: path,
    queryParameters: queryParameters,
    headers: headers,
  );

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) => _request<T>(
    method: HttpMethod.post,
    path: path,
    data: data,
    queryParameters: queryParameters,
    headers: headers,
  );

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) => _request<T>(
    method: HttpMethod.put,
    path: path,
    data: data,
    queryParameters: queryParameters,
    headers: headers,
  );

  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) => _request<T>(
    method: HttpMethod.patch,
    path: path,
    data: data,
    queryParameters: queryParameters,
    headers: headers,
  );

  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) => _request<T>(
    method: HttpMethod.delete,
    path: path,
    data: data,
    queryParameters: queryParameters,
    headers: headers,
  );
}

/// Enumeration of HTTP methods supported by the API client.
enum HttpMethod { get, post, put, patch, delete }
