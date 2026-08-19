import 'dart:async';

import 'package:dio/dio.dart';
import 'package:gse_base_app/core/environments/env_config.dart';
import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/dio_exception_mapper.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/verify_email/verify_email_failures.dart';

class VerifyEmailRepository {
  VerifyEmailRepository({
    required this._apiClient,
  });

  final ApiClient _apiClient;

  Future<Result<void, VerifyEmailFailure>> sendVerificationCode({
    required String email,
  }) async {
    try {
      await _apiClient.post<void>(
        '${EnvConfig.apiUrl}/auth/email-recovery-code',
        data: {'email': email},
      );

      return const Success(null);
    } catch (e, stack) {
      AppLogger.e(
        'VerifyEmailRepository.sendVerificationCode',
        error: e,
        stackTrace: stack,
      );

      if (e is DioException) {
        return mapDioToFailure(
          e,
          networkError: VerifyEmailFailure.networkError,
          serverError: VerifyEmailFailure.serverError,
          unknownError: VerifyEmailFailure.unknownError,
        );
      }

      return const Failure(VerifyEmailFailure.unknownError);
    }
  }

  Future<Result<void, VerifyEmailFailure>> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      await _apiClient.post<void>(
        '${EnvConfig.apiUrl}/auth/verify-email',
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

      if (e is DioException) {
        return mapDioToFailure(
          e,
          networkError: VerifyEmailFailure.networkError,
          serverError: VerifyEmailFailure.serverError,
          unknownError: VerifyEmailFailure.unknownError,
          statusOverrides: {
            400: VerifyEmailFailure.invalidCode,
          },
        );
      }

      return const Failure(VerifyEmailFailure.unknownError);
    }
  }
}
