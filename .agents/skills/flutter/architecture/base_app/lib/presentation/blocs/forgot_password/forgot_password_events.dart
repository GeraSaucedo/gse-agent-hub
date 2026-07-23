part of 'forgot_password_bloc.dart';

@freezed
abstract class ForgotPasswordEvent with _$ForgotPasswordEvent {
  const factory ForgotPasswordEvent.emailChanged(String email) =
      EmailChanged;
  const factory ForgotPasswordEvent.passwordChanged(String password) =
      PasswordChanged;
  const factory ForgotPasswordEvent.confirmPasswordChanged(String password) =
      ConfirmPasswordChanged;
  const factory ForgotPasswordEvent.codeChanged(String code) = CodeChanged;
  const factory ForgotPasswordEvent.formSubmitted() = FormSubmitted;
  const factory ForgotPasswordEvent.codeRequested() = CodeRequested;
  const factory ForgotPasswordEvent.cleanState() = CleanState;
}
