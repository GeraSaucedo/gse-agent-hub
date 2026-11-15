import 'dart:async';

import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/api/error_mapping.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/verify_email/verify_email_failures.dart';

class VerifyEmailRepository {
  new({
    required this._apiClient,
  });

  final ApiClient _apiClient;

  Future<Result<void, VerifyEmailFailure>> sendVerificationCode({
    required String email,
  }) async {
    try {
      await _apiClient.post<void>(
        '/auth/email-recovery-code',
        data: {'email': email},
      );

      return const Success(null);
    } catch (e, stack) {
      AppLogger.e(
        'VerifyEmailRepository.sendVerificationCode',
        error: e,
        stackTrace: stack,
      );

      return Failure(_toFailure(e));
    }
  }

  Future<Result<void, VerifyEmailFailure>> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      await _apiClient.post<void>(
        '/auth/verify-email',
        data: {
          'email': email,
          'confirmation_code': code,
        },
      );

      return const Success(null);
    } catch (e, stack) {
      AppLogger.e(
        'VerifyEmailRepository.verifyEmail',
        error: e,
        stackTrace: stack,
      );

      return Failure(
        switch (e) {
          ApiHttpException(statusCode: 400) => VerifyEmailFailure.invalidCode,
          _ => _toFailure(e),
        },
      );
    }
  }

  /// Mapping shared by every method; each method adds its own cases first.
  VerifyEmailFailure _toFailure(Object e) => switch (e) {
    NetworkException() => VerifyEmailFailure.network,
    ApiHttpException(statusCode: >= 500) => VerifyEmailFailure.server,
    _ => VerifyEmailFailure.unknown,
  };
}
