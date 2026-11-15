part of 'forgot_password_bloc.dart';

@freezed
abstract class ForgotPasswordEvent with _$ForgotPasswordEvent {
  const factory emailChanged(String email) = EmailChanged;
  const factory passwordChanged(String password) = PasswordChanged;
  const factory confirmPasswordChanged(String password) =
      ConfirmPasswordChanged;
  const factory codeChanged(String code) = CodeChanged;
  const factory formSubmitted() = FormSubmitted;
  const factory codeRequested() = CodeRequested;
  const factory cleanState() = CleanState;
}
