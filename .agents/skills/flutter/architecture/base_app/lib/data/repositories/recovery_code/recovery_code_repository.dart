import 'dart:async';

import 'package:dio/dio.dart';
import 'package:gse_base_app/core/environments/env_config.dart';
import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/dio_exception_mapper.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/recovery_code/recovery_code_failures.dart';

class RecoveryCodeRepository {
  RecoveryCodeRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<void, RecoveryCodeFailure>> requestRecoveryCode({
    required String email,
  }) async {
    try {
      final body = {'email': email};

      await _apiClient.post<void>(
        '${EnvConfig.apiUrl}/auth/password-recovery-code',
        data: body,
      );

      return const Success(null);
    } catch (e, stack) {
      AppLogger.e('RecoveryCodeRepository error', error: e, stackTrace: stack);

      if (e is DioException) {
        return mapDioToFailure(
          e,
          networkError: RecoveryCodeFailure.networkError,
          serverError: RecoveryCodeFailure.serverError,
          unknownError: RecoveryCodeFailure.unknownError,
          statusOverrides: {
            404: RecoveryCodeFailure.userNotFound,
          },
        );
      }

      return const Failure(RecoveryCodeFailure.unknownError);
    }
  }

  Future<Result<void, RecoveryCodeFailure>> updatePassword({
    required String email,
    required String newPassword,
    required String code,
  }) async {
    try {
      final body = {
        'email': email,
        'confirmation_code': code,
        'new_password': newPassword,
      };

      await _apiClient.post<void>(
        '${EnvConfig.apiUrl}/auth/recovery-password',
        data: body,
      );

      return const Success(null);
    } catch (e, stack) {
      AppLogger.e('RecoveryCodeRepository error', error: e, stackTrace: stack);

      if (e is DioException) {
        return mapDioToFailure(
          e,
          networkError: RecoveryCodeFailure.networkError,
          serverError: RecoveryCodeFailure.serverError,
          unknownError: RecoveryCodeFailure.unknownError,
          statusOverrides: {
            404: RecoveryCodeFailure.userNotFound,
          },
        );
      }

      return const Failure(RecoveryCodeFailure.unknownError);
    }
  }
}
