import 'package:intl/intl.dart';

/// DateTime formatting extensions for human-readable display.
///
/// Text formats (month names) follow the app language: they use
/// `Intl.defaultLocale`, which `LocaleController` keeps in sync.
/// Numeric formats are the same in every language.
extension AppDateTimeExt on DateTime {
  /// Formats date in long readable format.
  ///
  /// Example: `15 de enero de 2025` (es) · `January 15, 2025` (en)
  String toReadableDate({bool withYear = true}) {
    if (!withYear) {
      return DateFormat.MMMMd().format(this);
    }

    return DateFormat.yMMMMd().format(this);
  }

  /// Formats time in 24-hour format.
  ///
  /// Example: `14:30`
  String toReadableTime() {
    return DateFormat('HH:mm').format(this);
  }

  /// Example: `15/ene - 14:30` (es) · `15/Jan - 14:30` (en)
  String toShortDate() {
    return DateFormat('dd/MMM - HH:mm').format(this);
  }

  /// Formats date in numeric DD/MM/YYYY format.
  ///
  /// Example: `10/11/2025`
  String toNumericDMY() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Example: `10/11/2025 14:30:05`
  String toLongNumberFormat() {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(this);
  }
}

/// String parsing extensions for DateTime conversion.
///
/// Parses the numeric formats used in the application.
extension AppStringDateExt on String {
  /// Parses a date string in DD/MM/YYYY format to DateTime.
  ///
  /// Example: `"16/06/2024"` -> DateTime(2024, 6, 16)
  ///
  /// Throws [FormatException] if the string is not a valid date in that
  /// format (e.g. `"31/02/2024"`, `"2024-06-16"` or trailing text).
  DateTime toDateTime() {
    return DateFormat('dd/MM/yyyy').parseStrict(this);
  }
}
