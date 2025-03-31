// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:kdt/kdt.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const KDTExampleApp());
}

class KDTExampleApp extends StatelessWidget {
  const KDTExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KDT Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Battambang',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const FormattingPage(),
    const NumeralsPage(),
    const ParsingPage(),
    const CalculationPage(),
    const TimezonePage(),
    const WidgetsPage(),
  ];

  final List<String> _titles = [
    'Date Formatting',
    'Khmer Numerals',
    'Date Parsing',
    'Date Calculations',
    'Timezone Utils',
    'UI Widgets',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KDT - ${_titles[_currentIndex]}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'Format',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag),
            label: 'Numerals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Parse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Timezone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Widgets',
          ),
        ],
      ),
    );
  }
}

// ================ FORMATTING PAGE ================
class FormattingPage extends StatefulWidget {
  const FormattingPage({super.key});

  @override
  State<FormattingPage> createState() => _FormattingPageState();
}

class _FormattingPageState extends State<FormattingPage> {
  final DateTime _now = DateTime.now();
  bool _useKhmerDigits = true;
  bool _useBuddhistYear = true;

  @override
  Widget build(BuildContext context) {
    final formattedDateTime = KhmerDateFormatter.formatDateTime(
      _now,
      useKhmerDigits: _useKhmerDigits,
    );

    final formattedDate = KhmerDateFormatter.formatDate(
      _now,
      useKhmerDigits: _useKhmerDigits,
    );

    final formattedDateWithWeekday = KhmerDateFormatter.formatDateWithWeekday(
      _now,
      useKhmerDigits: _useKhmerDigits,
    );

    final time = TimeOfDay.fromDateTime(_now);
    final formattedTime = KhmerDateFormatter.formatTime(
      time,
      useKhmerDigits: _useKhmerDigits,
    );

    final gregorianYear = _now.year;
    final buddhistYear = KhDateUtils.toBuddhistYear(gregorianYear);
    final displayedBuddhistYear = _useKhmerDigits
        ? KhmerNumerals.convert(buddhistYear.toString())
        : buddhistYear.toString();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Date Formatting Examples'),

          const SizedBox(height: 16),

          // Settings toggles
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Use Khmer Digits'),
                    value: _useKhmerDigits,
                    onChanged: (value) {
                      setState(() {
                        _useKhmerDigits = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Use Buddhist Year'),
                    value: _useBuddhistYear,
                    onChanged: (value) {
                      setState(() {
                        _useBuddhistYear = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Display examples
          _buildFormattingExample(
            'Full Date & Time',
            formattedDateTime,
            'KhmerDateFormatter.formatDateTime(_now, useKhmerDigits: $_useKhmerDigits)',
          ),

          _buildFormattingExample(
            'Date Only',
            formattedDate,
            'KhmerDateFormatter.formatDate(_now, useKhmerDigits: $_useKhmerDigits)',
          ),

          _buildFormattingExample(
            'Date with Weekday',
            formattedDateWithWeekday,
            'KhmerDateFormatter.formatDateWithWeekday(_now, useKhmerDigits: $_useKhmerDigits)',
          ),

          _buildFormattingExample(
            'Time Only',
            formattedTime,
            'KhmerDateFormatter.formatTime(TimeOfDay.fromDateTime(_now), useKhmerDigits: $_useKhmerDigits)',
          ),

          _buildFormattingExample(
            'Buddhist Year',
            '$gregorianYear CE → $displayedBuddhistYear BE',
            'KhDateUtils.toBuddhistYear($gregorianYear)',
          ),
        ],
      ),
    );
  }

  Widget _buildFormattingExample(
      String title, String formattedText, String codeExample) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                formattedText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                codeExample,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: Colors.indigo[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

// ================ NUMERALS PAGE ================
class NumeralsPage extends StatefulWidget {
  const NumeralsPage({super.key});

  @override
  State<NumeralsPage> createState() => _NumeralsPageState();
}

class _NumeralsPageState extends State<NumeralsPage> {
  final TextEditingController _arabicController = TextEditingController();
  final TextEditingController _khmerController = TextEditingController();
  final TextEditingController _khmerTextController = TextEditingController(
    text: 'តម្លៃៈ ១២៣.៤៥ ដុល្លារ',
  );

  String _convertedToKhmer = '';
  String _convertedToArabic = '';
  String _extractedInteger = '';
  String _extractedDouble = '';

  @override
  void initState() {
    super.initState();
    _arabicController.text = '2024';
    _khmerController.text = '២០២៤';
    _updateExtractedValues();
  }

  @override
  void dispose() {
    _arabicController.dispose();
    _khmerController.dispose();
    _khmerTextController.dispose();
    super.dispose();
  }

  void _convertToKhmer() {
    setState(() {
      _convertedToKhmer = KhmerNumerals.convert(_arabicController.text);
    });
  }

  void _convertToArabic() {
    setState(() {
      _convertedToArabic = KhmerNumerals.convertToArabic(_khmerController.text);
    });
  }

  void _updateExtractedValues() {
    final text = _khmerTextController.text;
    final integer = KhmerNumerals.parseInteger(text);
    final double = KhmerNumerals.parseDouble(text);

    setState(() {
      _extractedInteger = integer?.toString() ?? 'No integer found';
      _extractedDouble = double?.toString() ?? 'No decimal found';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Arabic ↔ Khmer Conversion'),

          const SizedBox(height: 16),

          // Arabic to Khmer
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Arabic to Khmer',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  TextField(
                    controller: _arabicController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Arabic numerals',
                      hintText: 'Example: 2024',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _convertToKhmer,
                    child: const Text('Convert'),
                  ),
                  if (_convertedToKhmer.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.teal),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Result:'),
                          const SizedBox(height: 8),
                          Text(
                            _convertedToKhmer,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Code: KhmerNumerals.convert("${_arabicController.text}")',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Khmer to Arabic
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Khmer to Arabic',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  TextField(
                    controller: _khmerController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Khmer numerals',
                      hintText: 'Example: ២០២៤',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _convertToArabic,
                    child: const Text('Convert'),
                  ),
                  if (_convertedToArabic.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.teal),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Result:'),
                          const SizedBox(height: 8),
                          Text(
                            _convertedToArabic,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Code: KhmerNumerals.convertToArabic("${_khmerController.text}")',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Extracting Numbers from Text'),

          const SizedBox(height: 16),

          // Text parsing
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parse Numbers from Khmer Text',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  TextField(
                    controller: _khmerTextController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Khmer text with numbers',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateExtractedValues,
                    child: const Text('Extract Values'),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Extracted Integer'),
                    subtitle: Text(
                      _extractedInteger,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tileColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text('Extracted Decimal'),
                    subtitle: Text(
                      _extractedDouble,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tileColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Code: KhmerNumerals.parseInteger(text) / KhmerNumerals.parseDouble(text)',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

// ================ PARSING PAGE ================
class ParsingPage extends StatefulWidget {
  const ParsingPage({super.key});

  @override
  State<ParsingPage> createState() => _ParsingPageState();
}

class _ParsingPageState extends State<ParsingPage> {
  final TextEditingController _dateController = TextEditingController(
    text: '១៥ មករា ២៥៦៧',
  );
  final TextEditingController _dateTimeController = TextEditingController(
    text: '១៥ មករា ២៥៦៧, ១០:៣០ ព្រឹក',
  );

  DateTime? _parsedDate;
  DateTime? _parsedDateTime;
  String _dateError = '';
  String _dateTimeError = '';

  @override
  void dispose() {
    _dateController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  void _parseDate() {
    setState(() {
      try {
        _parsedDate = KhmerDateParser.parse(_dateController.text);
        _dateError = _parsedDate == null ? 'Could not parse date' : '';
      } catch (e) {
        _dateError = 'Error: $e';
        _parsedDate = null;
      }
    });
  }

  void _parseDateTime() {
    setState(() {
      try {
        _parsedDateTime =
            KhmerDateParser.parseDateTime(_dateTimeController.text);
        _dateTimeError =
            _parsedDateTime == null ? 'Could not parse date and time' : '';
      } catch (e) {
        _dateTimeError = 'Error: $e';
        _parsedDateTime = null;
      }
    });
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'No date parsed';
    return DateFormat('EEEE, MMMM d, y').format(dt);
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'No date/time parsed';
    return DateFormat('EEEE, MMMM d, y - h:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Parse Khmer Date Strings'),

          const SizedBox(height: 16),

          // Parse date
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parse Date Only',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Khmer date',
                      hintText: 'Example: ១៥ មករា ២៥៦៧',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (_dateError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _dateError,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _parseDate,
                    child: const Text('Parse Date'),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Parsed Result:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(_parsedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (_parsedDate != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Raw: ${_parsedDate.toString()}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Code: KhmerDateParser.parse("${_dateController.text}")',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Parse date and time
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parse Date and Time',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  TextField(
                    controller: _dateTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Khmer date and time',
                      hintText: 'Example: ១៥ មករា ២៥៦៧, ១០:៣០ ព្រឹក',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (_dateTimeError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _dateTimeError,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _parseDateTime,
                    child: const Text('Parse Date & Time'),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Parsed Result:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDateTime(_parsedDateTime),
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (_parsedDateTime != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Raw: ${_parsedDateTime.toString()}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Code: KhmerDateParser.parseDateTime("${_dateTimeController.text}")',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

// ================ CALCULATION PAGE ================
class CalculationPage extends StatefulWidget {
  const CalculationPage({super.key});

  @override
  State<CalculationPage> createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  final DateTime _now = DateTime.now();
  late DateTime _resultDate;
  final TextEditingController _valueController =
      TextEditingController(text: '7');

  String _operation = 'addDays';
  final String _timePeriod = 'days';

  final bool _useKhmerDigits = true;

  // Date differences
  late DateTime _date1;
  late DateTime _date2;
  int _daysDifference = 0;
  int _monthsDifference = 0;
  int _yearsDifference = 0;

  @override
  void initState() {
    super.initState();
    _resultDate = _now;

    // Initialize dates for difference calculation
    _date1 = DateTime(_now.year, _now.month, _now.day);
    _date2 = DateTime(_now.year, _now.month, _now.day + 30);
    _calculateDifferences();
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _performCalculation() {
    final int value = int.tryParse(_valueController.text) ?? 0;

    setState(() {
      switch (_operation) {
        case 'addDays':
          _resultDate = KhDateCalculator.addDays(_now, value);
          break;
        case 'addMonths':
          _resultDate = KhDateCalculator.addMonths(_now, value);
          break;
        case 'addYears':
          _resultDate = KhDateCalculator.addYears(_now, value);
          break;
        case 'addHours':
          _resultDate = KhDateCalculator.addHours(_now, value);
          break;
        case 'addMinutes':
          _resultDate = KhDateCalculator.addMinutes(_now, value);
          break;
      }
    });
  }

  void _calculateDifferences() {
    setState(() {
      _daysDifference = KhDateCalculator.daysBetween(_date1, _date2);
      _monthsDifference = KhDateCalculator.monthsBetween(_date1, _date2);
      _yearsDifference = KhDateCalculator.yearsBetween(_date1, _date2);
    });
  }

  String _formatDate(DateTime date, {bool withTime = true}) {
    if (withTime) {
      return KhmerDateFormatter.formatDateTime(date,
          useKhmerDigits: _useKhmerDigits);
    } else {
      return KhmerDateFormatter.formatDate(date,
          useKhmerDigits: _useKhmerDigits);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Date Arithmetic'),

          const SizedBox(height: 16),

          // Date arithmetic
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add or Subtract Time Periods',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),

                  // Base date
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Base Date:'),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(_now),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Operation selection
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _operation,
                          decoration: const InputDecoration(
                            labelText: 'Operation',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'addDays',
                              child: Text('Add/Subtract Days'),
                            ),
                            DropdownMenuItem(
                              value: 'addMonths',
                              child: Text('Add/Subtract Months'),
                            ),
                            DropdownMenuItem(
                              value: 'addYears',
                              child: Text('Add/Subtract Years'),
                            ),
                            DropdownMenuItem(
                              value: 'addHours',
                              child: Text('Add/Subtract Hours'),
                            ),
                            DropdownMenuItem(
                              value: 'addMinutes',
                              child: Text('Add/Subtract Minutes'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _operation = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _valueController,
                          decoration: const InputDecoration(
                            labelText: 'Value',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _performCalculation,
                    child: const Text('Calculate'),
                  ),

                  const SizedBox(height: 16),

                  // Result
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Result:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(_resultDate),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Code: KhDateCalculator.$_operation(date, ${_valueController.text})',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Date Differences'),

          const SizedBox(height: 16),

          // Date differences
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calculate Differences Between Dates',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Start Date:'),
                              Text(
                                _formatDate(_date1, withTime: false),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('End Date:'),
                              Text(
                                _formatDate(_date2, withTime: false),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Differences display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Days: $_daysDifference',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Months: $_monthsDifference',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Years: $_yearsDifference',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Code: KhDateCalculator.daysBetween(date1, date2)',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

// ================ TIMEZONE PAGE ================
class TimezonePage extends StatefulWidget {
  const TimezonePage({super.key});

  @override
  State<TimezonePage> createState() => _TimezonePageState();
}

class _TimezonePageState extends State<TimezonePage> {
  final DateTime _utcNow = DateTime.now().toUtc();
  late DateTime _khmerTime;
  late DateTime _convertedBack;

  bool _useKhmerDigits = true;

  @override
  void initState() {
    super.initState();
    _updateTimes();
  }

  void _updateTimes() {
    setState(() {
      _khmerTime = KhTimeZoneUtils.toKhmerLocalTime(_utcNow);
      _convertedBack = KhTimeZoneUtils.toUtcFromKhmerTime(_khmerTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Timezone Utilities'),

          const SizedBox(height: 16),

          // Timezone conversion
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UTC ↔ Cambodia Time Conversion',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),

                  // Settings toggle
                  SwitchListTile(
                    title: const Text('Use Khmer Digits'),
                    value: _useKhmerDigits,
                    onChanged: (value) {
                      setState(() {
                        _useKhmerDigits = value;
                      });
                    },
                    tileColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _updateTimes,
                    child: const Text('Refresh Times'),
                  ),

                  const SizedBox(height: 16),

                  // UTC time
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.public),
                            SizedBox(width: 8),
                            Text(
                              'UTC Time:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('EEEE, MMMM d, y - HH:mm:ss')
                              .format(_utcNow),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Raw: $_utcNow',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.teal[700],
                        size: 24,
                      ),
                    ),
                  ),

                  // Cambodia time
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 8),
                            Text(
                              'Cambodia Time (ICT):',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          KhmerDateFormatter.formatDateTime(
                            _khmerTime,
                            useKhmerDigits: _useKhmerDigits,
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Raw: $_khmerTime',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Code: KhTimeZoneUtils.toKhmerLocalTime(utcTime)',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.teal[700],
                        size: 24,
                      ),
                    ),
                  ),

                  // Converted back to UTC
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.public),
                            SizedBox(width: 8),
                            Text(
                              'Converted Back to UTC:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('EEEE, MMMM d, y - HH:mm:ss')
                              .format(_convertedBack),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Raw: $_convertedBack',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Code: KhTimeZoneUtils.toUtcFromKhmerTime(khmerTime)',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Current Cambodia time
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Cambodia Time',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Now in Khmer Time Zone:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          KhmerDateFormatter.formatDateTime(
                            KhTimeZoneUtils.nowInKhmerTimeZone(),
                            useKhmerDigits: _useKhmerDigits,
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cambodia Timezone: UTC${KhTimeZoneUtils.cambodiaTimeZone} (${KhTimeZoneUtils.cambodiaTimeZoneName})',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Code: KhTimeZoneUtils.nowInKhmerTimeZone()',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

// ================ WIDGETS PAGE ================
class WidgetsPage extends StatefulWidget {
  const WidgetsPage({super.key});

  @override
  State<WidgetsPage> createState() => _WidgetsPageState();
}

class _WidgetsPageState extends State<WidgetsPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTimeRange _selectedRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 7)),
  );
  DateTime? _calendarSelectedDate;

  bool _useKhmerDigits = true;
  bool _useBuddhistYear = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('KDT UI Components'),

          const SizedBox(height: 8),

          // Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Use Khmer Digits'),
                    value: _useKhmerDigits,
                    onChanged: (value) {
                      setState(() {
                        _useKhmerDigits = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Use Buddhist Year'),
                    value: _useBuddhistYear,
                    onChanged: (value) {
                      setState(() {
                        _useBuddhistYear = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Date picker
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Khmer Date Picker',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: KhDatePicker(
                        initialDate: _selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        useKhmerDigits: _useKhmerDigits,
                        useBuddhistYear: _useBuddhistYear,
                        backgroundColor: Colors.teal.shade100,
                        textColor: Colors.teal.shade900,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Date:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Time picker
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Khmer Time Picker',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: KhTimePicker(
                        initialTime: _selectedTime,
                        onTimeSelected: (time) {
                          setState(() {
                            _selectedTime = time;
                          });
                        },
                        useKhmerDigits: _useKhmerDigits,
                        showSeconds: true,
                        backgroundColor: Colors.teal.shade100,
                        textColor: Colors.teal.shade900,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Time:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Date range picker
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Khmer Date Range Picker',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: KhDateRangePicker(
                      initialStartDate: _selectedRange.start,
                      initialEndDate: _selectedRange.end,
                      onDateRangeSelected: (dateRange) {
                        setState(() {
                          _selectedRange = dateRange;
                        });
                      },
                      useKhmerDigits: _useKhmerDigits,
                      useBuddhistYear: _useBuddhistYear,
                      backgroundColor: Colors.teal.shade100,
                      textColor: Colors.teal.shade900,
                      maxDateSpan: 30,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Range:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${DateFormat('MMM d, y').format(_selectedRange.start)} - ${DateFormat('MMM d, y').format(_selectedRange.end)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Duration: ${_selectedRange.duration.inDays} days',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Calendar
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Khmer Calendar',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: KhCalendar(
                      initialDate: DateTime.now(),
                      onDateSelected: (date) {
                        setState(() {
                          _calendarSelectedDate = date;
                        });
                      },
                      useKhmerDigits: _useKhmerDigits,
                      primaryColor: Colors.teal,
                      showBuddhistYear: _useBuddhistYear,
                      highlightToday: true,
                    ),
                  ),
                  if (_calendarSelectedDate != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.teal),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Calendar Date:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE, MMMM d, y')
                                .format(_calendarSelectedDate!),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
