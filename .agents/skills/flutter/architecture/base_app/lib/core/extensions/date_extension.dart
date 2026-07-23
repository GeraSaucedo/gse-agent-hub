import 'package:intl/intl.dart';

/// DateTime formatting extensions for human-readable display.
///
/// All formats use Spanish locale as the application does not
/// support internationalization.
extension AppDateTimeExt on DateTime {
  /// Formats date in long readable format.
  ///
  /// Example: `15 de enero de 2025`
  String toReadableDate({bool withYear = true}) {
    if (!withYear) {
      return DateFormat.MMMMd('es').format(this);
    }

    return DateFormat.yMMMMd('es').format(this);
  }

  /// Formats time in 24-hour format.
  ///
  /// Example: `14:30`
  String toReadableTime() {
    return DateFormat('HH:mm', 'es').format(this);
  }

  String toShortDate() {
    return DateFormat('dd/MMM - HH:mm', 'es').format(this);
  }

  /// Formats date in numeric DD/MM/YYYY format.
  ///
  /// Example: `10/11/2025`
  String toNumericDMY() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String toLongNumberFormat() {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    final year = this.year.toString();
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    final second = this.second.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute:$second';
  }
}

/// String parsing extensions for DateTime conversion.
///
/// Handles common Spanish date formats used in the application.
extension AppStringDateExt on String {
  /// Parses a date string in DD/MM/YYYY format to DateTime.
  ///
  /// Example: `"16/06/2024"` -> DateTime(2024, 6, 16)
  ///
  /// Throws [FormatException] if the string cannot be parsed.
  DateTime toDateTime() {
    return DateFormat('dd/MM/yyyy').parse(this);
  }
}
