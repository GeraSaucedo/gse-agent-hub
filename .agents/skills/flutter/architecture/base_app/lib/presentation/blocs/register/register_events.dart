part of 'register_bloc.dart';

@freezed
abstract class RegisterEvent with _$RegisterEvent {
  const factory emailChanged(String email) = EmailChanged;
  const factory nameChanged(String name) = NameChanged;
  const factory passwordChanged(String password) = PasswordChanged;
  const factory formSubmitted() = FormSubmitted;

  /// Sent after the email is verified: logs in with the registered
  /// email and password.
  const factory autoLoginRequested() = AutoLoginRequested;
  const factory cleanState() = CleanState;
}
