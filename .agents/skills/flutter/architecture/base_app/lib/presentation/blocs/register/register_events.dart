part of 'register_bloc.dart';

@freezed
abstract class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.emailChanged(String email) = EmailChanged;
  const factory RegisterEvent.nameChanged(String name) = NameChanged;
  const factory RegisterEvent.passwordChanged(String password) =
      PasswordChanged;
  const factory RegisterEvent.formSubmitted() = FormSubmitted;
  const factory RegisterEvent.cleanState() = CleanState;
}
