import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  String _selectedCategory = 'طول';
  String _fromUnit = 'متر';
  String _toUnit = 'سانتی‌متر';
  final _inputController = TextEditingController();
  String _result = '';
  String _formula = '';

  final Map<String, Map<String, double>> _units = {
    'طول': {
      'کیلومتر': 0.001,
      'متر': 1,
      'سانتی‌متر': 100,
      'میلی‌متر': 1000,
      'مایل': 0.000621371,
      'یارد': 1.09361,
      'فوت': 3.28084,
      'اینچ': 39.3701,
    },
    'وزن': {
      'טון': 0.001,
      'کیلوگرم': 1,
      'گرم': 1000,
      'میلی‌گرم': 1000000,
      'پوند': 2.20462,
      'اونس': 35.274,
      'سنگ': 0.157473,
    },
    'دما': {
      'سلسیوس': 0,
      'فارنهایت': 0,
      'کلوین': 0,
      'گرادیان': 0,
    },
    'حجم': {
      'متر مکعب': 0.001,
      'لیتر': 1,
      'میلی‌لیتر': 1000,
      'گالون آمریکایی': 0.264172,
      'گالون انگلیسی': 0.219969,
      'اونس مایع': 33.814,
      'پیمانه (cup)': 4.22675,
      'فوت مکعب': 0.0353147,
    },
    'مساحت': {
      'کیلومتر مربع': 0.000001,
      'هکتار': 0.0001,
      'متر مربع': 1,
      'سانتی‌متر مربع': 10000,
      'اینچ مربع': 1550,
      'فوت مربع': 10.7639,
      'یارد مربع': 1.19599,
      'جریب': 0.000247105,
      'جولدونگ': 0.000247105,
      'acre': 0.000247105,
    },
    'سرعت': {
      'کیلومتر بر ساعت': 1,
      'متر بر ثانیه': 0.277778,
      'مایل بر ساعت': 0.621371,
      'گره': 0.539957,
      'فوت بر ثانیه': 0.911344,
      'ماخ': 0.000809847,
    },
    'داده': {
      'بایت': 1,
      'کیلوبایت': 0.000976563,
      'مگابایت': 0.000000953674,
      'گیگابایت': 0.000000000931323,
      'ترابایت': 0.000000000000909495,
      'پتابایت': 0.000000000000000888,
      'بیت': 8,
      'کیلوبیت': 0.0078125,
      'مگابیت': 0.00000762939,
      'گیگابیت': 0.00000000745058,
    },
    'زمان': {
      'سال': 0.0000000316881,
      'ماه': 0.000000380257,
      'هفته': 0.00000165344,
      'روز': 0.0000115741,
      'ساعت': 0.000277778,
      'دقیقه': 0.0166667,
      'ثانیه': 1,
      'میلی‌ثانیه': 1000,
    },
    'انرژی': {
      'ژول': 1,
      'کیلوژول': 0.001,
      'کالری': 0.239006,
      'کیلوکالری': 0.000239006,
      'وات‌ساعت': 0.000277778,
      'کیلووات‌ساعت': 0.000000277778,
      'الکترون‌ولت': 6.242e+18,
    },
    'توان': {
      'وات': 1,
      'کیلووات': 0.001,
      'مگاوات': 0.000001,
      'اسب بخار': 0.00134102,
      'BTU/min': 0.056869,
    },
    'فشار': {
      'پاسکال': 1,
      'کیلوپاسکال': 0.001,
      'بار': 0.00001,
      'اتمسفر': 0.00000986923,
      'psi': 0.000145038,
      'mmHg': 0.00750062,
    },
    'زاویه': {
      'درجه': 1,
      'رادیان': 0.0174533,
      'گرادیان': 1.11111,
      'دور': 0.00277778,
    },
  };

  List<String> get _categories => _units.keys.toList();
  List<String> get _fromUnits => _units[_selectedCategory]?.keys.toList() ?? [];
  List<String> get _toUnits => _units[_selectedCategory]?.keys.toList() ?? [];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تبدیل واحد'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Selection
            Text('دسته‌بندی', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => setState(() {
                        _selectedCategory = cat;
                        _fromUnit = _fromUnits.first;
                        _toUnit = _toUnits.length > 1 ? _toUnits[1] : _toUnits.first;
                        _result = '';
                      }),
                      selectedColor: AppColors.turquoise,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Input
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              onChanged: (_) => _convert(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '۰',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
            ),
            const SizedBox(height: 16),

            // From/To selectors
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fromUnit,
                    decoration: const InputDecoration(labelText: 'از'),
                    items: _fromUnits.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (v) => setState(() { _fromUnit = v!; _convert(); }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.turquoise.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.swap_horiz, color: AppColors.turquoise),
                    ),
                    onPressed: () => setState(() {
                      final temp = _fromUnit;
                      _fromUnit = _toUnit;
                      _toUnit = temp;
                      _convert();
                    }),
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _toUnit,
                    decoration: const InputDecoration(labelText: 'به'),
                    items: _toUnits.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (v) => setState(() { _toUnit = v!; _convert(); }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Result
            if (_result.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.turquoise, AppColors.persianBlue]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('نتیجه', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      PersianNumbers.toPersian(_result),
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                      textDirection: TextDirection.ltr,
                    ),
                    const SizedBox(height: 4),
                    Text(_toUnit, style: const TextStyle(color: Colors.white70)),
                    if (_formula.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(_formula, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _convert() {
    final input = double.tryParse(_inputController.text);
    if (input == null) { setState(() { _result = ''; _formula = ''; }); return; }

    if (_selectedCategory == 'دما') { _convertTemperature(input); return; }
    if (_selectedCategory == 'زاویه') { _convertAngle(input); return; }

    final fromFactor = _units[_selectedCategory]![_fromUnit]!;
    final toFactor = _units[_selectedCategory]![_toUnit]!;
    final baseValue = input / fromFactor;
    final result = baseValue * toFactor;

    setState(() {
      _result = _formatResult(result);
      _formula = '1 $_fromUnit = ${_formatResult(toFactor / fromFactor)} $_toUnit';
    });
  }

  void _convertTemperature(double input) {
    double celsius;
    switch (_fromUnit) {
      case 'سلسیوس': celsius = input; break;
      case 'فارنهایت': celsius = (input - 32) * 5 / 9; break;
      case 'کلوین': celsius = input - 273.15; break;
      case 'گرادیان': celsius = input * 0.9; break;
      default: celsius = input;
    }
    double result;
    switch (_toUnit) {
      case 'سلسیوس': result = celsius; break;
      case 'فارنهایت': result = celsius * 9 / 5 + 32; break;
      case 'کلوین': result = celsius + 273.15; break;
      case 'گرادیان': result = celsius / 0.9; break;
      default: result = celsius;
    }
    setState(() {
      _result = result.toStringAsFixed(2);
      _formula = '$_inputController.text $_fromUnit = ${result.toStringAsFixed(2)} $_toUnit';
    });
  }

  void _convertAngle(double input) {
    double radians;
    switch (_fromUnit) {
      case 'درجه': radians = input * 3.14159265 / 180; break;
      case 'رادیان': radians = input; break;
      case 'گرادیان': radians = input * 3.14159265 / 200; break;
      case 'دور': radians = input * 2 * 3.14159265; break;
      default: radians = input;
    }
    double result;
    switch (_toUnit) {
      case 'درجه': result = radians * 180 / 3.14159265; break;
      case 'رادیان': result = radians; break;
      case 'گرادیان': result = radians * 200 / 3.14159265; break;
      case 'دور': result = radians / (2 * 3.14159265); break;
      default: result = radians;
    }
    setState(() {
      _result = _formatResult(result);
      _formula = '$_inputController.text $_fromUnit = ${_formatResult(result)} $_toUnit';
    });
  }

  String _formatResult(double value) {
    if (value == value.roundToDouble() && value.abs() < 1e10) {
      return value.toStringAsFixed(0);
    }
    if (value.abs() >= 0.001 && value.abs() < 1e10) {
      return value.toStringAsFixed(4);
    }
    return value.toStringAsExponential(3);
  }
}
