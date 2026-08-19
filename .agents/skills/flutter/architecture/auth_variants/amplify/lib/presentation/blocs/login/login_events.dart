part of 'login_bloc.dart';

@freezed
abstract class LoginEvent with _$LoginEvent {
  const factory LoginEvent.emailChanged(String email) = EmailChanged;
  const factory LoginEvent.passwordChanged(String password) = PasswordChanged;
  const factory LoginEvent.formSubmitted() = FormSubmitted;
  const factory LoginEvent.googleSignInRequested() = GoogleSignInRequested;
  const factory LoginEvent.appleSignInRequested() = AppleSignInRequested;
  const factory LoginEvent.cleanState() = CleanState;
}
