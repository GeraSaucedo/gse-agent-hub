import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  length,
  number,
  lowercase,
  uppercase,
  specialChar,
}

/// Password field. Only validates: the UI turns [displayError] into text
/// via l10n.
class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const new dirty(super.value, {this.onlyEmptyValidation = false})
    : super.dirty();

  const new pure({this.onlyEmptyValidation = false}) : super.pure('');
  static const int minLength = 8;

  final bool onlyEmptyValidation;

  @override
  PasswordValidationError? validator(String value) {
    if (value.trim().isEmpty) return PasswordValidationError.empty;
    if (onlyEmptyValidation) return null;

    if (value.length < minLength) {
      return PasswordValidationError.length;
    }

    if (!_digit.hasMatch(value)) return PasswordValidationError.number;
    if (!_lowercase.hasMatch(value)) return PasswordValidationError.lowercase;
    if (!_uppercase.hasMatch(value)) return PasswordValidationError.uppercase;
    if (!_specialChar.hasMatch(value)) {
      return PasswordValidationError.specialChar;
    }

    return null;
  }

  static final _digit = RegExp('[0-9]');
  static final _lowercase = RegExp(r'\p{Ll}', unicode: true);
  static final _uppercase = RegExp(r'\p{Lu}', unicode: true);

  /// Same special characters the backend accepts, plus the space.
  /// Keep it in sync with the server password policy.
  static final _specialChar = RegExp(
    r'''[\^$*.\[\]{}()?"!@#%&/\\,><':;|_~`=+\- ]''',
  );
}
