import 'package:gse_base_app/data/inputs/field_confirm_password.dart';
import 'package:gse_base_app/data/inputs/field_email.dart';
import 'package:gse_base_app/data/inputs/field_password.dart';
import 'package:gse_localization/generated/app_localizations.dart';

// Turns the validation errors of the form inputs (data/inputs) into text.
// The switches are exhaustive: a new error value does not compile until it
// gets its text here.

extension EmailValidationErrorL10n on EmailValidationError {
  String message(AppLocalizations l10n) => switch (this) {
    EmailValidationError.empty => l10n.validationRequired,
    EmailValidationError.format => l10n.validationEmailFormat,
  };
}

extension PasswordValidationErrorL10n on PasswordValidationError {
  String message(AppLocalizations l10n) => switch (this) {
    PasswordValidationError.empty => l10n.validationRequired,
    PasswordValidationError.length => l10n.validationPasswordMinLength(
      PasswordInput.minLength,
    ),
    PasswordValidationError.number => l10n.validationPasswordNumber,
    PasswordValidationError.lowercase => l10n.validationPasswordLowercase,
    PasswordValidationError.uppercase => l10n.validationPasswordUppercase,
    PasswordValidationError.specialChar => l10n.validationPasswordSpecialChar,
  };
}

extension ConfirmedPasswordValidationErrorL10n
    on ConfirmedPasswordValidationError {
  String message(AppLocalizations l10n) => switch (this) {
    ConfirmedPasswordValidationError.empty => l10n.validationRequired,
    ConfirmedPasswordValidationError.mismatch =>
      l10n.validationPasswordMismatch,
  };
}

/// Text to show under the field, or `null` while there is nothing to show.
extension EmailInputL10n on EmailInput {
  String? errorText(AppLocalizations l10n) => displayError?.message(l10n);
}

/// Text to show under the field, or `null` while there is nothing to show.
extension PasswordInputL10n on PasswordInput {
  String? errorText(AppLocalizations l10n) => displayError?.message(l10n);
}

/// Text to show under the field, or `null` while there is nothing to show.
extension ConfirmedPasswordInputL10n on ConfirmedPasswordInput {
  String? errorText(AppLocalizations l10n) => displayError?.message(l10n);
}
