import 'package:dio/dio.dart';
import 'package:gse_base_app/core/di/service_locator.dart';
import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/services/storage/implementations/local_storage_service.dart';
import 'package:gse_base_app/core/services/storage/implementations/secure_storage_service.dart';
import 'package:gse_base_app/core/services/storage/utils/config_manager.dart';
import 'package:gse_base_app/core/services/storage/utils/onboarding_manager.dart';
import 'package:gse_base_app/core/services/storage/utils/token_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Services that can be used in the app,
///
/// This method helps to inject the dependencies related to the services.
///
/// [onSessionExpired] is wired in `main_injector.dart`, so `core` does not
/// depend on `data` (e.g. `AuthRepository`).
Future<void> servicesInjector({
  required void Function() onSessionExpired,
}) async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton(() => sharedPreferences)
    ..registerLazySingleton(Dio.new)
    ..registerLazySingleton(FlutterSecureStorage.new)
    // INTERNAL
    ..registerLazySingleton(() => SecureStorageService(secureStorage: sl()))
    ..registerLazySingleton(() => LocalStorageService(storage: sl()))
    ..registerLazySingleton(() => TokenManager(sl()))
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        dio: sl(),
        onSessionExpired: () {
          AppLogger.i('Session expired, forcing logout');
          onSessionExpired();
        },
        tokenManager: sl(),
      ),
    )
    ..registerLazySingleton(ConfigManager.new)
    ..registerLazySingleton(() => OnboardingManager(sl()));

  // Before anything reads the session (iOS keeps tokens after uninstalling).
  try {
    await sl<TokenManager>().clearTokensIfFreshInstall(
      sl<LocalStorageService>(),
    );
  } catch (e, stack) {
    AppLogger.e(
      'Error clearing a previous session',
      error: e,
      stackTrace: stack,
    );
  }
}
