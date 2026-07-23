import 'dart:convert';

import 'package:dio/dio.dart';

ApiException mapDioError(DioException e) {
  final statusCode = e.response?.statusCode;
  final responseData = e.response?.data ?? <String, dynamic>{};
  final body = responseData is String
      ? responseData
      : const JsonEncoder.withIndent('  ').convert(responseData);
  final statusCodeLabel = statusCode != null ? '($statusCode)' : '(No code)';
  final message = '$statusCodeLabel $body';

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const TimeoutException();
    case DioExceptionType.connectionError:
      return const NoInternetException();
    case DioExceptionType.badResponse:
      return switch (statusCode) {
        400 => BadRequestException(message),
        401 => UnauthorizedException(message),
        403 => ForbiddenException(message),
        404 => NotFoundException(message),
        409 => ConflictException(message),
        final code? when code >= 500 => ServerException(message),
        _ => UnknownException(message),
      };
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return UnknownException(message);
  }
}

abstract class ApiException implements Exception {
  const ApiException(this.message, [this.statusCode, this.code = '']);

  final String message;
  final int? statusCode;
  final String code;

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  const BadRequestException(String message, [String code = ''])
    : super(message, 400, code);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(String message, [String code = ''])
    : super(message, 401, code);
}

class ForbiddenException extends ApiException {
  const ForbiddenException(String message, [String code = ''])
    : super(message, 403, code);
}

class NotFoundException extends ApiException {
  const NotFoundException(String message, [String code = ''])
    : super(message, 404, code);
}

class ConflictException extends ApiException {
  const ConflictException(String message, [String code = ''])
    : super(message, 409, code);
}

class ServerException extends ApiException {
  const ServerException(String message, [String code = ''])
    : super(message, 500, code);
}

class UnknownException extends ApiException {
  const UnknownException([super.message = 'Unknown error occurred']);
}

class NoInternetException extends ApiException {
  const NoInternetException([
    String message =
        'No fue posible conectar con el servidor No internet error',
  ]) : super(message, null, 'NO_INTERNET');
}

class TimeoutException extends ApiException {
  const TimeoutException([String message = 'La conexión ha expirado'])
    : super(message, null, 'TIMEOUT');
}

class NetworkException extends ApiException {
  const NetworkException([String message = 'Error de red'])
    : super(message, null, 'NETWORK_ERROR');
}
