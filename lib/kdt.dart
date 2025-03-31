/// Khmer Date Time (KDT) package
///
/// A comprehensive Flutter package for Khmer (Cambodian) date and time handling,
/// including formatting, parsing, calculation, and UI components.
///
/// This package provides:
/// - Localized date and time formatting with Khmer numerals
/// - Buddhist calendar year conversion (CE + 543)
/// - Khmer date parsing from strings to DateTime
/// - Date calculation and manipulation utilities
/// - Cambodia timezone (ICT/+07:00) utilities
/// - Customizable Khmer calendar widgets
///
/// Example usage:
/// ```dart
/// import 'package:kdt/kdt.dart';
///
/// // Format a date in Khmer
/// final now = DateTime.now();
/// final formatted = KhmerDateFormatter.formatDateTime(now, useKhmerDigits: true);
/// print(formatted); // Example: "១៥ មករា ២៥៦៧, ១០:៣០ ព្រឹក"
///
/// // Parse a Khmer date string
/// final dateString = "១៥ មករា ២៥៦៧";
/// final date = KhmerDateParser.parse(dateString);
///
/// // Convert between Buddhist and Gregorian years
/// final buddhistYear = KhDateUtils.toBuddhistYear(2024); // 2567
/// final gregorianYear = KhDateUtils.toGregorianYear(2567); // 2024
///
/// // Use Cambodia timezone utilities
/// final khmerTime = KhTimeZoneUtils.nowInKhmerTimeZone();
/// ```
library kdt;

// Core exports
export 'src/core/khmer_date_formatter.dart';
export 'src/core/khmer_date_parser.dart';
export 'src/core/khmer_numerals.dart';

// Localization exports
export 'src/localization/kh_locale_data.dart';
export 'src/localization/kh_labels.dart';

// Utility exports
export 'src/utils/date_utils.dart';
export 'src/utils/date_calculator.dart';
export 'src/utils/timezone_utils.dart';

// Widget exports
export 'src/widgets/kh_calendar.dart';
export 'src/widgets/kh_date_picker.dart';
export 'src/widgets/kh_date_range_picker.dart';
export 'src/widgets/kh_time_picker.dart';
