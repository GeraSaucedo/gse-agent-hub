// login_state.dart
part of 'forgot_password_bloc.dart';

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(EmailInput.pure()) EmailInput email,
    @Default(PasswordInput.pure()) PasswordInput newPassword,
    @Default(ConfirmedPasswordInput.pure())
    ConfirmedPasswordInput confirmedNewPassword,
    @Default('') String code,
    RecoveryCodeFailure? failure,
  }) = _ForgotPasswordState;
}
