import 'date_utils.dart';

/// Utility class for common date and time arithmetic operations.
///
/// This class provides methods for adding or subtracting time periods,
/// calculating date differences, and finding boundaries of time periods.
///
/// All methods preserve time components (hours, minutes, etc.) unless
/// specifically noted otherwise.
class KhDateCalculator {
  /// Adds a specified number of days to a date.
  ///
  /// Example:
  /// ```dart
  /// final today = DateTime.now();
  /// final nextWeek = KhDateCalculator.addDays(today, 7);
  /// final lastWeek = KhDateCalculator.addDays(today, -7);
  /// ```
  ///
  /// @param date The starting DateTime
  /// @param days The number of days to add (can be negative)
  /// @return A new DateTime with the days added
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  /// Adds a specified number of months to a date.
  ///
  /// Handles month boundaries appropriately. If the resulting month has
  /// fewer days than the original date's day, the day will be adjusted
  /// to the last day of the resulting month.
  ///
  /// Example:
  /// ```dart
  /// final today = DateTime.now();
  /// final nextMonth = KhDateCalculator.addMonths(today, 1);
  /// final lastMonth = KhDateCalculator.addMonths(today, -1);
  ///
  /// // Example of month boundary handling:
  /// final jan31 = DateTime(2024, 1, 31);
  /// final feb29 = KhDateCalculator.addMonths(jan31, 1); // Feb 29, 2024 (leap year)
  /// ```
  ///
  /// @param date The starting DateTime
  /// @param months The number of months to add (can be negative)
  /// @return A new DateTime with the months added
  static DateTime addMonths(DateTime date, int months) {
    final year = date.year + (date.month + months - 1) ~/ 12;
    final month = (date.month + months - 1) % 12 + 1;

    final day = _adjustDayForMonthEnd(date.day, month, year);

    return DateTime(year, month, day, date.hour, date.minute, date.second,
        date.millisecond, date.microsecond);
  }

  /// Adds a specified number of years to a date.
  ///
  /// Handles leap years appropriately. If the date is February 29 and
  /// the target year is not a leap year, it will be adjusted to February 28.
  ///
  /// Example:
  /// ```dart
  /// final today = DateTime.now();
  /// final nextYear = KhDateCalculator.addYears(today, 1);
  /// final lastYear = KhDateCalculator.addYears(today, -1);
  ///
  /// // Example of leap year handling:
  /// final leapDay = DateTime(2024, 2, 29);
  /// final nextYearFeb28 = KhDateCalculator.addYears(leapDay, 1); // Feb 28, 2025
  /// ```
  ///
  /// @param date The starting DateTime
  /// @param years The number of years to add (can be negative)
  /// @return A new DateTime with the years added
  static DateTime addYears(DateTime date, int years) {
    final year = date.year + years;
    final day = _adjustDayForMonthEnd(date.day, date.month, year);

    return DateTime(year, date.month, day, date.hour, date.minute, date.second,
        date.millisecond, date.microsecond);
  }

  /// Adds a specified number of hours to a date.
  ///
  /// Example:
  /// ```dart
  /// final now = DateTime.now();
  /// final twoHoursLater = KhDateCalculator.addHours(now, 2);
  /// final twoHoursEarlier = KhDateCalculator.addHours(now, -2);
  /// ```
  ///
  /// @param date The starting DateTime
  /// @param hours The number of hours to add (can be negative)
  /// @return A new DateTime with the hours added
  static DateTime addHours(DateTime date, int hours) {
    return date.add(Duration(hours: hours));
  }

  /// Adds a specified number of minutes to a date.
  ///
  /// Example:
  /// ```dart
  /// final now = DateTime.now();
  /// final thirtyMinutesLater = KhDateCalculator.addMinutes(now, 30);
  /// final thirtyMinutesEarlier = KhDateCalculator.addMinutes(now, -30);
  /// ```
  ///
  /// @param date The starting DateTime
  /// @param minutes The number of minutes to add (can be negative)
  /// @return A new DateTime with the minutes added
  static DateTime addMinutes(DateTime date, int minutes) {
    return date.add(Duration(minutes: minutes));
  }

  /// Adds a specified number of seconds to a date.
  ///
  /// Example:
  /// ```dart
  /// final now = DateTime.now();
  /// final tenSecondsLater = KhDateCalculator.addSeconds(now, 10);
  /// final tenSecondsEarlier = KhDateCalculator.addSeconds(now, -10);
  /// ```
  ///
  /// @param date The starting DateTime
  /// @param seconds The number of seconds to add (can be negative)
  /// @return A new DateTime with the seconds added
  static DateTime addSeconds(DateTime date, int seconds) {
    return date.add(Duration(seconds: seconds));
  }

  /// Calculate the difference between two dates in days.
  ///
  /// The result is a whole number of days, ignoring time parts.
  ///
  /// Example:
  /// ```dart
  /// final startDate = DateTime(2024, 1, 1);
  /// final endDate = DateTime(2024, 1, 15);
  /// final daysDiff = KhDateCalculator.daysBetween(startDate, endDate); // 14
  /// ```
  ///
  /// @param from The starting DateTime
  /// @param to The ending DateTime
  /// @return The number of days between the dates
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return toDate.difference(fromDate).inDays;
  }

  /// Calculate the difference between two dates in months.
  ///
  /// This is an approximate calculation based on calendar months.
  /// The time parts of the dates are ignored.
  ///
  /// Example:
  /// ```dart
  /// final startDate = DateTime(2024, 1, 15);
  /// final endDate = DateTime(2024, 7, 5);
  /// final monthsDiff = KhDateCalculator.monthsBetween(startDate, endDate); // 6
  /// ```
  ///
  /// @param from The starting DateTime
  /// @param to The ending DateTime
  /// @return The number of months between the dates
  static int monthsBetween(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + to.month - from.month;
  }

  /// Calculate the difference between two dates in years.
  ///
  /// This calculation takes into account the month and day, not just year.
  /// For example, from January 15, 2023 to January 14, 2024 is 0 years
  /// because a full year has not yet elapsed.
  ///
  /// Example:
  /// ```dart
  /// final startDate = DateTime(2022, 3, 15);
  /// final endDate = DateTime(2024, 6, 10);
  /// final yearsDiff = KhDateCalculator.yearsBetween(startDate, endDate); // 2
  /// ```
  ///
  /// @param from The starting DateTime
  /// @param to The ending DateTime
  /// @return The number of complete years between the dates
  static int yearsBetween(DateTime from, DateTime to) {
    int years = to.year - from.year;
    if (to.month < from.month ||
        (to.month == from.month && to.day < from.day)) {
      years--;
    }
    return years;
  }

  /// Returns the first day of the month containing the given date.
  ///
  /// Preserves the time part of the original date.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 7, 15, 10, 30);
  /// final firstDay = KhDateCalculator.firstDayOfMonth(date);
  /// // firstDay = DateTime(2024, 7, 1, 10, 30)
  /// ```
  ///
  /// @param date The DateTime to get the first day of the month for
  /// @return A new DateTime representing the first day of the month
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1, date.hour, date.minute,
        date.second, date.millisecond, date.microsecond);
  }

  /// Returns the last day of the month containing the given date.
  ///
  /// Preserves the time part of the original date.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 2, 15, 10, 30);
  /// final lastDay = KhDateCalculator.lastDayOfMonth(date);
  /// // lastDay = DateTime(2024, 2, 29, 10, 30) (February in leap year)
  /// ```
  ///
  /// @param date The DateTime to get the last day of the month for
  /// @return A new DateTime representing the last day of the month
  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, date.hour, date.minute,
        date.second, date.millisecond, date.microsecond);
  }

  /// Returns the first day of the week containing the given date.
  ///
  /// By default, Sunday is considered the first day of the week.
  /// This can be customized with the firstDayOfWeek parameter.
  ///
  /// Preserves the time part of the original date.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 7, 15); // A Monday
  /// final firstDaySunday = KhDateCalculator.firstDayOfWeek(date); // Sunday, July 14
  /// final firstDayMonday = KhDateCalculator.firstDayOfWeek(date, firstDayOfWeek: DateTime.monday); // Monday, July 15
  /// ```
  ///
  /// @param date The DateTime to get the first day of the week for
  /// @param firstDayOfWeek Day considered as first day of week (default: Sunday/0)
  /// @return A new DateTime representing the first day of the week
  static DateTime firstDayOfWeek(DateTime date,
      {int firstDayOfWeek = DateTime.sunday}) {
    // Convert DateTime.weekday (1-7, Monday-Sunday) to our days (0-6, Sunday-Saturday) if needed
    final dateWeekday = date.weekday % 7;
    final adjustedFirstDay = firstDayOfWeek % 7;

    // Calculate difference in days
    final difference = dateWeekday - adjustedFirstDay;

    // Adjust for negative difference
    final offset = difference < 0 ? difference + 7 : difference;

    return DateTime(date.year, date.month, date.day - offset, date.hour,
        date.minute, date.second, date.millisecond, date.microsecond);
  }

  /// Returns the last day of the week containing the given date.
  ///
  /// By default, Saturday is considered the last day of the week
  /// (when Sunday is the first day).
  ///
  /// Preserves the time part of the original date.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 7, 15); // A Monday
  /// final lastDaySaturday = KhDateCalculator.lastDayOfWeek(date); // Saturday, July 20
  /// final lastDaySunday = KhDateCalculator.lastDayOfWeek(date, firstDayOfWeek: DateTime.monday); // Sunday, July 21
  /// ```
  ///
  /// @param date The DateTime to get the last day of the week for
  /// @param firstDayOfWeek Day considered as first day of week (default: Sunday/0)
  /// @return A new DateTime representing the last day of the week
  static DateTime lastDayOfWeek(DateTime date,
      {int firstDayOfWeek = DateTime.sunday}) {
    // Use fully qualified method name to avoid conflict with parameter name
    final firstDay =
        KhDateCalculator.firstDayOfWeek(date, firstDayOfWeek: firstDayOfWeek);
    return KhDateCalculator.addDays(firstDay, 6);
  }

  /// Returns the first day of the year containing the given date.
  ///
  /// Preserves the time part of the original date.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 7, 15, 10, 30);
  /// final firstDay = KhDateCalculator.firstDayOfYear(date);
  /// // firstDay = DateTime(2024, 1, 1, 10, 30)
  /// ```
  ///
  /// @param date The DateTime to get the first day of the year for
  /// @return A new DateTime representing the first day of the year
  static DateTime firstDayOfYear(DateTime date) {
    return DateTime(date.year, 1, 1, date.hour, date.minute, date.second,
        date.millisecond, date.microsecond);
  }

  /// Returns the last day of the year containing the given date.
  ///
  /// Preserves the time part of the original date.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2024, 7, 15, 10, 30);
  /// final lastDay = KhDateCalculator.lastDayOfYear(date);
  /// // lastDay = DateTime(2024, 12, 31, 10, 30)
  /// ```
  ///
  /// @param date The DateTime to get the last day of the year for
  /// @return A new DateTime representing the last day of the year
  static DateTime lastDayOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, date.hour, date.minute, date.second,
        date.millisecond, date.microsecond);
  }

  /// Helper method to adjust day for month end.
  ///
  /// If the specified day is beyond the end of the month, returns the
  /// last day of the month. Otherwise, returns the original day.
  ///
  /// @param day The day of month
  /// @param month The month (1-12)
  /// @param year The year
  /// @return The adjusted day
  static int _adjustDayForMonthEnd(int day, int month, int year) {
    // Get the actual number of days in the month
    final daysInMonth = KhDateUtils.daysInMonth(year, month);

    // Return the original day or the last day of the month if necessary
    return day > daysInMonth ? daysInMonth : day;
  }
}
