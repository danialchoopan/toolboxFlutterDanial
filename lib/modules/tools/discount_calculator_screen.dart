import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/persian_numbers.dart';

class DiscountCalculatorScreen extends StatefulWidget {
  const DiscountCalculatorScreen({super.key});

  @override
  State<DiscountCalculatorScreen> createState() => _DiscountCalculatorScreenState();
}

class _DiscountCalculatorScreenState extends State<DiscountCalculatorScreen> {
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  double? _finalPrice;
  double? _savedAmount;

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _calculate() {
    final price = double.tryParse(_priceController.text);
    final discount = double.tryParse(_discountController.text);

    if (price == null || discount == null) return;

    setState(() {
      _savedAmount = price * discount / 100;
      _finalPrice = price - _savedAmount!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('محاسبه تخفیف'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              onChanged: (_) => _calculate(),
              decoration: const InputDecoration(
                labelText: 'قیمت اصلی (تومان)',
                hintText: 'قیمت را وارد کنید',
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            TextField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              onChanged: (_) => _calculate(),
              decoration: const InputDecoration(
                labelText: 'درصد تخفیف',
                hintText: 'درصد را وارد کنید',
                suffixText: '%',
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Result
            if (_finalPrice != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.xl),
                decoration: BoxDecoration(
                  color: AppColors.turquoise.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
                ),
                child: Column(
                  children: [
                    const Text('قیمت نهایی', style: TextStyle(color: AppColors.lightTextSecondary)),
                    const SizedBox(height: 8),
                    Text(
                      '${PersianNumbers.formatCurrency(_finalPrice!)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.turquoise,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'شما ${PersianNumbers.formatCurrency(_savedAmount!)} صرفه‌جویی کردید',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
