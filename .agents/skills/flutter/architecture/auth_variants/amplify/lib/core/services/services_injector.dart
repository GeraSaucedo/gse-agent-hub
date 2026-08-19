import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/storage/implementations/local_storage_service.dart';
import 'package:gse_base_app/core/services/storage/implementations/secure_storage_service.dart';
import 'package:gse_base_app/core/services/storage/utils/config_manager.dart';
import 'package:gse_base_app/core/services/storage/utils/onboarding_manager.dart';
import 'package:gse_base_app/core/services/storage/utils/user_manager.dart';
import 'package:gse_base_app/main_injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    ..registerLazySingleton<ApiClient>(() => ApiClient(dio: sl()))
    ..registerLazySingleton(() => UserManager(storage: sl()))
    ..registerLazySingleton(ConfigManager.new)
    ..registerLazySingleton(() => OnboardingManager(sl()));
}
