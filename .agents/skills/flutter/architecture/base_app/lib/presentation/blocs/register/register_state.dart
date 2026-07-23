part of 'register_bloc.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(EmailInput.pure()) EmailInput email,
    @Default('') String name,
    @Default(PasswordInput.pure()) PasswordInput password,
    RegisterFailure? failure,
  }) = _RegisterState;
}
