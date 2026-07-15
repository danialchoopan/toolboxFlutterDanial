import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
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
  void dispose() { _priceController.dispose(); _discountController.dispose(); super.dispose(); }

  void _calculate() {
    final price = double.tryParse(_priceController.text);
    final discount = double.tryParse(_discountController.text);
    if (price == null || discount == null) return;
    setState(() { _savedAmount = price * discount / 100; _finalPrice = price - _savedAmount!; });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('محاسبه تخفیف')),
      body: isDesktop
          ? Row(
              children: [
                Expanded(flex: 2, child: _buildInput(context)),
                Expanded(flex: 3, child: _buildResult(context)),
              ],
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [_buildInput(context), const SizedBox(height: 24), _buildResult(context)]),
            ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 32 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('محاسبه تخفیف', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            onChanged: (_) => _calculate(),
            decoration: const InputDecoration(labelText: 'قیمت اصلی (تومان)'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _discountController,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            onChanged: (_) => _calculate(),
            decoration: const InputDecoration(labelText: 'درصد تخفیف', suffixText: '%'),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    if (_finalPrice == null) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.discount_outlined, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text('قیمت و درصد تخفیف را وارد کنید', style: TextStyle(color: Colors.grey[500])),
      ]));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.turquoise, AppColors.persianBlue]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text('قیمت نهایی', style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 8),
            Text(PersianNumbers.formatCurrency(_finalPrice!), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              child: Text('شما ${PersianNumbers.formatCurrency(_savedAmount!)} صرفه‌جویی کردید', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
