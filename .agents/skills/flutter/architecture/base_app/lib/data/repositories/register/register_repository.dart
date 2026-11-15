import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/api/error_mapping.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/register/register_failures.dart';

class RegisterRepository {
  new({
    required this._apiClient,
  });

  final ApiClient _apiClient;

  Future<Result<void, RegisterFailure>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      await _apiClient.post<void>(
        '/auth/register',
        data: {
          'email': email,
          'name': name,
          'password': password,
        },
      );

      return const Success(null);
    } catch (e, stack) {
      AppLogger.e(
        'RegisterRepository.register',
        error: e,
        stackTrace: stack,
      );

      return Failure(
        switch (e) {
          NetworkException() => RegisterFailure.network,
          ApiHttpException(statusCode: 409) =>
            RegisterFailure.emailAlreadyExists,
          ApiHttpException(statusCode: 400) => RegisterFailure.invalidData,
          ApiHttpException(statusCode: >= 500) => RegisterFailure.server,
          _ => RegisterFailure.unknown,
        },
      );
    }
  }
}
