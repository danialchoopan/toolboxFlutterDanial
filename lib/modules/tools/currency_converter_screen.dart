import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/persian_numbers.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final _inputController = TextEditingController();
  String _fromCurrency = 'دلار';
  String _toCurrency = 'تومان';
  String _result = '';

  // Mock exchange rates (to Toman)
  final Map<String, double> _rates = {
    'دلار': 58000,
    'یورو': 63000,
    'پوند': 74000,
    'درهم': 15800,
    'لیر': 1800,
    'یوان': 8000,
    'تومان': 1,
  };

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
        title: const Text('تبدیل ارز'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notice
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'نرخ‌های تقریبی هستند',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            // From
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              onChanged: (_) => _convert(),
              decoration: InputDecoration(
                labelText: 'مقدار',
                hintText: 'مبلغ را وارد کنید',
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            DropdownButtonFormField<String>(
              value: _fromCurrency,
              decoration: const InputDecoration(labelText: 'از ارز'),
              items: _rates.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() {
                _fromCurrency = v!;
                _convert();
              }),
            ),
            const SizedBox(height: AppDimensions.lg),

            // Swap
            Center(
              child: IconButton(
                icon: const Icon(Icons.swap_vert, size: 32),
                color: AppColors.turquoise,
                onPressed: () {
                  setState(() {
                    final temp = _fromCurrency;
                    _fromCurrency = _toCurrency;
                    _toCurrency = temp;
                    _convert();
                  });
                },
              ),
            ),
            const SizedBox(height: AppDimensions.lg),

            // To
            DropdownButtonFormField<String>(
              value: _toCurrency,
              decoration: const InputDecoration(labelText: 'به ارز'),
              items: _rates.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() {
                _toCurrency = v!;
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
                  gradient: LinearGradient(
                    colors: [AppColors.turquoise, AppColors.persianBlue],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
                ),
                child: Column(
                  children: [
                    const Text(
                      'نتیجه',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${PersianNumbers.toPersian(_result)} $_toCurrency',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

    final fromRate = _rates[_fromCurrency]!;
    final toRate = _rates[_toCurrency]!;

    final tomanAmount = input * fromRate;
    final result = tomanAmount / toRate;

    setState(() {
      _result = result.toStringAsFixed(2);
    });
  }
}
