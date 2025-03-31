import 'package:flutter/material.dart';
import '../core/khmer_numerals.dart';
import '../localization/kh_locale_data.dart';
import '../utils/date_utils.dart';
import '../localization/kh_labels.dart';

/// A date picker widget that displays dates in Khmer format.
///
/// This widget provides a customizable date picker that shows dates using
/// Khmer numerals, month names, and follows the Buddhist calendar year convention.
class KhDatePicker extends StatefulWidget {
  /// The initially selected date
  final DateTime? initialDate;

  /// Callback function that is called when a date is selected
  final Function(DateTime) onDateSelected;

  /// Optional text style for the date display
  final TextStyle? dateStyle;

  /// Optional background color for the date picker
  final Color? backgroundColor;

  /// Optional text color for the date display
  final Color? textColor;

  /// Optional border radius for the date picker container
  final double borderRadius;

  /// Whether to display the date using Khmer numerals
  final bool useKhmerDigits;

  /// Whether to display the Buddhist calendar year (CE + 543)
  final bool useBuddhistYear;

  /// Creates a Khmer date picker widget
  ///
  /// [onDateSelected] is required and will be called whenever the user selects a date.
  /// [initialDate] defaults to the current date if not provided.
  const KhDatePicker({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    this.dateStyle,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 8.0,
    this.useKhmerDigits = true,
    this.useBuddhistYear = true,
  });

  @override
  State<KhDatePicker> createState() => _KhDatePickerState();
}

class _KhDatePickerState extends State<KhDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  /// Formats a DateTime into Khmer date string including weekday, day, month and year
  String _formatDate(DateTime date) {
    final day = widget.useKhmerDigits
        ? KhmerNumerals.convert(date.day.toString())
        : date.day.toString();

    final month = KhLocaleData.khmerMonths[date.month - 1];

    final year = widget.useBuddhistYear
        ? KhDateUtils.toBuddhistYear(date.year).toString()
        : date.year.toString();

    final formattedYear =
        widget.useKhmerDigits ? KhmerNumerals.convert(year) : year;

    final weekday = KhLocaleData.khmerDays[date.weekday % 7];

    return 'ថ្ងៃ$weekday $day ${KhLabels.month}$month ${KhLabels.year}$formattedYear';
  }

  /// Shows the date picker dialog and updates the selected date
  void _pickDate() async {
    final firstDate = DateTime(1900);
    final lastDate = DateTime(2100);

    // Configure Dialog Theme
    final colorScheme = ColorScheme.light(
      primary: widget.backgroundColor ?? Theme.of(context).primaryColor,
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme,
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
      helpText: KhLabels.selectDate,
      cancelText: KhLabels.cancel,
      confirmText: KhLabels.ok,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).primaryColor;
    final bgColor = widget.backgroundColor ?? Colors.grey[200];
    final txtColor = widget.textColor ?? Colors.black87;

    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _formatDate(_selectedDate),
                style: widget.dateStyle ??
                    TextStyle(
                      fontSize: 16,
                      color: txtColor,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: defaultColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
