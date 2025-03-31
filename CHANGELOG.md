# Changelog

All notable changes to the KDT package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-03-31

### Added
- Initial public release
- Core date formatting with Khmer language support
- Khmer numerals conversion (Arabic ↔ Khmer)
- Date parsing for Khmer formatted strings
- Date calculation utilities (add/subtract periods, differences)
- Cambodia timezone (ICT/+07:00) support
- UI Components:
  - KhDatePicker - Date picker with Khmer localization
  - KhTimePicker - Time picker with Khmer localization 
  - KhCalendar - Monthly calendar with Khmer display
  - KhDateRangePicker - Date range picker with Khmer support
- Buddhist calendar year conversion (CE + 543)
- Comprehensive documentation and examples

### Fixed
- Resolved issue with Buddhist year calculation in date parser
- Fixed timezone conversion edge cases
- Corrected formatting of AM/PM indicators in time display

## [0.0.1-dev] - 2025-03-15

### Added
- Initial development release (pre-release)
- Basic formatting functions
- Preliminary widget implementations