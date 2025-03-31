import '../localization/kh_locale_data.dart';
import '../utils/date_utils.dart';

/// Utility class for parsing Khmer date strings into DateTime objects.
///
/// Provides functionality to convert Khmer formatted date strings back
/// into standard DateTime objects. Handles Khmer numerals, month names,
/// and Buddhist calendar years.
///
/// Example usage:
/// ```dart
/// final dateString = "១៥ មករា ២៥៦៧";
/// final dateTime = KhmerDateParser.parse(dateString);
/// if (dateTime != null) {
///   print(dateTime); // 2024-01-15 00:00:00.000
/// }
/// ```
class KhmerDateParser {
  /// Parses a Khmer date string into a DateTime object.
  ///
  /// Supports various common Khmer date formats, including:
  /// - "day month year"
  /// - "ថ្ងៃweekday day month year"
  /// - "day month Buddhist-year"
  ///
  /// Both Khmer and Arabic numerals are supported.
  ///
  /// Returns null if the string could not be parsed.
  ///
  /// Example:
  /// ```dart
  /// final date = KhmerDateParser.parse('១៥ មករា ២៥៦៧');
  /// final date2 = KhmerDateParser.parse('ថ្ងៃអាទិត្យ 15 មករា 2567');
  /// ```
  ///
  /// @param khmerDateString A date string in Khmer format
  /// @return DateTime object if parsing was successful, null otherwise
  static DateTime? parse(String khmerDateString) {
    try {
      // Extract numeric values using regex
      final numericValues = _extractNumericValues(khmerDateString);
      if (numericValues.isEmpty) return null;

      // Extract month name
      final month = _extractMonth(khmerDateString);
      if (month == -1) return null;

      // Initialize with null or default value
      int? buddhistYear;
      int? year;

      // Extract year (Buddhist to Gregorian)
      if (numericValues.length >= 2) {
        // Assuming the largest number is a Buddhist year
        buddhistYear = numericValues.reduce((a, b) => a > b ? a : b);
        if (buddhistYear > 2500) {
          // Likely a Buddhist year
          year = KhDateUtils.toGregorianYear(buddhistYear);
        }
      }

      // Extract day
      int? day;
      for (final num in numericValues) {
        if (num >= 1 && num <= 31) {
          day = num;
          // If we find a likely day, and it's not the same as the Buddhist year
          // that we've already identified, use it
          if (buddhistYear == null || day != buddhistYear) break;
        }
      }

      if (day == null) return null;

      if (year == null) {
        // If no year found, use current year
        return DateTime(DateTime.now().year, month, day);
      }

      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  /// Parses a Khmer date and time string into a DateTime object.
  ///
  /// Supports formats like:
  /// - "day month year, hour:minute period"
  /// - "ថ្ងៃweekday day month year, hour:minute period"
  ///
  /// Both Khmer and Arabic numerals are supported.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = KhmerDateParser.parseDateTime('១៥ មករា ២៥៦៧, ១០:៣០ ព្រឹក');
  /// ```
  ///
  /// @param khmerDateTimeString A date and time string in Khmer format
  /// @return DateTime object if parsing was successful, null otherwise
  static DateTime? parseDateTime(String khmerDateTimeString) {
    try {
      // Split the string into date and time parts
      final parts = khmerDateTimeString.split(',');
      if (parts.length < 2) return null;

      final dateString = parts[0].trim();
      final timeString = parts[1].trim();

      // Parse date part
      final date = parse(dateString);
      if (date == null) return null;

      // Parse time part
      final timeComponents = _extractTimeComponents(timeString);
      if (timeComponents == null) return null;

      final hour = timeComponents.$1;
      final minute = timeComponents.$2;

      return DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
    } catch (e) {
      return null;
    }
  }

  /// Extracts numeric values from a Khmer string.
  ///
  /// Converts Khmer digits to Arabic and then extracts numbers.
  ///
  /// @param input The string to extract numbers from
  /// @return List of integers found in the string
  static List<int> _extractNumericValues(String input) {
    final arabicResult = <int>[];

    // First convert Khmer digits to Arabic
    String arabicString = input;
    for (int i = 0; i < 10; i++) {
      final khmerDigit = ['០', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'][i];
      arabicString = arabicString.replaceAll(khmerDigit, i.toString());
    }

    // Extract numbers using regex
    final regex = RegExp(r'\d+');
    final matches = regex.allMatches(arabicString);

    for (final match in matches) {
      arabicResult.add(int.parse(match.group(0)!));
    }

    return arabicResult;
  }

  /// Extracts month number (1-12) from a Khmer date string.
  ///
  /// @param input The string to extract month from
  /// @return Month number (1-12) or -1 if not found
  static int _extractMonth(String input) {
    for (int i = 0; i < KhLocaleData.khmerMonths.length; i++) {
      if (input.contains(KhLocaleData.khmerMonths[i])) {
        return i + 1;
      }
    }
    return -1;
  }

  /// Extracts hour and minute from a Khmer time string.
  ///
  /// Handles 12-hour format with AM/PM indicators in Khmer.
  ///
  /// @param timeString The time string to parse
  /// @return A tuple of (hour, minute) in 24-hour format, or null if parsing failed
  static (int, int)? _extractTimeComponents(String timeString) {
    try {
      final numbers = _extractNumericValues(timeString);
      if (numbers.length < 2) return null;

      int hour = numbers[0];
      final minute = numbers[1];

      // Handle AM/PM
      final isPM = timeString.contains(KhLocaleData.pm);

      if (isPM && hour < 12) {
        hour += 12;
      } else if (!isPM && hour == 12) {
        hour = 0;
      }

      return (hour, minute);
    } catch (e) {
      return null;
    }
  }
}
