part of 'app_bloc.dart';

@freezed
abstract class AppEvent with _$AppEvent {
  const factory getAppConfig() = GetAppConfig;
  const factory cleanState() = CleanState;
}
