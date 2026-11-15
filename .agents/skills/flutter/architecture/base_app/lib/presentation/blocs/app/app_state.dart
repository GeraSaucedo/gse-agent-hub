part of 'app_bloc.dart';

enum AppStatus { loading, loaded, failure }

@freezed
abstract class AppState with _$AppState {
  const factory({
    @Default(AppStatus.loading) AppStatus status,
    ConfigFailure? failure,
  }) = _AppState;
}
