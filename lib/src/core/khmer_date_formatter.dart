import 'package:flutter/material.dart' show TimeOfDay;
import '../localization/kh_locale_data.dart';
import 'khmer_numerals.dart';

/// A utility class for formatting dates and times in Khmer language.
///
/// Provides methods to convert DateTime objects to Khmer formatted strings
/// with proper month names, day names, and optionally Khmer numerals.
/// Also supports Buddhist calendar year formatting.
///
/// Example usage:
/// ```dart
/// final date = DateTime.now();
/// final formatted = KhmerDateFormatter.formatDateTime(date);
/// print(formatted); // ១៥ មករា ២៥៦៧, ១០:៣០ ព្រឹក
/// ```
class KhmerDateFormatter {
  /// Khmer month names in order from January to December.
  static const List<String> khmerMonths = KhLocaleData.khmerMonths;

  /// Khmer weekday names starting from Sunday (0) to Saturday (6).
  static const List<String> khmerDays = KhLocaleData.khmerDays;

  /// Khmer labels for morning (AM) and evening (PM).
  static const List<String> amPm = [KhLocaleData.am, KhLocaleData.pm];

  /// Converts a Gregorian year to Buddhist year (CE + 543).
  ///
  /// In Cambodia, the traditional calendar follows the Buddhist Era,
  /// which is 543 years ahead of the Common Era (CE/AD).
  ///
  /// Example:
  /// ```dart
  /// final buddhistYear = KhmerDateFormatter.formatBuddhistYear(2024);
  /// print(buddhistYear); // "2567"
  /// ```
  ///
  /// @param year The Gregorian year to convert
  /// @return The Buddhist year as a string
  static String formatBuddhistYear(int year) {
    return (year + 543).toString();
  }

  /// Formats a DateTime object to a Khmer date and time string.
  ///
  /// The format follows the Khmer convention: "day month year, hour:minute period"
  /// For example: "15 មករា 2567, 10:30 ព្រឹក"
  ///
  /// @param dateTime The DateTime object to format
  /// @param useKhmerDigits Whether to use Khmer numerals (០-៩) instead of Arabic numerals
  /// @return A formatted date and time string in Khmer
  static String formatDateTime(DateTime dateTime,
      {bool useKhmerDigits = false}) {
    final day = dateTime.day;
    final month = khmerMonths[dateTime.month - 1];
    final year = formatBuddhistYear(dateTime.year);
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final amPmLabel = hour < 12 ? amPm[0] : amPm[1];

    final hour12 = hour % 12 == 0 ? 12 : hour % 12;

    final formatted = '$day $month $year, $hour12:$minute $amPmLabel';

    return useKhmerDigits ? KhmerNumerals.convert(formatted) : formatted;
  }

  /// Formats a DateTime object to a Khmer date string (without time).
  ///
  /// The format follows the Khmer convention: "day month year"
  /// For example: "15 មករា 2567"
  ///
  /// @param date The DateTime object to format
  /// @param useKhmerDigits Whether to use Khmer numerals (០-៩) instead of Arabic numerals
  /// @return A formatted date string in Khmer
  static String formatDate(DateTime date, {bool useKhmerDigits = false}) {
    final day = date.day;
    final month = khmerMonths[date.month - 1];
    final year = formatBuddhistYear(date.year);

    final formatted = '$day $month $year';

    return useKhmerDigits ? KhmerNumerals.convert(formatted) : formatted;
  }

  /// Formats a DateTime object to a full Khmer date string with weekday.
  ///
  /// The format follows the Khmer convention: "weekday day month year"
  /// For example: "ថ្ងៃអាទិត្យ 15 មករា 2567"
  ///
  /// @param date The DateTime object to format
  /// @param useKhmerDigits Whether to use Khmer numerals (០-៩) instead of Arabic numerals
  /// @return A formatted date string with weekday in Khmer
  static String formatDateWithWeekday(DateTime date,
      {bool useKhmerDigits = false}) {
    final weekday = khmerDays[date.weekday % 7];
    final day = date.day;
    final month = khmerMonths[date.month - 1];
    final year = formatBuddhistYear(date.year);

    final formatted = 'ថ្ងៃ$weekday $day $month $year';

    return useKhmerDigits ? KhmerNumerals.convert(formatted) : formatted;
  }

  /// Formats a TimeOfDay object to a Khmer time string.
  ///
  /// The format follows the Khmer convention: "hour:minute period"
  /// For example: "10:30 ព្រឹក"
  ///
  /// @param time The TimeOfDay object to format
  /// @param useKhmerDigits Whether to use Khmer numerals (០-៩) instead of Arabic numerals
  /// @return A formatted time string in Khmer
  static String formatTime(TimeOfDay time, {bool useKhmerDigits = false}) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final amPmLabel = hour < 12 ? amPm[0] : amPm[1];

    final hour12 = hour % 12 == 0 ? 12 : hour % 12;

    final formatted = '$hour12:$minute $amPmLabel';

    return useKhmerDigits ? KhmerNumerals.convert(formatted) : formatted;
  }
}
