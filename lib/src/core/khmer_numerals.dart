/// Utility class for converting between Arabic and Khmer numerals.
///
/// Provides functionality to convert strings containing Arabic numerals (0-9)
/// to their Khmer numeral equivalents (០-៩) and vice versa.
///
/// Example usage:
/// ```dart
/// final khmerNumerals = KhmerNumerals.convert('2024');
/// print(khmerNumerals); // ២០២៤
///
/// final arabicNumerals = KhmerNumerals.convertToArabic('២០២៤');
/// print(arabicNumerals); // 2024
/// ```
class KhmerNumerals {
  /// Khmer digit characters from 0-9
  ///
  /// The Khmer numeral system uses these characters to represent digits:
  /// - ០ (0)
  /// - ១ (1)
  /// - ២ (2)
  /// - ៣ (3)
  /// - ៤ (4)
  /// - ៥ (5)
  /// - ៦ (6)
  /// - ៧ (7)
  /// - ៨ (8)
  /// - ៩ (9)
  static const List<String> _khmerDigits = [
    '០', // 0
    '១', // 1
    '២', // 2
    '៣', // 3
    '៤', // 4
    '៥', // 5
    '៦', // 6
    '៧', // 7
    '៨', // 8
    '៩', // 9
  ];

  /// Converts a string containing Arabic numerals to Khmer numerals.
  ///
  /// This method replaces each digit (0-9) in the input string with its
  /// corresponding Khmer numeral character (០-៩). Non-digit characters
  /// remain unchanged.
  ///
  /// Example:
  /// ```dart
  /// final khmerDate = KhmerNumerals.convert('15/01/2024');
  /// print(khmerDate); // ១៥/០១/២០២៤
  ///
  /// final price = KhmerNumerals.convert('$100.50');
  /// print(price); // $១០០.៥០
  /// ```
  ///
  /// @param input String containing Arabic numerals to convert
  /// @return String with Arabic numerals replaced by Khmer numerals
  static String convert(String input) {
    return input.replaceAllMapped(RegExp(r'\d'), (match) {
      return _khmerDigits[int.parse(match[0]!)];
    });
  }

  /// Alias for [convert] to maintain API compatibility.
  ///
  /// @param input String containing Arabic numerals to convert
  /// @return String with Khmer numerals
  static String format(String input) => convert(input);

  /// Converts a string containing Khmer numerals to Arabic numerals.
  ///
  /// This method replaces each Khmer numeral character (០-៩) in the input
  /// string with its corresponding Arabic digit (0-9). Non-Khmer-numeral
  /// characters remain unchanged.
  ///
  /// Example:
  /// ```dart
  /// final arabicDate = KhmerNumerals.convertToArabic('១៥/០១/២០២៤');
  /// print(arabicDate); // 15/01/2024
  /// ```
  ///
  /// @param input String containing Khmer numerals to convert
  /// @return String with Khmer numerals replaced by Arabic numerals
  static String convertToArabic(String input) {
    String result = input;
    for (int i = 0; i < _khmerDigits.length; i++) {
      result = result.replaceAll(_khmerDigits[i], i.toString());
    }
    return result;
  }

  /// Extracts a numeric value from a string that may contain Khmer numerals.
  ///
  /// This method first converts any Khmer numerals to Arabic numerals,
  /// then attempts to parse an integer from the resulting string.
  ///
  /// Returns null if no valid number could be extracted.
  ///
  /// Example:
  /// ```dart
  /// final value = KhmerNumerals.parseInteger('ទំហំ: ១២៣ គីឡូក្រាម');
  /// print(value); // 123
  /// ```
  ///
  /// @param input String that may contain Khmer numerals
  /// @return Integer value or null if parsing failed
  static int? parseInteger(String input) {
    try {
      final arabicString = convertToArabic(input);

      // Extract the first sequence of digits
      final match = RegExp(r'\d+').firstMatch(arabicString);
      if (match != null) {
        return int.parse(match.group(0)!);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Extracts a decimal value from a string that may contain Khmer numerals.
  ///
  /// This method first converts any Khmer numerals to Arabic numerals,
  /// then attempts to parse a double from the resulting string.
  ///
  /// Returns null if no valid number could be extracted.
  ///
  /// Example:
  /// ```dart
  /// final price = KhmerNumerals.parseDouble('តម្លៃ: ១២៣.៤៥៦ ដុល្លារ');
  /// print(price); // 123.456
  /// ```
  ///
  /// @param input String that may contain Khmer numerals
  /// @return Double value or null if parsing failed
  static double? parseDouble(String input) {
    try {
      final arabicString = convertToArabic(input);

      // Extract the first sequence of digits with optional decimal point
      final match = RegExp(r'\d+(\.\d+)?').firstMatch(arabicString);
      if (match != null) {
        return double.parse(match.group(0)!);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
