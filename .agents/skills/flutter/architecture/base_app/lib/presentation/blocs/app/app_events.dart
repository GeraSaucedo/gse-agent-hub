part of 'app_bloc.dart';

@freezed
abstract class AppEvent with _$AppEvent {
  const factory AppEvent.getAppConfig() = GetAppConfig;
  const factory AppEvent.cleanState() = CleanState;
  const factory AppEvent.cleanError() = CleanError;
}
