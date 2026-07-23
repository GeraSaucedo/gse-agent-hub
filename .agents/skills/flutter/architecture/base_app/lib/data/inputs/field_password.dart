import 'package:formz/formz.dart';

// Define input validation errors
enum PasswordValidationError {
  empty,
  length,
  number,
  lowercase,
  uppercase,
  specialChar,
}

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.dirty(super.value, {this.onlyEmptyValidation = false})
    : super.dirty();

  const PasswordInput.pure({this.onlyEmptyValidation = false}) : super.pure('');
  static const int _minPasswordLength = 8;

  final bool onlyEmptyValidation;

  String? get errorMessage {
    if (isValid) return null;

    if (displayError == PasswordValidationError.empty) {
      return 'Este campo es requerido';
    }

    if (onlyEmptyValidation) return null;

    if (displayError == PasswordValidationError.length) {
      return 'Debe tener al menos $_minPasswordLength caracteres';
    }

    if (displayError == PasswordValidationError.number) {
      return 'Debe tener al menos 1 número';
    }

    if (displayError == PasswordValidationError.lowercase) {
      return 'Debe tener al menos 1 letra minúscula';
    }

    if (displayError == PasswordValidationError.uppercase) {
      return 'Debe tener al menos 1 letra mayúscula';
    }

    if (displayError == PasswordValidationError.specialChar) {
      return 'Debe tener al menos 1 carácter especial o espacio';
    }

    return null;
  }

  @override
  PasswordValidationError? validator(String value) {
    if (value.trim().isEmpty) return PasswordValidationError.empty;
    if (onlyEmptyValidation) return null;

    if (value.length < _minPasswordLength) {
      return PasswordValidationError.length;
    }

    if (!RegExp('[0-9]').hasMatch(value)) {
      return PasswordValidationError.number;
    }

    if (!RegExp('[a-zá-úñ]').hasMatch(value)) {
      return PasswordValidationError.lowercase;
    }

    if (!RegExp('[A-ZÁ-ÚÑ]').hasMatch(value)) {
      return PasswordValidationError.uppercase;
    }

    final specialCharRegex = RegExp(
      r'^(?=.*[$\[\]{}()?!\-@#%&/\\,><;|_~^=+\.])',
    );
    final quoteRegex = RegExp("'");
    final doubleQuoteRegex = RegExp('"');

    if (!specialCharRegex.hasMatch(value) &&
        !quoteRegex.hasMatch(value) &&
        !doubleQuoteRegex.hasMatch(value)) {
      return PasswordValidationError.specialChar;
    }

    return null;
  }
}
