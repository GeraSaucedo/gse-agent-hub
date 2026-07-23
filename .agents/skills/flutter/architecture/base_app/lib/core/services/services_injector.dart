import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/services/storage/implementations/local_storage_service.dart';
import 'package:gse_base_app/core/services/storage/implementations/secure_storage_service.dart';
import 'package:gse_base_app/core/services/storage/utils/config_manager.dart';
import 'package:gse_base_app/core/services/storage/utils/onboarding_manager.dart';
import 'package:gse_base_app/core/services/storage/utils/token_manager.dart';
import 'package:gse_base_app/core/services/storage/utils/user_manager.dart';
import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';
import 'package:gse_base_app/main_injector.dart';

/// Services that can be used in the app,
///
/// This method helps to inject the dependencies related to the services.
Future<void> servicesInjector() async {
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
        onRefreshFailed: () {
          AppLogger.i('Failed on renew token');
          sl<AuthRepository>().forceLogout();
        },
        tokenManager: sl(),
      ),
    )
    ..registerLazySingleton(() => UserManager(storage: sl()))
    ..registerLazySingleton(ConfigManager.new)
    ..registerLazySingleton(() => OnboardingManager(sl()));
}
