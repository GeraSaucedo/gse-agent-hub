import 'dart:async';

import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/api/error_mapping.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/recovery_code/recovery_code_failures.dart';

class RecoveryCodeRepository {
  new({
    required this._apiClient,
  });

  final ApiClient _apiClient;

  Future<Result<void, RecoveryCodeFailure>> requestRecoveryCode({
    required String email,
  }) async {
    try {
      final body = {'email': email};

      await _apiClient.post<void>(
        '/auth/password-recovery-code',
        data: body,
      );

      return const Success(null);
    } catch (e, stack) {
      AppLogger.e(
        'RecoveryCodeRepository.requestRecoveryCode',
        error: e,
        stackTrace: stack,
      );

      return Failure(_toFailure(e));
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
        '/auth/recovery-password',
        data: body,
      );

      return const Success(null);
    } catch (e, stack) {
      AppLogger.e(
        'RecoveryCodeRepository.updatePassword',
        error: e,
        stackTrace: stack,
      );

      return Failure(_toFailure(e));
    }
  }

  RecoveryCodeFailure _toFailure(Object e) => switch (e) {
    NetworkException() => RecoveryCodeFailure.network,
    ApiHttpException(statusCode: 404) => RecoveryCodeFailure.userNotFound,
    ApiHttpException(statusCode: >= 500) => RecoveryCodeFailure.server,
    _ => RecoveryCodeFailure.unknown,
  };
}
