import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/data/repositories/config/config_repository.dart';

part 'app_bloc.freezed.dart';
part 'app_events.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required ConfigRepository configRepository,
  }) : _configRepository = configRepository,

       // Bloc events
       super(const AppState()) {
    on<GetAppConfig>(_onGetAppConfig);
    on<CleanState>(_onCleanState);
    on<CleanError>(_onCleanError);
  }

  final ConfigRepository _configRepository;

  Future<void> _onGetAppConfig(
    GetAppConfig event,
    Emitter<AppState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          dataLoaded: false,
          errorMessage: '',
        ),
      );
      // get var envs from api
      await _configRepository.getAppConfig();

      emit(
        state.copyWith(
          isLoading: false,
          dataLoaded: true,
        ),
      );
    } catch (e, stack) {
      AppLogger.e('Error on get app config bloc', error: e, stackTrace: stack);
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error al conectar con el servidor',
        ),
      );
    }
  }

  void _onCleanError(CleanError event, Emitter<AppState> emit) {
    emit(state.copyWith(errorMessage: ''));
  }

  void _onCleanState(CleanState event, Emitter<AppState> emit) {
    emit(const AppState());
  }
}
