part of 'forgot_password_bloc.dart';

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory({
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(EmailInput.pure()) EmailInput email,
    @Default(PasswordInput.pure()) PasswordInput newPassword,
    @Default(ConfirmedPasswordInput.pure())
    ConfirmedPasswordInput confirmedNewPassword,
    @Default('') String code,
    RecoveryCodeFailure? failure,

    /// A recovery-code request is in flight (step 1 and "resend").
    @Default(false) bool requestingCode,

    /// Bumped on every code sent successfully: step 1 moves on only then.
    @Default(0) int codesSent,
  }) = _ForgotPasswordState;
}
