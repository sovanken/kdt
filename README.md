# KDT - Khmer Date Time

A comprehensive Flutter package for Khmer (Cambodian) date and time handling, including formatting, parsing, calculation, and UI components.

## 📋 Table of Contents

- [Features](#-features)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Usage](#-usage)
- [API Reference](#-api-reference)
- [Example App](#-example-app)
- [Supported Platforms](#-supported-platforms)
- [Contributing](#-contributing)
- [Support](#-support)
- [License](#-license)
- [About the Author](#-about-the-author)

## 🚀 Features

📅 **Localized Formatting**
- Format dates and times in Khmer language
- Support for Khmer month and day names
- Buddhist calendar year support (CE + 543)
- Khmer AM/PM indicators (ព្រឹក/ល្ងាច)

🔢 **Khmer Numerals**
- Convert between Arabic numerals and Khmer numerals (០-៩)
- Extract numeric values from Khmer text

📆 **Date Parsing**
- Parse Khmer date strings into DateTime objects
- Support for various common Khmer date formats
- Automatic Buddhist year conversion

🧮 **Date Calculations**
- Add/subtract days, months, years
- Calculate date differences
- Find boundaries (first/last day of month, week, year)
- Week number calculations

🕒 **Time Zone Support**
- Cambodia timezone (ICT/+07:00) utilities
- Convert between UTC and Cambodia time
- Timezone-aware date handling

🎛️ **UI Components**
- Khmer Date Picker
- Khmer Time Picker
- Khmer Calendar View
- Khmer Date Range Picker

## 📋 Requirements

- Flutter SDK 3.0.0 or higher
- Dart SDK 2.17.0 or higher
- Dependencies:
  - `intl` package

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  kdt: ^0.1.0
```

Then run:

```
flutter pub get
```

## 🔍 Usage

Import the package:

```dart
import 'package:kdt/kdt.dart';
```

### Basic Date Formatting

```dart
import 'package:kdt/kdt.dart';

void main() {
  final now = DateTime.now();
  
  // Format date in Khmer
  final formatted = KhmerDateFormatter.formatDateTime(now, useKhmerDigits: true);
  print(formatted); // Example: "១៥ មករា ២៥៦៧, ១០:៣០ ព្រឹក"
  
  // Format just the date part
  final dateOnly = KhmerDateFormatter.formatDate(now, useKhmerDigits: true);
  
  // Format with weekday
  final withWeekday = KhmerDateFormatter.formatDateWithWeekday(now);
}
```

### Khmer Numerals

```dart
import 'package:kdt/kdt.dart';

void main() {
  // Convert to Khmer numerals
  final khmerNumerals = KhmerNumerals.convert('2024');
  print(khmerNumerals); // ២០២៤
  
  // Convert back to Arabic numerals
  final arabicNumerals = KhmerNumerals.convertToArabic('២០២៤');
  print(arabicNumerals); // 2024
  
  // Parse integers/doubles from Khmer text
  final value = KhmerNumerals.parseInteger('តម្លៃ: ១២៣ រៀល');
  print(value); // 123
}
```

### Date Parsing

```dart
import 'package:kdt/kdt.dart';

void main() {
  // Parse a Khmer date string
  final dateString = "១៥ មករា ២៥៦៧";
  final date = KhmerDateParser.parse(dateString);
  
  // Parse date and time
  final dateTimeString = "១៥ មករា ២៥៦៧, ១០:៣០ ព្រឹក";
  final dateTime = KhmerDateParser.parseDateTime(dateTimeString);
}
```

### Date Calculations

```dart
import 'package:kdt/kdt.dart';

void main() {
  final today = DateTime.now();
  
  // Add time periods
  final nextMonth = KhDateCalculator.addMonths(today, 1);
  final lastWeek = KhDateCalculator.addDays(today, -7);
  
  // Calculate differences
  final birthday = DateTime(2023, 5, 15);
  final daysToBirthday = KhDateCalculator.daysBetween(today, birthday);
  
  // Find boundaries
  final monthStart = KhDateCalculator.firstDayOfMonth(today);
  final monthEnd = KhDateCalculator.lastDayOfMonth(today);
  final weekStart = KhDateCalculator.firstDayOfWeek(today);
}
```

### Time Zone Utilities

```dart
import 'package:kdt/kdt.dart';

void main() {
  // Get current time in Cambodia
  final nowInCambodia = KhTimeZoneUtils.nowInKhmerTimeZone();
  
  // Convert between timezones
  final utcTime = DateTime.now().toUtc();
  final cambodiaTime = KhTimeZoneUtils.toKhmerLocalTime(utcTime);
  final backToUtc = KhTimeZoneUtils.toUtcFromKhmerTime(cambodiaTime);
  
  // Create datetime in Cambodia timezone
  final khmerDateTime = KhTimeZoneUtils.khmerDateTime(2024, 7, 15, 14, 30);
}
```

### UI Components

#### Khmer Date Picker

```dart
import 'package:flutter/material.dart';
import 'package:kdt/kdt.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: KhDatePicker(
          initialDate: DateTime.now(),
          onDateSelected: (date) {
            print('Selected date: $date');
          },
          useKhmerDigits: true,
          useBuddhistYear: true,
          backgroundColor: Colors.teal.shade100,
        ),
      ),
    );
  }
}
```

#### Khmer Time Picker

```dart
import 'package:flutter/material.dart';
import 'package:kdt/kdt.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: KhTimePicker(
          initialTime: TimeOfDay.now(),
          onTimeSelected: (time) {
            print('Selected time: ${time.hour}:${time.minute}');
          },
          useKhmerDigits: true,
          showSeconds: true,
          backgroundColor: Colors.teal.shade100,
        ),
      ),
    );
  }
}
```

#### Khmer Calendar

```dart
import 'package:flutter/material.dart';
import 'package:kdt/kdt.dart';

class MyCalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khmer Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: KhCalendar(
          initialDate: DateTime.now(),
          onDateSelected: (date) {
            print('Selected date: $date');
          },
          useKhmerDigits: true,
          primaryColor: Colors.teal,
          showBuddhistYear: true,
        ),
      ),
    );
  }
}
```

#### Khmer Date Range Picker

```dart
import 'package:flutter/material.dart';
import 'package:kdt/kdt.dart';

class MyDateRangePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khmer Date Range')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: KhDateRangePicker(
          initialStartDate: DateTime.now(),
          initialEndDate: DateTime.now().add(Duration(days: 7)),
          onDateRangeSelected: (dateRange) {
            print('From: ${dateRange.start}, To: ${dateRange.end}');
          },
          useKhmerDigits: true,
          useBuddhistYear: true,
          backgroundColor: Colors.teal.shade100,
          maxDateSpan: 30, // Optional: limit to 30 days
        ),
      ),
    );
  }
}
```

## 📚 API Reference

### Core Classes

#### KhmerDateFormatter

Format dates and times in Khmer language.

| Method | Description |
|--------|-------------|
| `formatBuddhistYear(int year)` | Converts a Gregorian year to Buddhist year (CE + 543) |
| `formatDateTime(DateTime, {useKhmerDigits})` | Formats a DateTime with Khmer month names and optional Khmer numerals |
| `formatDate(DateTime, {useKhmerDigits})` | Formats just the date part without time |
| `formatDateWithWeekday(DateTime, {useKhmerDigits})` | Formats date with Khmer weekday name |
| `formatTime(TimeOfDay, {useKhmerDigits})` | Formats time with Khmer AM/PM indicators |

#### KhmerDateParser

Parse Khmer date strings back into DateTime objects.

| Method | Description |
|--------|-------------|
| `parse(String khmerDateString)` | Parses a Khmer date string into a DateTime object |
| `parseDateTime(String khmerDateTimeString)` | Parses a Khmer date and time string into a DateTime object |

#### KhmerNumerals

Convert between Arabic and Khmer numerals.

| Method | Description |
|--------|-------------|
| `convert(String input)` | Converts Arabic numerals in a string to Khmer numerals |
| `format(String input)` | Alias for `convert` |
| `convertToArabic(String input)` | Converts Khmer numerals in a string to Arabic numerals |
| `parseInteger(String input)` | Extracts an integer value from text with Khmer numerals |
| `parseDouble(String input)` | Extracts a decimal value from text with Khmer numerals |

### Utility Classes

#### KhDateUtils

Common date helpers and conversions.

| Method | Description |
|--------|-------------|
| `toBuddhistYear(int gregorianYear)` | Converts a Gregorian year to Buddhist year (CE + 543) |
| `toGregorianYear(int buddhistYear)` | Converts a Buddhist year to Gregorian year |
| `isLeapYear(int year)` | Checks if a year is a leap year |
| `daysInMonth(int year, int month)` | Gets the number of days in a month |
| `startDayOfMonth(int year, int month)` | Gets the weekday of the first day of a month |
| `dayOfYear(DateTime date)` | Gets the day of year (1-366) |
| `weekNumber(DateTime date)` | Gets the ISO week number |
| `isSameDay(DateTime date1, DateTime date2)` | Checks if two dates are on the same day |
| `isToday(DateTime date)` | Checks if a date is today |
| `startOfDay(DateTime date)` | Returns a DateTime at 00:00:00 on the given day |
| `endOfDay(DateTime date)` | Returns a DateTime at 23:59:59.999 on the given day |

#### KhDateCalculator

Date arithmetic operations.

| Method | Description |
|--------|-------------|
| `addDays(DateTime date, int days)` | Adds days to a date |
| `addMonths(DateTime date, int months)` | Adds months to a date |
| `addYears(DateTime date, int years)` | Adds years to a date |
| `addHours/addMinutes/addSeconds` | Adds hours, minutes, or seconds to a date |
| `daysBetween(DateTime from, DateTime to)` | Calculates days between two dates |
| `monthsBetween(DateTime from, DateTime to)` | Calculates months between two dates |
| `yearsBetween(DateTime from, DateTime to)` | Calculates years between two dates |
| `firstDayOfMonth/lastDayOfMonth` | Gets the first/last day of a month |
| `firstDayOfWeek/lastDayOfWeek` | Gets the first/last day of a week |
| `firstDayOfYear/lastDayOfYear` | Gets the first/last day of a year |

#### KhTimeZoneUtils

Cambodia timezone utilities.

| Method | Description |
|--------|-------------|
| `toKhmerLocalTime(DateTime utcTime)` | Converts UTC time to Cambodia time |
| `toUtcFromKhmerTime(DateTime khmerLocalTime)` | Converts Cambodia time to UTC |
| `nowInKhmerTimeZone()` | Gets the current time in Cambodia |
| `formatOffset(double offsetHours)` | Formats a timezone offset as string |
| `khmerDateTime(year, month, day, [hour, minute, ...])` | Creates a DateTime in Cambodia timezone |
| `getCurrentKhmerUtcOffset()` | Gets the UTC offset for Cambodia |
| `isKhmerTimeZone(DateTime dateTime)` | Checks if a DateTime is in Cambodia timezone |
| `getKhmerDate(DateTime dateTime)` | Gets just the date part in Cambodia timezone |

## 📱 Example App

Check out the `/example` directory for a complete Flutter application demonstrating all components of this package. The example app showcases each feature with practical use cases and customization options.

To run the example app:

```bash
cd example
flutter pub get
flutter run
```

## 🖥️ Supported Platforms

This package is primarily built for Flutter and has been tested on:

- **Mobile**
  - Android 5.0+ (API 21+)
  - iOS 11.0+

- **Web**
  - Chrome, Firefox, Safari, Edge

- **Desktop**
  - Windows
  - macOS
  - Linux

## 🤝 Contributing

Contributions are welcome! If you'd like to contribute, please:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate and follow the [Flutter style guide](https://dart.dev/guides/language/effective-dart/style).


## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 About the Author

**sovanken** is a passionate Flutter developer focused on creating meaningful tools and experiences. With a deep interest in accessibility, localization, and building products that make a difference, sovanken is committed to creating high-quality, open-source solutions that empower developers and users alike.

- GitHub: [sovanken](https://github.com/sovanken)
- Buy Me a Coffee: [sovanken](https://www.buymeacoffee.com/sovanken)

