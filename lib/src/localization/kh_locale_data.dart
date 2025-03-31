/// Localization data for Khmer calendar components.
///
/// This class provides common Khmer language items used in date/time
/// formatting and calendar displays, including month names, day names,
/// and time period indicators.
///
/// These constants should be used throughout the package to ensure
/// consistency in Khmer language representations.
class KhLocaleData {
  /// Khmer month names in order from January to December.
  ///
  /// These are the standard Khmer names for the Gregorian calendar months.
  static const List<String> khmerMonths = [
    'មករា', // January
    'កុម្ភៈ', // February
    'មីនា', // March
    'មេសា', // April
    'ឧសភា', // May
    'មិថុនា', // June
    'កក្កដា', // July
    'សីហា', // August
    'កញ្ញា', // September
    'តុលា', // October
    'វិច្ឆិកា', // November
    'ធ្នូ' // December
  ];

  /// Khmer weekday names starting from Sunday (0) to Saturday (6).
  ///
  /// Note: When using with DateTime.weekday, remember that DateTime.weekday
  /// uses 1-7 (Monday-Sunday), so you'll need to adjust the index.
  static const List<String> khmerDays = [
    'អាទិត្យ', // Sunday
    'ចន្ទ', // Monday
    'អង្គារ', // Tuesday
    'ពុធ', // Wednesday
    'ព្រហស្បតិ៍', // Thursday
    'សុក្រ', // Friday
    'សៅរ៍' // Saturday
  ];

  /// Khmer label for morning/AM.
  ///
  /// Used in time formatting to indicate morning hours.
  static const String am = 'ព្រឹក'; // AM (morning)

  /// Khmer label for evening/PM.
  ///
  /// Used in time formatting to indicate afternoon/evening hours.
  static const String pm = 'ល្ងាច'; // PM (evening)

  /// Khmer names for the Buddhist calendar months.
  ///
  /// These are used for traditional Khmer lunar calendar dates.
  /// Note: The traditional Khmer lunar calendar has different month names
  /// than the Gregorian calendar.
  static const List<String> khmerLunarMonths = [
    'មិគសិរ', // Migasir
    'បុស្ស', // Bos
    'មាឃ', // Meagh
    'ផល្គុន', // Phalgun
    'ចេត្រ', // Chetr
    'ពិសាខ', // Visakh
    'ជេស្ឋ', // Chesth
    'អាសាឍ', // Asath
    'ស្រាពណ៍', // Srabon
    'ភទ្របទ', // Photrobot
    'អស្សុជ', // Assoch
    'កត្តិក' // Kattik
  ];

  /// Abbreviated Khmer weekday names (typically first character).
  ///
  /// These are useful for calendar UI where space is limited.
  static const List<String> khmerDaysShort = [
    'អា', // Sunday
    'ច', // Monday
    'អ', // Tuesday
    'ពុ', // Wednesday
    'ព្រ', // Thursday
    'សុ', // Friday
    'ស' // Saturday
  ];

  /// Khmer names for seasons of the year.
  static const List<String> khmerSeasons = [
    'រដូវប្រាំង', // Hot season
    'រដូវវស្សា', // Rainy season
    'រដូវរងារ' // Cool season
  ];

  /// Khmer words for relative dates.
  static const Map<String, String> relativeDates = {
    'today': 'ថ្ងៃនេះ',
    'yesterday': 'ម្សិលមិញ',
    'tomorrow': 'ថ្ងៃស្អែក',
    'last_week': 'សប្ដាហ៍មុន',
    'next_week': 'សប្ដាហ៍ក្រោយ',
    'last_month': 'ខែមុន',
    'next_month': 'ខែក្រោយ',
    'last_year': 'ឆ្នាំមុន',
    'next_year': 'ឆ្នាំក្រោយ',
  };

  /// Convert a DateTime.weekday (1-7, Monday-Sunday) to a Khmer day name.
  ///
  /// Since DateTime.weekday returns 1 for Monday and 7 for Sunday, but our
  /// khmerDays list is indexed from 0 (Sunday) to 6 (Saturday), this method
  /// performs the necessary conversion.
  ///
  /// Example:
  /// ```dart
  /// final today = DateTime.now();
  /// final khmerDay = KhLocaleData.getWeekdayName(today.weekday);
  /// ```
  ///
  /// @param weekday A DateTime.weekday value (1-7)
  /// @return The corresponding Khmer weekday name
  static String getWeekdayName(int weekday) {
    // Convert from DateTime.weekday (1-7, Monday-Sunday)
    // to our index (0-6, Sunday-Saturday)
    final index = (weekday + 5) % 7;
    return khmerDays[index];
  }

  /// Convert a month number (1-12) to a Khmer month name.
  ///
  /// Example:
  /// ```dart
  /// final today = DateTime.now();
  /// final khmerMonth = KhLocaleData.getMonthName(today.month);
  /// ```
  ///
  /// @param month Month number (1-12)
  /// @return The corresponding Khmer month name
  static String getMonthName(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    return khmerMonths[month - 1];
  }
}
