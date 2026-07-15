import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
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
  void dispose() { _billController.dispose(); super.dispose(); }

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
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('محاسبه انعام')),
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
          const Text('محاسبه انعام', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(controller: _billController, keyboardType: TextInputType.number, textDirection: TextDirection.ltr, onChanged: (_) => _calculate(), decoration: const InputDecoration(labelText: 'مبلغ صورت حساب (تومان)')),
          const SizedBox(height: 16),
          Text('درصد انعام: ${_tipPercent.round()}%'),
          Slider(value: _tipPercent, min: 0, max: 30, divisions: 30, onChanged: (v) { setState(() => _tipPercent = v); _calculate(); }),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('تعداد نفرات'),
            Row(children: [
              IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: _people > 1 ? () { setState(() => _people--); _calculate(); } : null),
              Text('$_people', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () { setState(() => _people++); _calculate(); }),
            ]),
          ]),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    if (_totalAmount == 0) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text('مبلغ صورت حساب را وارد کنید', style: TextStyle(color: Colors.grey[500])),
      ]));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.turquoise, AppColors.persianBlue]), borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          _buildResultRow('انعام', PersianNumbers.formatCurrency(_tipAmount)),
          const Divider(color: Colors.white30),
          _buildResultRow('جمع کل', PersianNumbers.formatCurrency(_totalAmount)),
          if (_people > 1) ...[
            const Divider(color: Colors.white30),
            _buildResultRow('هر نفر', PersianNumbers.formatCurrency(_perPerson)),
          ],
        ]),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      ]),
    );
  }
}
