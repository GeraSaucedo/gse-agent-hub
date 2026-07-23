import 'package:gse_base_app/core/services/logger/app_logger.dart';

/// Repository for initializing application configuration and
/// obtaining OAuth2 tokens.
///
/// Handles the bootstrap process of fetching authentication tokens for both
/// NetSuite and ISO/Warehouses systems using OAuth2 client_credentials flow.
/// Tokens are obtained in parallel for performance optimization.
class ConfigRepository {
  ConfigRepository(
    /* {
    required ApiClient apiClient,
    required ConfigManager configManager,
    required TokenManager tokenManager,
  } */
  ); /* : _apiClient = apiClient,
       _configManager = configManager,
       _tokenManager = tokenManager; */

  /* final ApiClient _apiClient;
  final ConfigManager _configManager;
  final TokenManager _tokenManager; */

  Future<void> getAppConfig() async {
    try {
      //  implement method to call user data or something after login
    } catch (e, stack) {
      AppLogger.e('Error on get app config', error: e, stackTrace: stack);
      rethrow;
    }
  }
}
