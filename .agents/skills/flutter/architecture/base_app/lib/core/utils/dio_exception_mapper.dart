import 'package:dio/dio.dart';
import 'package:gse_base_app/core/utils/result.dart';

Result<Never, E> mapDioToFailure<E extends Exception>(
  DioException e, {
  required E networkError,
  required E serverError,
  required E unknownError,
  Map<int, E>? statusOverrides,
}) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.connectionError) {
    return Failure(networkError);
  }

  final statusCode = e.response?.statusCode ?? 0;

  final override = statusOverrides?[statusCode];
  if (override != null) return Failure(override);

  return switch (statusCode) {
    >= 500 => Failure(serverError),
    _ => Failure(unknownError),
  };
}
