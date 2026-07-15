import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

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
  void dispose() { _heightController.dispose(); _weightController.dispose(); super.dispose(); }

  void _calculate() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    if (height == null || weight == null || height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لطفاً مقادیر معتبر وارد کنید')));
      return;
    }
    final bmi = weight / ((height / 100) * (height / 100));
    setState(() {
      _bmi = bmi;
      if (bmi < 18.5) _category = 'کم وزن';
      else if (bmi < 25) _category = 'نرمال';
      else if (bmi < 30) _category = 'اضافه وزن';
      else _category = 'چاق';
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
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('ماشین حساب BMI')),
      body: isDesktop
          ? Row(
              children: [
                Expanded(flex: 2, child: _buildInputSection(context)),
                Container(width: 1, color: Colors.grey[300]),
                Expanded(flex: 3, child: _buildResultSection(context)),
              ],
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [_buildInputSection(context), const SizedBox(height: 24), _buildResultSection(context)]),
            ),
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 32 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('محاسبه شاخص توده بدنی', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            decoration: const InputDecoration(labelText: 'قد (سانتی‌متر)', hintText: '۱۷۵'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            decoration: const InputDecoration(labelText: 'وزن (کیلوگرم)', hintText: '۷۰'),
          ),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _calculate, child: const Text('محاسبه'))),
        ],
      ),
    );
  }

  Widget _buildResultSection(BuildContext context) {
    if (_bmi == null) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.monitor_weight_outlined, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text('قد و وزن خود را وارد کنید', style: TextStyle(color: Colors.grey[500])),
      ]));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _getCategoryColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getCategoryColor().withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(PersianNumbers.toPersian(_bmi!.toStringAsFixed(1)), style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: _getCategoryColor())),
                const SizedBox(height: 8),
                Text(_category, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: _getCategoryColor())),
                const SizedBox(height: 24),
                Container(height: 12, decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), gradient: const LinearGradient(colors: [Colors.blue, Colors.green, Colors.orange, Colors.red]))),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('کم وزن', style: TextStyle(fontSize: 11, color: Colors.blue)),
                  Text('نرمال', style: TextStyle(fontSize: 11, color: Colors.green)),
                  Text('اضافه وزن', style: TextStyle(fontSize: 11, color: Colors.orange)),
                  Text('چاق', style: TextStyle(fontSize: 11, color: Colors.red)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
