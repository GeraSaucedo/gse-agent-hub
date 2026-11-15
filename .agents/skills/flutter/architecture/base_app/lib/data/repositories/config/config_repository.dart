import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/api/error_mapping.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/config/config_failures.dart';
import 'package:gse_base_app/data/storage/user_manager.dart';

/// Loads the data the app needs right after login (profile, feature flags,
/// remote config...). `HomeScreen` waits for it before showing the home.
///
/// Template: replace the body of [getAppConfig] with the real request(s).
class ConfigRepository {
  new({
    required this._apiClient,
    required this._userManager,
  });

  // Used once the real request is added.
  // ignore: unused_field
  final ApiClient _apiClient;
  final UserManager _userManager;

  Future<Result<void, ConfigFailure>> getAppConfig() async {
    try {
      // Loads the user saved on disk into memory, so `UserManager.current`
      // is ready for the whole app.
      await _userManager.getUser();

      // Then refresh it from the server, e.g.:
      // final data = await _apiClient.get<Map<String, dynamic>>('/me');
      // await _userManager.saveUser(User.fromJson(data));
      return const Success(null);
    } catch (e, stack) {
      AppLogger.e(
        'ConfigRepository.getAppConfig',
        error: e,
        stackTrace: stack,
      );
      return Failure(
        switch (e) {
          NetworkException() => ConfigFailure.network,
          ApiHttpException(statusCode: >= 500) => ConfigFailure.server,
          _ => ConfigFailure.unknown,
        },
      );
    }
  }
}
