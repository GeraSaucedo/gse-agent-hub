import 'package:gse_base_app/core/environments/env_config.dart';
import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/api_failure_mapper.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/register/register_failures.dart';

class RegisterRepository {
  RegisterRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<void, RegisterFailure>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      await _apiClient.post<void>(
        '${EnvConfig.apiUrl}/auth/register',
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

      return mapApiErrorToFailure(
        e,
        networkError: RegisterFailure.networkError,
        serverError: RegisterFailure.serverError,
        unknownError: RegisterFailure.unknownError,
        statusOverrides: {
          409: RegisterFailure.emailAlreadyExists,
          400: RegisterFailure.invalidData,
        },
      );
    }
  }
}
