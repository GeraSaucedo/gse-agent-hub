part of 'login_bloc.dart';

@freezed
abstract class LoginEvent with _$LoginEvent {
  const factory emailChanged(String email) = EmailChanged;
  const factory passwordChanged(String password) = PasswordChanged;
  const factory formSubmitted() = FormSubmitted;
  const factory cleanState() = CleanState;
}
