import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';
import 'package:gse_base_app/data/repositories/config/config_repository.dart';
import 'package:gse_base_app/data/repositories/example/example_repository.dart';
import 'package:gse_base_app/data/repositories/recovery_code/recovery_code_repository.dart';
import 'package:gse_base_app/data/repositories/register/register_repository.dart';
import 'package:gse_base_app/data/repositories/verify_email/verify_email_repository.dart';
import 'package:gse_base_app/main_injector.dart';

void repositoriesInjector() {
  sl
    ..registerLazySingleton(AuthRepository.new)
    ..registerLazySingleton(
      ConfigRepository.new,
    )
    ..registerLazySingleton(
      () => ExampleRepository(
        apiClient: sl(),
      ),
    )
    ..registerLazySingleton(RecoveryCodeRepository.new)
    ..registerLazySingleton(VerifyEmailRepository.new)
    ..registerLazySingleton(RegisterRepository.new);
}
