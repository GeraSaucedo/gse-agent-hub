import 'package:formz/formz.dart';

enum UsernameValidationError { empty }

class UsernameInput extends FormzInput<String, UsernameValidationError> {
  const UsernameInput.pure() : super.pure('');
  const UsernameInput.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid) return null;
    if (displayError == UsernameValidationError.empty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  @override
  UsernameValidationError? validator(String value) {
    if (value.trim().isEmpty) return UsernameValidationError.empty;
    return null;
  }
}
