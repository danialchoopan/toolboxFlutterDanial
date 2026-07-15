import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
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

  final Map<String, Map<String, double>> _units = {
    'طول': {
      'متر': 1,
      'سانتی‌متر': 100,
      'میلی‌متر': 1000,
      'کیلومتر': 0.001,
      'اینچ': 39.3701,
      'فوت': 3.28084,
      'یارد': 1.09361,
    },
    'وزن': {
      'کیلوگرم': 1,
      'گرم': 1000,
      'میلی‌گرم': 1000000,
      'پوند': 2.20462,
      'اونس': 35.274,
    },
    'دما': {
      'سلسیوس': 1,
      'فارنهایت': 1,
      'کلوین': 1,
    },
    'حجم': {
      'لیتر': 1,
      'میلی‌لیتر': 1000,
      'گالون': 0.264172,
      'اونس مایع': 33.814,
    },
    'مساحت': {
      'متر مربع': 1,
      'سانتی‌متر مربع': 10000,
      'هکتار': 0.0001,
      'acre': 0.000247105,
    },
    'سرعت': {
      'متر بر ثانیه': 1,
      'کیلومتر بر ساعت': 3.6,
      'مایل بر ساعت': 2.23694,
      'گره': 1.94384,
    },
    'داده': {
      'بایت': 1,
      'کیلوبایت': 0.000976563,
      'مگابایت': 0.000000953674,
      'گیگابایت': 0.000000000931323,
      'ترابایت': 0.000000000000909495,
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
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Selection
            Text(
              'دسته‌بندی',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => setState(() {
                    _selectedCategory = cat;
                    _fromUnit = _fromUnits.first;
                    _toUnit = _toUnits.length > 1 ? _toUnits[1] : _toUnits.first;
                    _convert();
                  }),
                  selectedColor: AppColors.turquoise,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Input
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              onChanged: (_) => _convert(),
              decoration: InputDecoration(
                labelText: 'مقدار',
                hintText: 'مقدار را وارد کنید',
              ),
            ),
            const SizedBox(height: AppDimensions.lg),

            // From Unit
            DropdownButtonFormField<String>(
              value: _fromUnit,
              decoration: const InputDecoration(labelText: 'از'),
              items: _fromUnits.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (v) => setState(() {
                _fromUnit = v!;
                _convert();
              }),
            ),
            const SizedBox(height: AppDimensions.md),

            // Swap Button
            Center(
              child: IconButton(
                icon: const Icon(Icons.swap_vert, size: 32),
                color: AppColors.turquoise,
                onPressed: () {
                  setState(() {
                    final temp = _fromUnit;
                    _fromUnit = _toUnit;
                    _toUnit = temp;
                    _convert();
                  });
                },
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // To Unit
            DropdownButtonFormField<String>(
              value: _toUnit,
              decoration: const InputDecoration(labelText: 'به'),
              items: _toUnits.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (v) => setState(() {
                _toUnit = v!;
                _convert();
              }),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Result
            if (_result.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.xl),
                decoration: BoxDecoration(
                  color: AppColors.turquoise.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
                ),
                child: Column(
                  children: [
                    Text(
                      'نتیجه',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      PersianNumbers.toPersian(_result),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.turquoise,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
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
    if (input == null) {
      setState(() => _result = '');
      return;
    }

    if (_selectedCategory == 'دما') {
      _convertTemperature(input);
      return;
    }

    final fromFactor = _units[_selectedCategory]![_fromUnit]!;
    final toFactor = _units[_selectedCategory]![_toUnit]!;

    final baseValue = input / fromFactor;
    final result = baseValue * toFactor;

    setState(() {
      _result = result.toStringAsFixed(6);
    });
  }

  void _convertTemperature(double input) {
    double celsius;
    switch (_fromUnit) {
      case 'سلسیوس':
        celsius = input;
        break;
      case 'فارنهایت':
        celsius = (input - 32) * 5 / 9;
        break;
      case 'کلوین':
        celsius = input - 273.15;
        break;
      default:
        celsius = input;
    }

    double result;
    switch (_toUnit) {
      case 'سلسیوس':
        result = celsius;
        break;
      case 'فارنهایت':
        result = celsius * 9 / 5 + 32;
        break;
      case 'کلوین':
        result = celsius + 273.15;
        break;
      default:
        result = celsius;
    }

    setState(() {
      _result = result.toStringAsFixed(2);
    });
  }
}
