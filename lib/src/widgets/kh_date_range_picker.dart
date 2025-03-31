import 'package:flutter/material.dart';
import '../core/khmer_numerals.dart';
import '../localization/kh_locale_data.dart';
import '../utils/date_utils.dart';
import '../localization/kh_labels.dart';

/// A date range picker that displays dates in Khmer format.
///
/// This widget allows users to select a start and end date with Khmer
/// calendar localization.
class KhDateRangePicker extends StatefulWidget {
  /// Initial start date
  final DateTime? initialStartDate;

  /// Initial end date
  final DateTime? initialEndDate;

  /// Called when a date range is selected
  final Function(DateTimeRange) onDateRangeSelected;

  /// Whether to use Khmer numerals for displaying dates
  final bool useKhmerDigits;

  /// Whether to use Buddhist calendar year (CE + 543)
  final bool useBuddhistYear;

  /// Text style for the displayed dates
  final TextStyle? dateStyle;

  /// Background color for the picker
  final Color? backgroundColor;

  /// Text color for the picker
  final Color? textColor;

  /// Label for the start date
  final String? startDateLabel;

  /// Label for the end date
  final String? endDateLabel;

  /// Maximum allowed date span in days (null for unlimited)
  final int? maxDateSpan;

  /// Border radius for the date picker containers
  final double borderRadius;

  /// Creates a Khmer date range picker widget
  const KhDateRangePicker({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onDateRangeSelected,
    this.useKhmerDigits = true,
    this.useBuddhistYear = true,
    this.dateStyle,
    this.backgroundColor,
    this.textColor,
    this.startDateLabel,
    this.endDateLabel,
    this.maxDateSpan,
    this.borderRadius = 8.0,
  });

  @override
  State<KhDateRangePicker> createState() => _KhDateRangePickerState();
}

class _KhDateRangePickerState extends State<KhDateRangePicker> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;

    if (_startDate != null && _endDate != null) {
      _validateDateRange();
    }
  }

  void _validateDateRange() {
    if (_startDate != null && _endDate != null) {
      if (_endDate!.isBefore(_startDate!)) {
        // Swap dates if end is before start
        final temp = _startDate;
        _startDate = _endDate;
        _endDate = temp;
      }

      if (widget.maxDateSpan != null) {
        final difference = _endDate!.difference(_startDate!).inDays;
        if (difference > widget.maxDateSpan!) {
          setState(() {
            _errorMessage = KhLabels.maxDateRangeMessage(widget.maxDateSpan!);
          });
          return;
        }
      }

      setState(() {
        _errorMessage = null;
      });

      widget.onDateRangeSelected(DateTimeRange(
        start: _startDate!,
        end: _endDate!,
      ));
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString();
    final month = KhLocaleData.khmerMonths[date.month - 1];
    final year = widget.useBuddhistYear
        ? KhDateUtils.toBuddhistYear(date.year).toString()
        : date.year.toString();

    String formatted = '$day ${KhLabels.month}$month ${KhLabels.year}$year';

    if (widget.useKhmerDigits) {
      formatted = KhmerNumerals.convert(formatted);
    }

    return formatted;
  }

  Future<void> _pickStartDate() async {
    final initialDate = _startDate ?? DateTime.now();
    final firstDate = DateTime(initialDate.year - 10);
    final lastDate = _endDate ?? DateTime(initialDate.year + 10);

    final colorScheme = ColorScheme.light(
      primary: widget.backgroundColor ?? Theme.of(context).primaryColor,
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: colorScheme,
        ),
        child: child!,
      ),
      helpText: widget.startDateLabel ?? KhLabels.startDate,
      cancelText: KhLabels.cancel,
      confirmText: KhLabels.ok,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        _validateDateRange();
      });
    }
  }

  Future<void> _pickEndDate() async {
    final initialDate = _endDate ?? _startDate ?? DateTime.now();
    final firstDate = _startDate ?? DateTime(initialDate.year - 10);
    final lastDate = DateTime(initialDate.year + 10);

    final colorScheme = ColorScheme.light(
      primary: widget.backgroundColor ?? Theme.of(context).primaryColor,
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: colorScheme,
        ),
        child: child!,
      ),
      helpText: widget.endDateLabel ?? KhLabels.endDate,
      cancelText: KhLabels.cancel,
      confirmText: KhLabels.ok,
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
        _validateDateRange();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).primaryColor;
    final bgColor = widget.backgroundColor ?? Colors.grey[200];
    final txtColor = widget.textColor ?? Colors.black87;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Start date selector
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.startDateLabel ?? KhLabels.startDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: _pickStartDate,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _startDate != null
                                  ? _formatDate(_startDate!)
                                  : '---',
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
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // End date selector
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.endDateLabel ?? KhLabels.endDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: _pickEndDate,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _endDate != null ? _formatDate(_endDate!) : '---',
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
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        if (_startDate != null && _endDate != null && _errorMessage == null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.useKhmerDigits
                  ? KhmerNumerals.convert(KhLabels.days(
                      _endDate!.difference(_startDate!).inDays + 1))
                  : KhLabels.days(_endDate!.difference(_startDate!).inDays + 1),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
      ],
    );
  }
}
