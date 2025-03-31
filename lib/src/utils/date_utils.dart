/// Utility functions for working with dates in Khmer calendars.
///
/// This class provides common date manipulation and conversion functions
/// specific to Khmer calendar requirements, including Buddhist year conversion,
/// leap year calculation, and calendar grid calculations.
class KhDateUtils {
  /// Converts a Gregorian year to Buddhist calendar year (+543).
  ///
  /// In Cambodia, the traditional calendar follows the Buddhist Era,
  /// which is 543 years ahead of the Common Era (CE/AD).
  ///
  /// Example:
  /// ```dart
  /// final buddhistYear = KhDateUtils.toBuddhistYear(2024);
  /// print(buddhistYear); // 2567
  /// ```
  ///
  /// @param gregorianYear The Gregorian year to convert
  /// @return The corresponding Buddhist year
  static int toBuddhistYear(int gregorianYear) {
    return gregorianYear + 543;
  }

  /// Converts a Buddhist year to Gregorian calendar year (-543).
  ///
  /// Example:
  /// ```dart
  /// final gregorianYear = KhDateUtils.toGregorianYear(2567);
  /// print(gregorianYear); // 2024
  /// ```
  ///
  /// @param buddhistYear The Buddhist year to convert
  /// @return The corresponding Gregorian year
  static int toGregorianYear(int buddhistYear) {
    return buddhistYear - 543;
  }

  /// Returns true if the given year is a leap year.
  ///
  /// Uses the standard Gregorian calendar leap year rules:
  /// - Years divisible by 400 are leap years
  /// - Years divisible by 100 but not by 400 are not leap years
  /// - Years divisible by 4 but not by 100 are leap years
  /// - All other years are not leap years
  ///
  /// Example:
  /// ```dart
  /// print(KhDateUtils.isLeapYear(2024)); // true
  /// print(KhDateUtils.isLeapYear(2023)); // false
  /// print(KhDateUtils.isLeapYear(2100)); // false
  /// print(KhDateUtils.isLeapYear(2000)); // true
  /// ```
  ///
  /// @param year The Gregorian year to check
  /// @return true if the year is a leap year, false otherwise
  static bool isLeapYear(int year) {
    if (year % 400 == 0) return true;
    if (year % 100 == 0) return false;
    return year % 4 == 0;
  }

  /// Get total days in a given month/year.
  ///
  /// Takes leap years into account for February.
  ///
  /// Example:
  /// ```dart
  /// print(KhDateUtils.daysInMonth(2024, 2)); // 29 (leap year)
  /// print(KhDateUtils.daysInMonth(2023, 2)); // 28
  /// print(KhDateUtils.daysInMonth(2023, 4)); // 30
  /// print(KhDateUtils.daysInMonth(2023, 5)); // 31
  /// ```
  ///
  /// @param year The Gregorian year
  /// @param month The month (1-12)
  /// @return The number of days in the specified month
  static int daysInMonth(int year, int month) {
    if (month == 2) {
      return isLeapYear(year) ? 29 : 28;
    }

    const thirtyDays = [4, 6, 9, 11];
    return thirtyDays.contains(month) ? 30 : 31;
  }

  /// Get the day of week for the first day of a month (0 = Sunday, 6 = Saturday).
  ///
  /// This is useful for calendar grid calculations.
  ///
  /// Example:
  /// ```dart
  /// print(KhDateUtils.startDayOfMonth(2024, 1)); // Returns weekday of Jan 1, 2024
  /// ```
  ///
  /// @param year The Gregorian year
  /// @param month The month (1-12)
  /// @return The weekday index of the first day (0 = Sunday, 6 = Saturday)
  static int startDayOfMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    // Convert from DateTime.weekday (1-7, Monday-Sunday) to our index (0-6, Sunday-Saturday)
    return (firstDay.weekday % 7);
  }

  /// Gets the day of year (1-366) for a given date.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 2, 15);
  /// print(KhDateUtils.dayOfYear(date)); // 46
  /// ```
  ///
  /// @param date The DateTime to get the day of year for
  /// @return The day of year (1-366)
  static int dayOfYear(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    return date.difference(startOfYear).inDays + 1;
  }

  /// Gets the week number (1-53) for a given date.
  ///
  /// Uses ISO week numbering:
  /// - Week 1 is the week containing the first Thursday of the year
  /// - Monday is considered the first day of the week
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15);
  /// print(KhDateUtils.weekNumber(date)); // Week number
  /// ```
  ///
  /// @param date The DateTime to get the week number for
  /// @return The ISO week number (1-53)
  static int weekNumber(DateTime date) {
    // Days since beginning of the year, shifted to make Monday = 1, Sunday = 7
    final dayOfYear = KhDateUtils.dayOfYear(date);

    // Get the weekday (1 = Monday, 7 = Sunday)
    final weekday = date.weekday;

    // Calculate the ISO week number
    int weekNumber = ((dayOfYear - weekday + 10) / 7).floor();

    // Handle edge cases at the beginning and end of the year
    if (weekNumber < 1) {
      // Last week of the previous year
      // Check if it's week 52 or 53
      final lastDec31 = DateTime(date.year - 1, 12, 31);
      return KhDateUtils.weekNumber(lastDec31);
    } else if (weekNumber > 52) {
      // Check if it's actually week 1 of the next year
      final lastDayOfYear = DateTime(date.year, 12, 31);
      if (weekNumber > KhDateUtils.weekNumber(lastDayOfYear)) {
        return 1;
      }
    }

    return weekNumber;
  }

  /// Checks if two dates are on the same day.
  ///
  /// Example:
  /// ```dart
  /// final date1 = DateTime(2024, 1, 15, 10, 30);
  /// final date2 = DateTime(2024, 1, 15, 18, 45);
  /// print(KhDateUtils.isSameDay(date1, date2)); // true
  /// ```
  ///
  /// @param date1 The first DateTime to compare
  /// @param date2 The second DateTime to compare
  /// @return true if both dates are on the same day, false otherwise
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Checks if a date is today.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime.now();
  /// print(KhDateUtils.isToday(date)); // true
  /// ```
  ///
  /// @param date The DateTime to check
  /// @return true if the date is today, false otherwise
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(date, now);
  }

  /// Returns a DateTime at the start of the day (00:00:00).
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30, 45);
  /// final startOfDay = KhDateUtils.startOfDay(date);
  /// // startOfDay = DateTime(2024, 1, 15, 0, 0, 0, 0, 0)
  /// ```
  ///
  /// @param date The DateTime to set to start of day
  /// @return A new DateTime at 00:00:00 on the same day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns a DateTime at the end of the day (23:59:59.999999).
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 1, 15, 10, 30, 45);
  /// final endOfDay = KhDateUtils.endOfDay(date);
  /// // endOfDay = DateTime(2024, 1, 15, 23, 59, 59, 999, 999)
  /// ```
  ///
  /// @param date The DateTime to set to end of day
  /// @return A new DateTime at 23:59:59.999999 on the same day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999, 999);
  }
}
