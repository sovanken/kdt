import 'package:flutter/material.dart';
import '../core/khmer_numerals.dart';
import '../localization/kh_locale_data.dart';
import '../localization/kh_labels.dart';

/// A time picker widget that displays time in Khmer format.
///
/// This widget provides a customizable time picker that shows time using
/// Khmer numerals and appropriate AM/PM indicators in Khmer language.
class KhTimePicker extends StatefulWidget {
  /// The initially selected time
  final TimeOfDay? initialTime;

  /// Callback function that is called when a time is selected
  final Function(TimeOfDay) onTimeSelected;

  /// Optional text style for the time display
  final TextStyle? timeStyle;

  /// Optional background color for the time picker
  final Color? backgroundColor;

  /// Optional text color for the time display
  final Color? textColor;

  /// Optional border radius for the time picker container
  final double borderRadius;

  /// Whether to display the time using Khmer numerals
  final bool useKhmerDigits;

  /// Whether to show seconds in the time display
  final bool showSeconds;

  /// Creates a Khmer time picker widget
  ///
  /// [onTimeSelected] is required and will be called whenever the user selects a time.
  /// [initialTime] defaults to the current time if not provided.
  const KhTimePicker({
    super.key,
    this.initialTime,
    required this.onTimeSelected,
    this.timeStyle,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 8.0,
    this.useKhmerDigits = true,
    this.showSeconds = false,
  });

  @override
  State<KhTimePicker> createState() => _KhTimePickerState();
}

class _KhTimePickerState extends State<KhTimePicker> {
  late TimeOfDay _selectedTime;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime ?? TimeOfDay.now();

    // Initialize seconds if we're showing them
    if (widget.showSeconds) {
      _seconds = DateTime.now().second;
    }
  }

  /// Formats a TimeOfDay into Khmer time string with hour, minute and period
  String _formatTime(TimeOfDay time) {
    final hour =
        _formatWithLeadingZero(time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod);

    final minute = _formatWithLeadingZero(time.minute);

    String timeString = '$hour:$minute';

    if (widget.showSeconds) {
      final second = _formatWithLeadingZero(_seconds);
      timeString += ':$second';
    }

    timeString +=
        ' ${time.period == DayPeriod.am ? KhLocaleData.am : KhLocaleData.pm}';

    if (widget.useKhmerDigits) {
      return KhmerNumerals.convert(timeString);
    }

    return timeString;
  }

  /// Formats a number with leading zero if it's less than 10
  String _formatWithLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  /// Shows the time picker dialog and updates the selected time
  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.backgroundColor ?? Theme.of(context).primaryColor,
            ),
            timePickerTheme: TimePickerThemeData(
              dayPeriodTextColor: widget.textColor,
              hourMinuteTextColor: widget.textColor,
              dialHandColor:
                  widget.backgroundColor ?? Theme.of(context).primaryColor,
              dialBackgroundColor:
                  (widget.backgroundColor ?? Theme.of(context).primaryColor)
                      .withOpacity(0.1),
            ),
          ),
          child: child!,
        );
      },
      helpText: KhLabels.selectTime,
      cancelText: KhLabels.cancel,
      confirmText: KhLabels.ok,
      hourLabelText: KhLabels.hour,
      minuteLabelText: KhLabels.minute,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;

        // Generate random seconds if we're showing them
        if (widget.showSeconds) {
          _seconds = DateTime.now().second;
        }
      });

      widget.onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).primaryColor;
    final bgColor = widget.backgroundColor ?? Colors.grey[200];
    final txtColor = widget.textColor ?? Colors.black87;

    return InkWell(
      onTap: _pickTime,
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
                _formatTime(_selectedTime),
                style: widget.timeStyle ??
                    TextStyle(
                      fontSize: 16,
                      color: txtColor,
                    ),
              ),
            ),
            Icon(
              Icons.access_time,
              color: defaultColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
