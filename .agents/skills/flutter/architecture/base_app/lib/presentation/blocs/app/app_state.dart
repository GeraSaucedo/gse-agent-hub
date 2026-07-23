part of 'app_bloc.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    @Default('') String errorMessage,
    @Default(false) bool isLoading,
    @Default(false) bool dataLoaded,
  }) = _AppState;
}
