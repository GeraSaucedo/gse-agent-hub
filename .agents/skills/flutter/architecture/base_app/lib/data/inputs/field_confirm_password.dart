import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { empty, mismatch }

class ConfirmedPasswordInput
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPasswordInput.pure()
      : _password = '',
        super.pure('');

  const ConfirmedPasswordInput.dirty({
    required String password,
    required String value,
  })  : _password = password,
        super.dirty(value);

  final String _password;

  String? get errorMessage {
    if (isValid) return null;
    if (displayError == ConfirmedPasswordValidationError.empty) {
      return 'Este campo es requerido';
    }
    if (displayError == ConfirmedPasswordValidationError.mismatch) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if (value.trim().isEmpty) return ConfirmedPasswordValidationError.empty;
    if (value != _password) return ConfirmedPasswordValidationError.mismatch;
    return null;
  }
}
