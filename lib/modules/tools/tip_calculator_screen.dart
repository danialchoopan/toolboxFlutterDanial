import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/persian_numbers.dart';

class TipCalculatorScreen extends StatefulWidget {
  const TipCalculatorScreen({super.key});

  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  final _billController = TextEditingController();
  double _tipPercent = 10;
  int _people = 1;
  double _tipAmount = 0;
  double _totalAmount = 0;
  double _perPerson = 0;

  @override
  void dispose() {
    _billController.dispose();
    super.dispose();
  }

  void _calculate() {
    final bill = double.tryParse(_billController.text);
    if (bill == null) return;

    setState(() {
      _tipAmount = bill * _tipPercent / 100;
      _totalAmount = bill + _tipAmount;
      _perPerson = _totalAmount / _people;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('محاسبه انعام'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _billController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              onChanged: (_) => _calculate(),
              decoration: const InputDecoration(
                labelText: 'مبلغ صورت حساب (تومان)',
                hintText: 'مبلغ را وارد کنید',
              ),
            ),
            const SizedBox(height: AppDimensions.lg),

            // Tip Percentage
            Text('درصد انعام: ${PersianNumbers.toPersianNumber(_tipPercent.round())}%'),
            Slider(
              value: _tipPercent,
              min: 0,
              max: 30,
              divisions: 30,
              label: '${_tipPercent.round()}%',
              onChanged: (v) {
                setState(() => _tipPercent = v);
                _calculate();
              },
            ),
            const SizedBox(height: AppDimensions.md),

            // Number of People
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('تعداد نفرات'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _people > 1
                          ? () {
                              setState(() => _people--);
                              _calculate();
                            }
                          : null,
                    ),
                    Text(
                      PersianNumbers.toPersianNumber(_people),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() => _people++);
                        _calculate();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.xl),

            // Results
            if (_totalAmount > 0)
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
                    _buildResultRow('انعام', PersianNumbers.formatCurrency(_tipAmount)),
                    const Divider(color: Colors.white30),
                    _buildResultRow('جمع کل', PersianNumbers.formatCurrency(_totalAmount)),
                    if (_people > 1) ...[
                      const Divider(color: Colors.white30),
                      _buildResultRow('هر نفر', PersianNumbers.formatCurrency(_perPerson)),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
