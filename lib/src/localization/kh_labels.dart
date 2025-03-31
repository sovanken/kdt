/// Common Khmer UI text labels for date and time components.
///
/// This class provides standard labels for UI components in Khmer language,
/// such as time units, calendar navigation, and form controls.
///
/// These constants ensure consistency in terminology and translations across
/// the package's UI components.
class KhLabels {
  // Time units

  /// Khmer word for "hour"
  static const String hour = 'ម៉ោង';

  /// Khmer word for "minute"
  static const String minute = 'នាទី';

  /// Khmer word for "second"
  static const String second = 'វិនាទី';

  /// Khmer word for "millisecond"
  static const String millisecond = 'មីលីវិនាទី';

  // Calendar components

  /// Khmer word for "day"
  static const String day = 'ថ្ងៃ';

  /// Khmer word for "month"
  static const String month = 'ខែ';

  /// Khmer word for "year"
  static const String year = 'ឆ្នាំ';

  /// Khmer word for "week"
  static const String week = 'សប្ដាហ៍';

  /// Khmer word for "quarter" (of a year)
  static const String quarter = 'ត្រីមាស';

  // Date words

  /// Khmer word for "today"
  static const String today = 'ថ្ងៃនេះ';

  /// Khmer word for "tomorrow"
  static const String tomorrow = 'ថ្ងៃស្អែក';

  /// Khmer word for "yesterday"
  static const String yesterday = 'ម្សិលមិញ';

  // Button labels

  /// Khmer word for "cancel"
  static const String cancel = 'បោះបង់';

  /// Khmer word for "ok" or "accept"
  static const String ok = 'យល់ព្រម';

  /// Khmer word for "next"
  static const String next = 'បន្ទាប់';

  /// Khmer word for "previous"
  static const String previous = 'មុន';

  /// Khmer word for "save"
  static const String save = 'រក្សាទុក';

  /// Khmer word for "done"
  static const String done = 'រួចរាល់';

  // Calendar navigation

  /// Khmer label for "next month"
  static const String nextMonth = 'ខែបន្ទាប់';

  /// Khmer label for "previous month"
  static const String previousMonth = 'ខែមុន';

  /// Khmer label for "next year"
  static const String nextYear = 'ឆ្នាំបន្ទាប់';

  /// Khmer label for "previous year"
  static const String previousYear = 'ឆ្នាំមុន';

  // Date picker related

  /// Khmer label for "select date"
  static const String selectDate = 'ជ្រើសរើសកាលបរិច្ឆេទ';

  /// Khmer label for "select time"
  static const String selectTime = 'ជ្រើសរើសម៉ោង';

  /// Khmer label for "select date and time"
  static const String selectDateTime = 'ជ្រើសរើសកាលបរិច្ឆេទ និងម៉ោង';

  /// Khmer label for "start date"
  static const String startDate = 'ថ្ងៃចាប់ផ្តើម';

  /// Khmer label for "end date"
  static const String endDate = 'ថ្ងៃបញ្ចប់';

  /// Khmer label for "date range"
  static const String dateRange = 'ចន្លោះកាលបរិច្ឆេទ';

  // Error messages

  /// Khmer message for when a required date has not been set
  static const String dateRequired = 'កាលបរិច្ឆេទត្រូវតែបញ្ចូល';

  /// Khmer message for an invalid date format
  static const String invalidDate = 'ទម្រង់កាលបរិច្ឆេទមិនត្រឹមត្រូវ';

  /// Khmer message for when start date must be before end date
  static const String startBeforeEnd = 'ថ្ងៃចាប់ផ្តើមត្រូវតែមុនថ្ងៃបញ្ចប់';

  /// Khmer message for maximum date range exceeded
  static const String maxDateRange = 'ចន្លោះកាលបរិច្ឆេទអតិបរមាត្រឹម';

  // Formatting helpers

  /// Returns a formatted string for "X days" in Khmer
  ///
  /// @param count The number of days
  /// @return Formatted string with count and "days" in Khmer
  static String days(int count) => '$count ថ្ងៃ';

  /// Returns a formatted string for "X months" in Khmer
  ///
  /// @param count The number of months
  /// @return Formatted string with count and "months" in Khmer
  static String months(int count) => '$count ខែ';

  /// Returns a formatted string for "X years" in Khmer
  ///
  /// @param count The number of years
  /// @return Formatted string with count and "years" in Khmer
  static String years(int count) => '$count ឆ្នាំ';

  /// Returns a formatted string for "X hours" in Khmer
  ///
  /// @param count The number of hours
  /// @return Formatted string with count and "hours" in Khmer
  static String hours(int count) => '$count ម៉ោង';

  /// Returns a formatted string for "X minutes" in Khmer
  ///
  /// @param count The number of minutes
  /// @return Formatted string with count and "minutes" in Khmer
  static String minutes(int count) => '$count នាទី';

  /// Returns a formatted string for maximum date range in Khmer
  ///
  /// @param count The maximum number of days
  /// @return Formatted error message
  static String maxDateRangeMessage(int count) =>
      '$maxDateRange ${days(count)}';
}
