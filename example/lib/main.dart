// ignore_for_file: unused_field, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          _buildSectionTitle('Date Formatting Examples', Icons.format_quote),

          const SizedBox(height: 16),

          // Settings toggles with enhanced UI
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings, color: Colors.teal[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Settings',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),

                  // Enhanced settings container
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Row(
                            children: [
                              Icon(Icons.looks_one_outlined,
                                  size: 20, color: Colors.teal[700]),
                              const SizedBox(width: 8),
                              const Text('Use Khmer Digits'),
                            ],
                          ),
                          subtitle: const Text(
                              'Display numbers in Khmer format (០-៩)'),
                          value: _useKhmerDigits,
                          activeColor: Colors.teal,
                          onChanged: (value) {
                            setState(() {
                              _useKhmerDigits = value;
                            });
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        SwitchListTile(
                          title: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 20, color: Colors.teal[700]),
                              const SizedBox(width: 8),
                              const Text('Use Buddhist Year'),
                            ],
                          ),
                          subtitle: const Text(
                              'Display years in Buddhist calendar format (BE)'),
                          value: _useBuddhistYear,
                          activeColor: Colors.teal,
                          onChanged: (value) {
                            setState(() {
                              _useBuddhistYear = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Current time indicator
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.teal[50],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.teal[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Time Reference',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'All examples using: ${DateFormat('EEE, MMM d, y HH:mm:ss').format(_now)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.teal[800],
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

          // Display examples with enhanced UI
          _buildFormattingExample(
            'Full Date & Time',
            formattedDateTime,
            'KhmerDateFormatter.formatDateTime(_now, useKhmerDigits: $_useKhmerDigits)',
            Icons.date_range,
            Colors.indigo,
          ),

          _buildFormattingExample(
            'Date Only',
            formattedDate,
            'KhmerDateFormatter.formatDate(_now, useKhmerDigits: $_useKhmerDigits)',
            Icons.calendar_today,
            Colors.teal,
          ),

          _buildFormattingExample(
            'Date with Weekday',
            formattedDateWithWeekday,
            'KhmerDateFormatter.formatDateWithWeekday(_now, useKhmerDigits: $_useKhmerDigits)',
            Icons.view_week,
            Colors.deepPurple,
          ),

          _buildFormattingExample(
            'Time Only',
            formattedTime,
            'KhmerDateFormatter.formatTime(TimeOfDay.fromDateTime(_now), useKhmerDigits: $_useKhmerDigits)',
            Icons.access_time,
            Colors.blue,
          ),

          _buildFormattingExample(
            'Buddhist Year',
            '$gregorianYear CE → $displayedBuddhistYear BE',
            'KhDateUtils.toBuddhistYear($gregorianYear)',
            Icons.swap_horiz,
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildFormattingExample(
    String title,
    String formattedText,
    String codeExample,
    IconData icon,
    MaterialColor color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with icon
            Row(
              children: [
                Icon(icon, color: color[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const Divider(thickness: 1),

            // Formatted text with enhanced styling
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Formatted Result:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: color[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formattedText,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Code example with syntax highlighting style
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF282C34),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Code header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '// Dart code',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.content_copy,
                                size: 16, color: Colors.white70),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Copy to clipboard',
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: codeExample));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Code copied to clipboard'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Code content
                  Wrap(
                    children: [
                      Text(
                        codeExample,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          color: Colors.lightGreenAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.teal[700],
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.teal[800],
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
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

    // Initialize conversions
    _convertToKhmer();
    _convertToArabic();
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
          _buildSectionTitle(
            'Arabic ↔ Khmer Conversion',
            Icons.swap_horiz,
          ),

          const SizedBox(height: 16),

          // Arabic to Khmer with enhanced UI
          _buildConversionCard(
            title: 'Arabic to Khmer',
            icon: Icons.keyboard_arrow_right,
            description:
                'Convert Arabic numerals (0-9) to Khmer numerals (០-៩)',
            inputController: _arabicController,
            inputLabel: 'Enter Arabic numerals',
            inputHint: 'Example: 2024',
            inputType: TextInputType.number,
            convertAction: _convertToKhmer,
            result: _convertedToKhmer,
            codeSnippet: 'KhmerNumerals.convert("${_arabicController.text}")',
            direction: 'to-khmer',
          ),

          const SizedBox(height: 24),

          // Khmer to Arabic with enhanced UI
          _buildConversionCard(
            title: 'Khmer to Arabic',
            icon: Icons.keyboard_arrow_left,
            description:
                'Convert Khmer numerals (០-៩) to Arabic numerals (0-9)',
            inputController: _khmerController,
            inputLabel: 'Enter Khmer numerals',
            inputHint: 'Example: ២០២៤',
            convertAction: _convertToArabic,
            result: _convertedToArabic,
            codeSnippet:
                'KhmerNumerals.convertToArabic("${_khmerController.text}")',
            direction: 'to-arabic',
          ),

          const SizedBox(height: 24),

          _buildSectionTitle(
            'Extracting Numbers from Text',
            Icons.text_format,
          ),

          const SizedBox(height: 16),

          // Text parsing with enhanced UI
          _buildExtractorCard(
            title: 'Parse Numbers from Khmer Text',
            description: 'Extract numerical values from Khmer text',
            textController: _khmerTextController,
            extractAction: _updateExtractedValues,
            integerValue: _extractedInteger,
            doubleValue: _extractedDouble,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.teal[700],
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.teal[800],
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildConversionCard({
    required String title,
    required IconData icon,
    required String description,
    required TextEditingController inputController,
    required String inputLabel,
    required String inputHint,
    required VoidCallback convertAction,
    required String result,
    required String codeSnippet,
    required String direction,
    TextInputType inputType = TextInputType.text,
  }) {
    final hasResult = result.isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with icon
            Row(
              children: [
                Icon(icon, color: Colors.teal[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const Divider(thickness: 1),

            // Description
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Input field with styling
            TextField(
              controller: inputController,
              onChanged: (value) {
                // Auto-convert as typing
                if (value.isNotEmpty) {
                  convertAction();
                }
              },
              decoration: InputDecoration(
                labelText: inputLabel,
                labelStyle: TextStyle(color: Colors.teal[700]),
                hintText: inputHint,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.teal[700]!, width: 2),
                ),
                prefixIcon: Icon(
                  direction == 'to-khmer' ? Icons.looks_one : Icons.eleven_mp,
                  color: Colors.teal[600],
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    inputController.clear();
                    convertAction();
                  },
                  tooltip: 'Clear text',
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              keyboardType: inputType,
            ),

            const SizedBox(height: 16),

            // Convert button
            Center(
              child: ElevatedButton.icon(
                onPressed: convertAction,
                icon: Icon(direction == 'to-khmer' ? Icons.east : Icons.west),
                label: const Text('Convert'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            // Result display - removed fixed height constraint
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              constraints: BoxConstraints(
                  maxHeight: hasResult ? double.infinity : 0,
                  minHeight: hasResult ? 0 : 0),
              margin: EdgeInsets.only(top: hasResult ? 16.0 : 0),
              child: hasResult
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: direction == 'to-khmer'
                            ? Colors.teal[50]
                            : Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: direction == 'to-khmer'
                              ? Colors.teal[300]!
                              : Colors.blue[300]!,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (direction == 'to-khmer'
                                    ? Colors.teal
                                    : Colors.blue)
                                .withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: direction == 'to-khmer'
                                      ? Colors.teal[100]
                                      : Colors.blue[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  color: direction == 'to-khmer'
                                      ? Colors.teal[700]
                                      : Colors.blue[700],
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Converted Result:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: direction == 'to-khmer'
                                      ? Colors.teal[800]
                                      : Colors.blue[800],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Result in chip format with fixed width constraints
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: direction == 'to-khmer'
                                      ? Colors.teal[300]!
                                      : Colors.blue[300]!,
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  result,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: direction == 'to-khmer'
                                        ? Colors.teal[800]
                                        : Colors.blue[800],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Code snippet using Wrap for better overflow handling
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.code,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        codeSnippet,
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          color: Colors.grey[800],
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon:
                                      const Icon(Icons.content_copy, size: 14),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: codeSnippet));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Code copied'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  tooltip: 'Copy',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractorCard({
    required String title,
    required String description,
    required TextEditingController textController,
    required VoidCallback extractAction,
    required String integerValue,
    required String doubleValue,
  }) {
    final hasIntegerValue = integerValue != 'No integer found';
    final hasDoubleValue = doubleValue != 'No decimal found';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with icon
            Row(
              children: [
                Icon(Icons.find_in_page, color: Colors.purple[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const Divider(thickness: 1),

            // Description
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.purple[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Colors.purple[800],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Input field with styling
            TextField(
              controller: textController,
              maxLines: 3,
              onChanged: (value) {
                // Auto-extract as typing
                if (value.isNotEmpty) {
                  extractAction();
                }
              },
              decoration: InputDecoration(
                labelText: 'Enter Khmer text with numbers',
                labelStyle: TextStyle(color: Colors.purple[700]),
                hintText: 'Example: តម្លៃៈ ១២៣.៤៥ ដុល្លារ',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.purple[700]!, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    textController.clear();
                    extractAction();
                  },
                  tooltip: 'Clear text',
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),

            const SizedBox(height: 16),

            // Extract button
            Center(
              child: ElevatedButton.icon(
                onPressed: extractAction,
                icon: const Icon(Icons.search),
                label: const Text('Extract Values'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.purple[600],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Extracted values display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.format_list_numbered,
                          color: Colors.purple[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Extracted Values:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.purple[800],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Integer value
                  _buildExtractedValueTile(
                    label: 'Integer',
                    value: integerValue,
                    icon: Icons.looks_one_outlined,
                    isFound: hasIntegerValue,
                  ),

                  const SizedBox(height: 12),

                  // Decimal value
                  _buildExtractedValueTile(
                    label: 'Decimal',
                    value: doubleValue,
                    icon: Icons.attach_money,
                    isFound: hasDoubleValue,
                  ),

                  const SizedBox(height: 16),

                  // Code snippets - simplified and more compact
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF282C34),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Integer extraction code
                        const Text(
                          '// Extract integer',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'KhmerNumerals.parseInteger(text)',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: Colors.greenAccent,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.content_copy,
                                  color: Colors.white70, size: 16),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                Clipboard.setData(const ClipboardData(
                                    text: 'KhmerNumerals.parseInteger(text)'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Code copied'),
                                      duration: Duration(seconds: 1)),
                                );
                              },
                              tooltip: 'Copy',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Decimal extraction code
                        const Text(
                          '// Extract decimal',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'KhmerNumerals.parseDouble(text)',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: Colors.greenAccent,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.content_copy,
                                  color: Colors.white70, size: 16),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                Clipboard.setData(const ClipboardData(
                                    text: 'KhmerNumerals.parseDouble(text)'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Code copied'),
                                      duration: Duration(seconds: 1)),
                                );
                              },
                              tooltip: 'Copy',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedValueTile({
    required String label,
    required String value,
    required IconData icon,
    required bool isFound,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isFound ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFound ? Colors.purple[300]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isFound ? Colors.purple[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isFound ? Colors.purple[700] : Colors.grey[600],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isFound ? FontWeight.bold : FontWeight.normal,
                    color: isFound ? Colors.black87 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
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
  void initState() {
    super.initState();
    // Parse initially to show results
    _parseDate();
    _parseDateTime();
  }

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
          _buildParserCard(
            title: 'Parse Date Only',
            icon: Icons.calendar_today,
            description: 'Convert Khmer date text into a DateTime object',
            controller: _dateController,
            labelText: 'Enter Khmer date',
            hintText: 'Example: ១៥ មករា ២៥៦៧',
            errorText: _dateError,
            onParse: _parseDate,
            buttonText: 'Parse Date',
            result: _parsedDate,
            formattedResult: _formatDate(_parsedDate),
            codeSnippet: 'KhmerDateParser.parse("${_dateController.text}")',
          ),

          const SizedBox(height: 24),

          // Parse date and time
          _buildParserCard(
            title: 'Parse Date and Time',
            icon: Icons.access_time,
            description:
                'Convert Khmer date and time text into a DateTime object',
            controller: _dateTimeController,
            labelText: 'Enter Khmer date and time',
            hintText: 'Example: ១៥ មករា ២៥៦៧, ១០:៣០ ព្រឹក',
            errorText: _dateTimeError,
            onParse: _parseDateTime,
            buttonText: 'Parse Date & Time',
            result: _parsedDateTime,
            formattedResult: _formatDateTime(_parsedDateTime),
            codeSnippet:
                'KhmerDateParser.parseDateTime("${_dateTimeController.text}")',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.text_format,
            color: Colors.teal[700],
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.teal[800],
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildParserCard({
    required String title,
    required IconData icon,
    required String description,
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required String errorText,
    required VoidCallback onParse,
    required String buttonText,
    required DateTime? result,
    required String formattedResult,
    required String codeSnippet,
  }) {
    final bool hasResult = result != null;
    final bool hasError = errorText.isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with icon
            Row(
              children: [
                Icon(icon, color: Colors.teal[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const Divider(thickness: 1),

            // Description
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Input field with styling
            TextField(
              controller: controller,
              onChanged: (value) {
                // Auto-parse on change
                if (value.isNotEmpty) {
                  onParse();
                }
              },
              decoration: InputDecoration(
                labelText: labelText,
                hintText: hintText,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.teal[700]!, width: 2),
                ),
                prefixIcon: Icon(
                  Icons.text_fields,
                  color: Colors.teal[600],
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                  },
                  tooltip: 'Clear text',
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),

            // Error message with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: hasError ? 40 : 0,
              margin: EdgeInsets.only(top: hasError ? 8.0 : 0),
              child: hasError
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red[700], size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorText,
                              style: TextStyle(
                                  color: Colors.red[700], fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),

            const SizedBox(height: 16),

            // Parse button with icon
            Center(
              child: ElevatedButton.icon(
                onPressed: onParse,
                icon: const Icon(Icons.transform),
                label: Text(buttonText),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Result container with visual status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hasResult ? Colors.teal[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasResult ? Colors.teal[300]! : Colors.grey[300]!,
                ),
                boxShadow: hasResult
                    ? [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              hasResult ? Colors.teal[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          hasResult
                              ? Icons.check_circle
                              : Icons.hourglass_empty,
                          color:
                              hasResult ? Colors.teal[700] : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Parsed Result:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              hasResult ? Colors.teal[800] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            hasResult ? Colors.teal[200]! : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      formattedResult,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            hasResult ? FontWeight.bold : FontWeight.normal,
                        color: hasResult ? Colors.black87 : Colors.grey[600],
                      ),
                    ),
                  ),
                  if (hasResult) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.data_object,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Raw: ${result.toString()}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Code snippet with syntax highlighting style
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF282C34),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.code, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      codeSnippet,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.greenAccent,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.content_copy,
                        color: Colors.white70, size: 16),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: codeSnippet));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Code copied to clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    tooltip: 'Copy to clipboard',
                  ),
                ],
              ),
            ),
          ],
        ),
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

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date1,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _date1) {
      setState(() {
        _date1 = picked;
        _calculateDifferences();
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date2,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _date2) {
      setState(() {
        _date2 = picked;
        _calculateDifferences();
      });
    }
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
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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

                  // Operation selection - Improved responsive layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Use a column layout on small screens, row on larger screens
                      return constraints.maxWidth < 500
                          ? Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  value: _operation,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Operation',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
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
                                      _performCalculation(); // Auto-calculate
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Fixed width value field
                                TextFormField(
                                  controller: _valueController,
                                  decoration: const InputDecoration(
                                    labelText: 'Value',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                  ),
                                  keyboardType: TextInputType.number,
                                  // Add input formatter to limit length
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(5),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) {
                                    // Auto-calculate when value changes
                                    if (value.isNotEmpty) {
                                      _performCalculation();
                                    }
                                  },
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: DropdownButtonFormField<String>(
                                    value: _operation,
                                    decoration: const InputDecoration(
                                      labelText: 'Operation',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 16),
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
                                        _performCalculation(); // Auto-calculate
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _valueController,
                                    decoration: const InputDecoration(
                                      labelText: 'Value',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 16),
                                    ),
                                    keyboardType: TextInputType.number,
                                    // Add input formatter to limit length
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (value) {
                                      // Auto-calculate when value changes
                                      if (value.isNotEmpty) {
                                        _performCalculation();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Calculate button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _performCalculation,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calculate'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Result
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.teal),
                            SizedBox(width: 8),
                            Text(
                              'Result:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Code: KhDateCalculator.$_operation(date, ${_valueController.text})',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
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
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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

                  // Date selection with interactive UI
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Stack vertically on small screens
                      return constraints.maxWidth < 500
                          ? Column(
                              children: [
                                // Start date with date picker
                                _buildDateSelector(
                                  context,
                                  'Start Date',
                                  _date1,
                                  () => _selectDate1(context),
                                  Icons.calendar_today,
                                ),
                                const SizedBox(height: 16),
                                // End date with date picker
                                _buildDateSelector(
                                  context,
                                  'End Date',
                                  _date2,
                                  () => _selectDate2(context),
                                  Icons.event,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: _buildDateSelector(
                                    context,
                                    'Start Date',
                                    _date1,
                                    () => _selectDate1(context),
                                    Icons.calendar_today,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildDateSelector(
                                    context,
                                    'End Date',
                                    _date2,
                                    () => _selectDate2(context),
                                    Icons.event,
                                  ),
                                ),
                              ],
                            );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Differences display - improved visual presentation
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.compare_arrows, color: Colors.teal),
                            SizedBox(width: 8),
                            Text(
                              'Difference:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Cards for each difference type
                        Row(
                          children: [
                            Expanded(
                              child: _buildDifferenceCard(
                                'Days',
                                _daysDifference.toString(),
                                Icons.calendar_view_day,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildDifferenceCard(
                                'Months',
                                _monthsDifference.toString(),
                                Icons.calendar_view_month,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildDifferenceCard(
                                'Years',
                                _yearsDifference.toString(),
                                Icons.calendar_today,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Code: KhDateCalculator.daysBetween(date1, date2)',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
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
      child: Row(
        children: [
          Icon(
            title.contains('Arithmetic')
                ? Icons.add_circle
                : Icons.compare_arrows,
            color: Colors.teal[700],
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.teal[800],
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  // Helper method to build interactive date selector
  Widget _buildDateSelector(
    BuildContext context,
    String label,
    DateTime date,
    VoidCallback onTap,
    IconData icon,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Icon(icon, color: Colors.teal),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(date, withTime: false),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to change',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build difference cards
  Widget _buildDifferenceCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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

class _TimezonePageState extends State<TimezonePage>
    with SingleTickerProviderStateMixin {
  final DateTime _utcNow = DateTime.now().toUtc();
  late DateTime _khmerTime;
  late DateTime _convertedBack;
  late AnimationController _refreshAnimController;

  bool _useKhmerDigits = true;

  @override
  void initState() {
    super.initState();

    // Setup animation controller for refresh button first
    _refreshAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Then update times
    _updateTimes();
  }

  @override
  void dispose() {
    _refreshAnimController.dispose();
    super.dispose();
  }

  void _updateTimes() {
    // Start refresh animation
    _refreshAnimController.forward(from: 0.0);

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
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.swap_vert, color: Colors.teal[700]),
                      const SizedBox(width: 8),
                      Text(
                        'UTC ↔ Cambodia Time Conversion',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),

                  const Divider(thickness: 1.2),

                  // Settings toggle with improved styling
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: SwitchListTile(
                      title: Row(
                        children: [
                          Icon(
                            Icons.translate,
                            size: 20,
                            color: Colors.teal[700],
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Use Khmer Digits',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      value: _useKhmerDigits,
                      onChanged: (value) {
                        setState(() {
                          _useKhmerDigits = value;
                        });
                      },
                      activeColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // Refresh button with animation
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _updateTimes,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0)
                            .animate(_refreshAnimController),
                        child: const Icon(Icons.refresh),
                      ),
                      label: const Text('Refresh Times',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Conversion flow - UTC time
                  _buildTimeCard(
                    title: 'UTC Time',
                    icon: Icons.public,
                    iconColor: Colors.blue[700]!,
                    time: _utcNow,
                    timeFormatted: DateFormat('EEEE, MMMM d, y - HH:mm:ss')
                        .format(_utcNow),
                    backgroundColor: Colors.blue[50]!,
                    borderColor: Colors.blue[200]!,
                    showCode: false,
                  ),

                  // Arrow with animation
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.teal[700],
                        size: 24,
                      ),
                    ),
                  ),

                  // Cambodia time
                  _buildTimeCard(
                    title: 'Cambodia Time (ICT)',
                    icon: Icons.access_time,
                    iconColor: Colors.teal[700]!,
                    time: _khmerTime,
                    timeFormatted: KhmerDateFormatter.formatDateTime(
                      _khmerTime,
                      useKhmerDigits: _useKhmerDigits,
                    ),
                    backgroundColor: Colors.teal[50]!,
                    borderColor: Colors.teal[300]!,
                    codeSnippet: 'KhTimeZoneUtils.toKhmerLocalTime(utcTime)',
                    isHighlighted: true,
                  ),

                  // Arrow with animation
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.teal[700],
                        size: 24,
                      ),
                    ),
                  ),

                  // Converted back to UTC
                  _buildTimeCard(
                    title: 'Converted Back to UTC',
                    icon: Icons.public,
                    iconColor: Colors.blue[700]!,
                    time: _convertedBack,
                    timeFormatted: DateFormat('EEEE, MMMM d, y - HH:mm:ss')
                        .format(_convertedBack),
                    backgroundColor: Colors.blue[50]!,
                    borderColor: Colors.blue[200]!,
                    codeSnippet:
                        'KhTimeZoneUtils.toUtcFromKhmerTime(khmerTime)',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Current Cambodia time with enhanced UI
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.teal[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Current Cambodia Time',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),

                  const Divider(thickness: 1.2),

                  // Current time display with enhanced UI
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.teal[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.access_time_filled,
                                color: Colors.teal[700],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Now in Khmer Time Zone:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Digital clock style display
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              KhmerDateFormatter.formatDateTime(
                                KhTimeZoneUtils.nowInKhmerTimeZone(),
                                useKhmerDigits: _useKhmerDigits,
                              ),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Timezone info with badge
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.teal[700],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'UTC${KhTimeZoneUtils.cambodiaTimeZone}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${KhTimeZoneUtils.cambodiaTimeZoneName})',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Code snippet with improved styling
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.code, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'KhTimeZoneUtils.nowInKhmerTimeZone()',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    color: Colors.grey[800],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
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

  // Enhanced time card component
  Widget _buildTimeCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required DateTime time,
    required String timeFormatted,
    required Color backgroundColor,
    required Color borderColor,
    String? codeSnippet,
    bool isHighlighted = false,
    bool showCode = true,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: borderColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isHighlighted ? Colors.white : backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: isHighlighted ? Border.all(color: borderColor) : null,
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isHighlighted ? 16 : 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Time display with padding
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color:
                  isHighlighted ? Colors.white : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
              border: isHighlighted ? Border.all(color: borderColor) : null,
            ),
            child: Text(
              timeFormatted,
              style: TextStyle(
                fontSize: isHighlighted ? 18 : 16,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Raw time with monospace font
          Text(
            'Raw: $time',
            style: TextStyle(
              fontFamily: 'monospace',
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),

          // Show code snippet if provided
          if (showCode && codeSnippet != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.code, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Code: $codeSnippet',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.grey[800],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.language,
            color: Colors.teal[700],
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.teal[800],
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
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
          _buildSectionTitle('KDT UI Components', Icons.widgets),
          const SizedBox(height: 16),

          // Settings with improved UI
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings, color: Colors.teal[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Settings',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),

                  // Enhanced switch list tiles
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Row(
                            children: [
                              Icon(Icons.translate,
                                  size: 20, color: Colors.teal[700]),
                              const SizedBox(width: 8),
                              const Text('Use Khmer Digits'),
                            ],
                          ),
                          subtitle:
                              const Text('Display numbers in Khmer format'),
                          value: _useKhmerDigits,
                          activeColor: Colors.teal,
                          onChanged: (value) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                _useKhmerDigits = value;
                              });
                            });
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        SwitchListTile(
                          title: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 20, color: Colors.teal[700]),
                              const SizedBox(width: 8),
                              const Text('Use Buddhist Year'),
                            ],
                          ),
                          subtitle: const Text(
                              'Display years in Buddhist calendar format'),
                          value: _useBuddhistYear,
                          activeColor: Colors.teal,
                          onChanged: (value) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                _useBuddhistYear = value;
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Date picker with enhanced UI
          _buildWidgetCard(
            title: 'Khmer Date Picker',
            icon: Icons.date_range,
            child: Column(
              children: [
                // Info banner
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap to select a date in Khmer format',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Date picker widget with styling
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: KhDatePicker(
                      initialDate: _selectedDate,
                      onDateSelected: (date) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _selectedDate = date;
                          });
                        });
                      },
                      useKhmerDigits: _useKhmerDigits,
                      useBuddhistYear: _useBuddhistYear,
                      backgroundColor: Colors.teal.shade100,
                      textColor: Colors.teal.shade900,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Result display with enhanced styling
                _buildResultDisplay(
                  label: 'Selected Date',
                  value: DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                  icon: Icons.event,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Time picker with enhanced UI
          _buildWidgetCard(
            title: 'Khmer Time Picker',
            icon: Icons.access_time,
            child: Column(
              children: [
                // Info banner
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap to select time in hours, minutes, and seconds',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Time picker widget
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: KhTimePicker(
                      initialTime: _selectedTime,
                      onTimeSelected: (time) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _selectedTime = time;
                          });
                        });
                      },
                      useKhmerDigits: _useKhmerDigits,
                      showSeconds: true,
                      backgroundColor: Colors.teal.shade100,
                      textColor: Colors.teal.shade900,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Result display with enhanced styling
                _buildResultDisplay(
                  label: 'Selected Time',
                  value:
                      '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                  icon: Icons.schedule,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Date range picker with enhanced UI
          _buildWidgetCard(
            title: 'Khmer Date Range Picker',
            icon: Icons.date_range,
            child: Column(
              children: [
                // Info banner
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Select a date range (maximum 30 days)',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Date range picker widget
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: KhDateRangePicker(
                    initialStartDate: _selectedRange.start,
                    initialEndDate: _selectedRange.end,
                    onDateRangeSelected: (dateRange) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _selectedRange = dateRange;
                        });
                      });
                    },
                    useKhmerDigits: _useKhmerDigits,
                    useBuddhistYear: _useBuddhistYear,
                    backgroundColor: Colors.teal.shade100,
                    textColor: Colors.teal.shade900,
                    maxDateSpan: 30,
                  ),
                ),

                const SizedBox(height: 16),

                // Result display with enhanced styling
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.date_range, color: Colors.teal[700]),
                          const SizedBox(width: 8),
                          const Text(
                            'Selected Range:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // From date
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.teal[200]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.teal[50],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(Icons.arrow_forward,
                                  size: 16, color: Colors.teal[700]),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('From',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                                Text(
                                  DateFormat('MMM d, y')
                                      .format(_selectedRange.start),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // To date
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.teal[200]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.teal[50],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(Icons.arrow_back,
                                  size: 16, color: Colors.teal[700]),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('To',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                                Text(
                                  DateFormat('MMM d, y')
                                      .format(_selectedRange.end),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Duration badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.teal[700],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_month,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Duration: ${_selectedRange.duration.inDays} days',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Calendar with enhanced UI
          _buildWidgetCard(
            title: 'Khmer Calendar',
            icon: Icons.calendar_month,
            child: Column(
              children: [
                // Info banner
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap on any date to select it',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Calendar widget with padding
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: KhCalendar(
                    initialDate: DateTime.now(),
                    onDateSelected: (date) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _calendarSelectedDate = date;
                        });
                      });
                    },
                    useKhmerDigits: _useKhmerDigits,
                    primaryColor: Colors.teal,
                    showBuddhistYear: _useBuddhistYear,
                    highlightToday: true,
                  ),
                ),

                const SizedBox(height: 16),

                // Result display with enhanced styling
                if (_calendarSelectedDate != null)
                  _buildResultDisplay(
                    label: 'Selected Calendar Date',
                    value: DateFormat('EEEE, MMMM d, y')
                        .format(_calendarSelectedDate!),
                    icon: Icons.event_note,
                    highlight: true,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Enhanced section title with icon
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.teal[700],
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.teal[800],
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  // Reusable widget card
  Widget _buildWidgetCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.teal[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  // Enhanced result display
  Widget _buildResultDisplay({
    required String label,
    required String value,
    required IconData icon,
    bool highlight = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? Colors.teal[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? Colors.teal[300]! : Colors.grey[300]!,
        ),
        boxShadow: highlight
            ? [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: highlight ? Colors.teal[700] : Colors.grey[700],
              ),
              const SizedBox(width: 8),
              Text(
                '$label:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: highlight ? Colors.teal[800] : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: highlight ? Colors.teal[200]! : Colors.grey[300]!,
              ),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
