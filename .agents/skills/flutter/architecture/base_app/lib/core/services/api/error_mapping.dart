import 'dart:convert';

import 'package:dio/dio.dart';

/// Converts a [DioException] into an [ApiException].
///
/// This is the only place where Dio errors are translated. Repositories
/// then map [ApiException] to their own feature failure with a `switch`.
ApiException mapDioError(DioException e) {
  final statusCode = e.response?.statusCode;
  final message = _describe(e);

  return switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout => NetworkException(
      message,
      isTimeout: true,
      cause: e,
    ),
    DioExceptionType.connectionError => NetworkException(message, cause: e),
    DioExceptionType.badResponse when statusCode != null => ApiHttpException(
      message,
      statusCode,
      cause: e,
    ),
    _ => UnknownApiException(message, cause: e),
  };
}

/// Everything useful for debugging in one string: the Dio error type, the
/// status and body when the server answered, and the underlying error when
/// it didn't (e.g. `SocketException: Failed host lookup`), which is the only
/// clue for network and certificate problems.
String _describe(DioException e) {
  final response = e.response;
  final dioMessage = e.message;
  final cause = e.error;
  return [
    e.type.name,
    if (response != null)
      '(${response.statusCode ?? 'No code'}) ${_formatBody(response.data)}',
    if (dioMessage != null && dioMessage.isNotEmpty) dioMessage,
    if (cause != null) '$cause',
  ].join(' | ');
}

String _formatBody(Object? data) => switch (data) {
  null => '',
  final String text => text,
  _ => const JsonEncoder.withIndent('  ').convert(data),
};

/// Error thrown by [ApiClient].
///
/// [message] is technical (Dio type, status, body and underlying error),
/// meant for logs only. The text shown to the user belongs in the UI, via
/// l10n. [cause] keeps the original error (usually the [DioException], with
/// its request options and stack trace) for the debugger.
sealed class ApiException implements Exception {
  const new(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() {
    // Not `runtimeType`: class names are obfuscated in release builds.
    final name = switch (this) {
      NetworkException() => 'NetworkException',
      ApiHttpException() => 'ApiHttpException',
      UnknownApiException() => 'UnknownApiException',
    };
    return '$name: $message';
  }
}

/// The server could not be reached: no connection or timeout.
final class NetworkException extends ApiException {
  const new(super.message, {this.isTimeout = false, super.cause});

  final bool isTimeout;
}

/// The server responded with an error status code (4xx, 5xx).
final class ApiHttpException extends ApiException {
  const new(super.message, this.statusCode, {super.cause});

  final int statusCode;
}

/// Anything else: cancelled request, bad certificate, unexpected error.
final class UnknownApiException extends ApiException {
  const new(super.message, {super.cause});
}
