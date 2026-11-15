import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';
import 'package:gse_base_app/data/repositories/config/config_failures.dart';
import 'package:gse_base_app/data/repositories/config/config_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_bloc.freezed.dart';
part 'app_events.dart';
part 'app_state.dart';

/// Loads the data the app needs after login (see [ConfigRepository]).
class AppBloc extends Bloc<AppEvent, AppState> {
  new({
    required this._configRepository,
    required AuthRepository authRepository,
  }) : super(const AppState()) {
    on<GetAppConfig>(_onGetAppConfig);
    on<CleanState>(_onCleanState);

    // Reset whenever the session ends (manual or forced logout), so the next
    // login loads the data again and a stale error isn't shown.
    _authSubscription = authRepository.authStatusStream
        .where((status) => status == AuthStatus.unauthenticated)
        .listen((_) => add(const CleanState()));
  }

  final ConfigRepository _configRepository;
  late final StreamSubscription<AuthStatus> _authSubscription;

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    await super.close();
  }

  Future<void> _onGetAppConfig(
    GetAppConfig event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppState());

    switch (await _configRepository.getAppConfig()) {
      case Success():
        emit(state.copyWith(status: AppStatus.loaded));
      case Failure(:final exception):
        emit(state.copyWith(status: AppStatus.failure, failure: exception));
    }
  }

  void _onCleanState(CleanState event, Emitter<AppState> emit) {
    emit(const AppState());
  }
}
