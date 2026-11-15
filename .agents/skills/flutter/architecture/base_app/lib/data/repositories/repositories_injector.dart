import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';
import 'package:gse_base_app/data/repositories/config/config_repository.dart';
import 'package:gse_base_app/data/repositories/example/example_repository.dart';
import 'package:gse_base_app/data/repositories/recovery_code/recovery_code_repository.dart';
import 'package:gse_base_app/data/repositories/register/register_repository.dart';
import 'package:gse_base_app/data/repositories/verify_email/verify_email_repository.dart';
import 'package:gse_base_app/data/storage/user_manager.dart';
import 'package:gse_base_app/main_injector.dart';

void repositoriesInjector() {
  sl
    ..registerLazySingleton(() => UserManager(storage: sl()))
    ..registerLazySingleton(
      () => AuthRepository(
        apiClient: sl(),
        tokenManager: sl(),
        userManager: sl(),
      ),
      dispose: (repository) => repository.dispose(),
    )
    ..registerLazySingleton(
      () => ConfigRepository(
        apiClient: sl(),
        userManager: sl(),
      ),
    )
    ..registerLazySingleton(
      () => ExampleRepository(
        apiClient: sl(),
      ),
    )
    ..registerLazySingleton(
      () => RecoveryCodeRepository(
        apiClient: sl(),
      ),
    )
    ..registerLazySingleton(
      () => VerifyEmailRepository(
        apiClient: sl(),
      ),
    )
    ..registerLazySingleton(
      () => RegisterRepository(
        apiClient: sl(),
      ),
    );
}
