import 'package:flutter/material.dart';
import '../core/khmer_numerals.dart';
import '../localization/kh_locale_data.dart';
import '../utils/date_utils.dart';
import '../utils/date_calculator.dart';

/// A calendar widget that displays dates in Khmer format.
///
/// This widget shows a monthly calendar with Khmer weekday names,
/// month names, and optionally Khmer numerals.
class KhCalendar extends StatefulWidget {
  /// Initial month and year to display
  final DateTime? initialDate;

  /// Called when a date is selected
  final Function(DateTime)? onDateSelected;

  /// Whether to use Khmer numerals for day numbers
  final bool useKhmerDigits;

  /// Primary color for the calendar (selected date, header)
  final Color? primaryColor;

  /// Background color for the calendar
  final Color? backgroundColor;

  /// Text style for the month/year header
  final TextStyle? headerStyle;

  /// Text style for weekday labels
  final TextStyle? weekdayStyle;

  /// Text style for day numbers
  final TextStyle? dayStyle;

  /// Whether to highlight today's date
  final bool highlightToday;

  /// Whether to show the current Buddhist year in the header
  final bool showBuddhistYear;

  /// Creates a Khmer calendar widget
  const KhCalendar({
    super.key,
    this.initialDate,
    this.onDateSelected,
    this.useKhmerDigits = true,
    this.primaryColor,
    this.backgroundColor,
    this.headerStyle,
    this.weekdayStyle,
    this.dayStyle,
    this.highlightToday = true,
    this.showBuddhistYear = true,
  });

  @override
  State<KhCalendar> createState() => _KhCalendarState();
}

class _KhCalendarState extends State<KhCalendar> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialDate ?? DateTime.now();
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = KhDateCalculator.addMonths(_currentMonth, 1);
    });
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = KhDateCalculator.addMonths(_currentMonth, -1);
    });
  }

  String _formatMonthYear() {
    final month = KhLocaleData.khmerMonths[_currentMonth.month - 1];
    final year = widget.showBuddhistYear
        ? KhDateUtils.toBuddhistYear(_currentMonth.year).toString()
        : _currentMonth.year.toString();

    final formattedYear =
        widget.useKhmerDigits ? KhmerNumerals.convert(year) : year;

    return 'ខែ$month ឆ្នាំ$formattedYear';
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: widget.primaryColor ?? Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: _previousMonth,
          ),
          Text(
            _formatMonthYear(),
            style: widget.headerStyle ??
                const TextStyle(
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          // Starting with Sunday (0)
          //final weekdayText = KhLocaleData.khmerDays[index];

          // Take just the first character for shorter display
          //final shortName = weekdayText.characters.first;
          final shortName = KhLocaleData.khmerDaysShort[index];

          return Expanded(
            child: Center(
              child: Text(
                shortName,
                style: widget.weekdayStyle ??
                    TextStyle(
                      fontSize: 14,
                      //fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDayCell(int? day, bool isCurrentMonth) {
    if (day == null) {
      return const SizedBox.shrink();
    }

    final now = DateTime.now();
    final cellDate = DateTime(_currentMonth.year, _currentMonth.month, day);

    final isToday = widget.highlightToday &&
        isCurrentMonth &&
        now.year == cellDate.year &&
        now.month == cellDate.month &&
        now.day == cellDate.day;

    final isSelected = _selectedDate != null &&
        _selectedDate!.year == cellDate.year &&
        _selectedDate!.month == cellDate.month &&
        _selectedDate!.day == cellDate.day;

    final dayText = widget.useKhmerDigits
        ? KhmerNumerals.convert(day.toString())
        : day.toString();

    // Get the primary color
    final primaryColor = widget.primaryColor ?? Theme.of(context).primaryColor;

    // Create a semi-transparent version for today's highlight (30% opacity)
    final todayColor = primaryColor.withAlpha(76); // 0.3 * 255 ≈ 76

    return InkWell(
      onTap: isCurrentMonth
          ? () {
              setState(() {
                _selectedDate = cellDate;
              });
              if (widget.onDateSelected != null) {
                widget.onDateSelected!(cellDate);
              }
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? primaryColor
              : isToday
                  ? todayColor
                  : Colors.transparent,
        ),
        child: Center(
          child: Text(
            dayText,
            style: widget.dayStyle?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : isCurrentMonth
                          ? Colors.black
                          : Colors.grey[400],
                ) ??
                TextStyle(
                  fontSize: 14,
                  // fontWeight: isToday || isSelected
                  //     ? FontWeight.bold
                  //     : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : isCurrentMonth
                          ? Colors.black
                          : Colors.grey[400],
                ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCalendarDays() {
    final daysInMonth =
        KhDateUtils.daysInMonth(_currentMonth.year, _currentMonth.month);

    // 0 = Sunday, 6 = Saturday
    final firstDayOffset =
        KhDateUtils.startDayOfMonth(_currentMonth.year, _currentMonth.month);

    // Previous month
    final prevMonth = KhDateCalculator.addMonths(_currentMonth, -1);
    final daysInPrevMonth =
        KhDateUtils.daysInMonth(prevMonth.year, prevMonth.month);

    final days = <Widget>[];

    // Days from previous month
    for (int i = 0; i < firstDayOffset; i++) {
      days.add(_buildDayCell(daysInPrevMonth - firstDayOffset + i + 1, false));
    }

    // Days from current month
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(_buildDayCell(i, true));
    }

    // Days from next month
    final remainingCells = 42 - days.length; // 6 rows of 7 days
    for (int i = 1; i <= remainingCells; i++) {
      days.add(_buildDayCell(i, false));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    // Create a shadow color with 10% opacity
    final shadowColor = Colors.black.withAlpha(26); // 0.1 * 255 ≈ 26

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _buildWeekdayHeaders(),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(8),
            children: _buildCalendarDays(),
          ),
        ],
      ),
    );
  }
}
