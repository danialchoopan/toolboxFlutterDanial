import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double? _bmi;
  String _category = '';

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculate() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً مقادیر معتبر وارد کنید')),
      );
      return;
    }

    final heightM = height / 100;
    final bmi = weight / (heightM * heightM);

    setState(() {
      _bmi = bmi;
      if (bmi < 18.5) {
        _category = 'کم وزن';
      } else if (bmi < 25) {
        _category = 'نرمال';
      } else if (bmi < 30) {
        _category = 'اضافه وزن';
      } else {
        _category = 'چاق';
      }
    });
  }

  Color _getCategoryColor() {
    if (_bmi == null) return Colors.grey;
    if (_bmi! < 18.5) return Colors.blue;
    if (_bmi! < 25) return Colors.green;
    if (_bmi! < 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ماشین حساب BMI'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Fields
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(
                labelText: 'قد (سانتی‌متر)',
                hintText: 'مثال: ۱۷۵',
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(
                labelText: 'وزن (کیلوگرم)',
                hintText: 'مثال: ۷۰',
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('محاسبه'),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Result
            if (_bmi != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.xl),
                decoration: BoxDecoration(
                  color: _getCategoryColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
                  border: Border.all(color: _getCategoryColor().withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      PersianNumbers.toPersian(_bmi!.toStringAsFixed(1)),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _getCategoryColor(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _category,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: _getCategoryColor(),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    // BMI Scale
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.green, Colors.orange, Colors.red],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('کم وزن', style: TextStyle(fontSize: 10, color: Colors.blue)),
                        Text('نرمال', style: TextStyle(fontSize: 10, color: Colors.green)),
                        Text('اضافه وزن', style: TextStyle(fontSize: 10, color: Colors.orange)),
                        Text('چاق', style: TextStyle(fontSize: 10, color: Colors.red)),
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
}
