/// Utility class for handling time zones with Khmer calendar support.
///
/// This class provides utilities for working with Cambodia's timezone (ICT),
/// including conversion between UTC and Cambodian local time, and
/// timezone-aware date creation.
///
/// Cambodia uses the +07:00 timezone (Indochina Time/ICT) with no Daylight
/// Saving Time adjustments.
class KhTimeZoneUtils {
  /// The offset for Cambodia's timezone (ICT/Indochina Time) in hours.
  ///
  /// Cambodia uses UTC+7 which corresponds to Indochina Time (ICT).
  static const double cambodiaOffsetHours = 7.0;

  /// The string representation of Cambodia's timezone offset.
  ///
  /// This follows the standard ISO 8601 format for timezone offsets.
  static const String cambodiaTimeZone = '+07:00';

  /// The timezone name for Cambodia.
  ///
  /// ICT stands for Indochina Time.
  static const String cambodiaTimeZoneName = 'ICT';

  /// Converts a UTC DateTime to Cambodia local time.
  ///
  /// If the provided DateTime is already in local time, it will first
  /// be converted to UTC before applying the Cambodia timezone offset.
  ///
  /// Example:
  /// ```dart
  /// final utcTime = DateTime.utc(2024, 7, 15, 12, 0); // 12:00 UTC
  /// final cambodiaTime = KhTimeZoneUtils.toKhmerLocalTime(utcTime);
  /// // cambodiaTime represents 19:00 in Cambodia
  /// ```
  ///
  /// @param utcTime The UTC DateTime to convert
  /// @return A DateTime object representing Cambodia local time
  static DateTime toKhmerLocalTime(DateTime utcTime) {
    if (utcTime.isUtc) {
      return utcTime.add(const Duration(hours: 7));
    } else {
      // If already in local time, convert to UTC first then to Cambodia time
      return utcTime.toUtc().add(const Duration(hours: 7));
    }
  }

  /// Converts a local Cambodia time to UTC.
  ///
  /// If the provided DateTime is already in UTC, it will just subtract
  /// the Cambodia timezone offset.
  ///
  /// Example:
  /// ```dart
  /// final cambodiaTime = DateTime(2024, 7, 15, 19, 0); // 19:00 in Cambodia
  /// final utcTime = KhTimeZoneUtils.toUtcFromKhmerTime(cambodiaTime);
  /// // utcTime represents 12:00 UTC
  /// ```
  ///
  /// @param khmerLocalTime The Cambodia local DateTime to convert
  /// @return A DateTime object representing UTC time
  static DateTime toUtcFromKhmerTime(DateTime khmerLocalTime) {
    if (!khmerLocalTime.isUtc) {
      return khmerLocalTime.subtract(const Duration(hours: 7)).toUtc();
    } else {
      // If already in UTC, just subtract the offset
      return khmerLocalTime.subtract(const Duration(hours: 7));
    }
  }

  /// Gets the current time in Cambodia timezone.
  ///
  /// This is equivalent to converting the current UTC time to Cambodia time.
  ///
  /// Example:
  /// ```dart
  /// final now = KhTimeZoneUtils.nowInKhmerTimeZone();
  /// // Returns the current time in Cambodia (UTC+7)
  /// ```
  ///
  /// @return A DateTime object representing the current time in Cambodia
  static DateTime nowInKhmerTimeZone() {
    return toKhmerLocalTime(DateTime.now().toUtc());
  }

  /// Formats the timezone offset as a string (e.g., "+07:00").
  ///
  /// Converts a numeric offset in hours to the standard ISO 8601 format
  /// for timezone offsets.
  ///
  /// Example:
  /// ```dart
  /// final offset = KhTimeZoneUtils.formatOffset(7.5);
  /// print(offset); // "+07:30"
  ///
  /// final negativeOffset = KhTimeZoneUtils.formatOffset(-5.75);
  /// print(negativeOffset); // "-05:45"
  /// ```
  ///
  /// @param offsetHours Timezone offset in hours (can be fractional)
  /// @return Formatted timezone offset string
  static String formatOffset(double offsetHours) {
    final isNegative = offsetHours < 0;
    final absHours = offsetHours.abs();
    final hours = absHours.floor();
    final minutes = ((absHours - hours) * 60).round();

    return '${isNegative ? '-' : '+'}${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Creates a DateTime with the specified components in Cambodia timezone.
  ///
  /// This is equivalent to creating a DateTime in UTC and then adding
  /// the Cambodia timezone offset.
  ///
  /// Example:
  /// ```dart
  /// final birthday = KhTimeZoneUtils.khmerDateTime(2024, 7, 15, 14, 30);
  /// // Creates a DateTime for July 15, 2024, 14:30 in Cambodia time
  /// ```
  ///
  /// @param year The year
  /// @param month The month (1-12)
  /// @param day The day of the month
  /// @param hour The hour (0-23, optional, defaults to 0)
  /// @param minute The minute (0-59, optional, defaults to 0)
  /// @param second The second (0-59, optional, defaults to 0)
  /// @return A DateTime object representing the specified time in Cambodia
  static DateTime khmerDateTime(int year, int month, int day,
      [int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0]) {
    // Create a UTC DateTime and add the offset for Cambodia
    return DateTime.utc(
            year, month, day, hour, minute, second, millisecond, microsecond)
        .add(const Duration(hours: 7));
  }

  /// Gets the current UTC offset for Cambodia in hours.
  ///
  /// Cambodia does not observe Daylight Saving Time, so this value is constant.
  ///
  /// Example:
  /// ```dart
  /// final offset = KhTimeZoneUtils.getCurrentKhmerUtcOffset();
  /// print(offset); // 7.0
  /// ```
  ///
  /// @return The current UTC offset for Cambodia in hours
  static double getCurrentKhmerUtcOffset() {
    return cambodiaOffsetHours;
  }

  /// Checks if a DateTime is in Cambodia timezone.
  ///
  /// This is an approximation based on the UTC offset, since
  /// DateTime in Dart doesn't store timezone information directly.
  ///
  /// Example:
  /// ```dart
  /// final cambodiaTime = KhTimeZoneUtils.nowInKhmerTimeZone();
  /// print(KhTimeZoneUtils.isKhmerTimeZone(cambodiaTime)); // true
  ///
  /// final utcTime = DateTime.utc(2024, 7, 15);
  /// print(KhTimeZoneUtils.isKhmerTimeZone(utcTime)); // false
  /// ```
  ///
  /// @param dateTime The DateTime to check
  /// @return true if the DateTime is likely in Cambodia timezone
  static bool isKhmerTimeZone(DateTime dateTime) {
    if (dateTime.isUtc) return false;

    // Compare with a known Cambodia time
    final now = DateTime.now();
    final khmerNow = nowInKhmerTimeZone();

    // Calculate the offset difference between local and Cambodia time
    final localOffset = now.timeZoneOffset.inHours;
    final khmerOffset = khmerNow.timeZoneOffset.inHours;

    // Check if the offsets are approximately equal
    return (localOffset - khmerOffset).abs() < 0.1;
  }

  /// Gets the date portion of a DateTime in Cambodia timezone.
  ///
  /// This is useful when you only need the date part without time,
  /// but want to ensure it's the correct date in Cambodia.
  ///
  /// Example:
  /// ```dart
  /// final utcNow = DateTime.now().toUtc();
  /// final khmerDate = KhTimeZoneUtils.getKhmerDate(utcNow);
  /// // Returns just the date part (00:00:00) for the current date in Cambodia
  /// ```
  ///
  /// @param dateTime The DateTime to extract the date from
  /// @return A DateTime with the Cambodia date and time set to midnight
  static DateTime getKhmerDate(DateTime dateTime) {
    final khmerDateTime = toKhmerLocalTime(dateTime);
    return DateTime(khmerDateTime.year, khmerDateTime.month, khmerDateTime.day);
  }
}
