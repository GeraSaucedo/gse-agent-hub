import 'package:gse_base_app/main_injector.dart';
import 'package:gse_base_app/presentation/blocs/app/app_bloc.dart';
import 'package:gse_base_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:gse_base_app/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:gse_base_app/presentation/blocs/login/login_bloc.dart';
import 'package:gse_base_app/presentation/blocs/register/register_bloc.dart';
import 'package:gse_base_app/presentation/blocs/verify_email/verify_email_bloc.dart';

void blocInjector() {
  sl
    ..registerFactory(
      () => LoginBloc(
        repository: sl(),
      ),
    )
    ..registerLazySingleton(() => AuthCubit(sl()))
    ..registerFactory(
      () => AppBloc(
        configRepository: sl(),
      ),
    )
    ..registerFactory(
      () => ForgotPasswordBloc(
        repository: sl(),
      ),
    )
    ..registerFactory(
      () => VerifyEmailBloc(
        repository: sl(),
        authRepository: sl(),
      ),
    )
    ..registerFactory(
      () => RegisterBloc(
        repository: sl(),
      ),
    );
}
