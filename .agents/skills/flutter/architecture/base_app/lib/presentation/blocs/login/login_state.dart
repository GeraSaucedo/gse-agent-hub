part of 'login_bloc.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory({
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(EmailInput.pure()) EmailInput email,
    @Default(PasswordInput.pure()) PasswordInput password,
    AuthFailure? failure,
    @Default('') String unverifiedEmail,
  }) = _LoginState;
}

/// Derived from the state (not the bloc), so widgets rebuilt by a
/// BlocBuilder read the same snapshot they were built with.
extension LoginStateX on LoginState {
  bool get isLoading => status == FormzSubmissionStatus.inProgress;
  bool get formSubmitted => status != FormzSubmissionStatus.initial;
}
