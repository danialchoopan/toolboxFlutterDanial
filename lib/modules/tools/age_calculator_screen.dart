import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_date.dart';
import '../../core/localization/persian_numbers.dart';

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? _birthDate;
  String _result = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('محاسبه سن')),
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
          const Text('محاسبه سن', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cake, color: AppColors.rose),
              title: Text(
                _birthDate == null ? 'تاریخ تولد را انتخاب کنید' : '${PersianNumbers.toPersian(_birthDate!.day.toString().padLeft(2, '0'))}/${PersianNumbers.toPersian(_birthDate!.month.toString().padLeft(2, '0'))}/${PersianNumbers.toPersian(_birthDate!.year.toString())}',
              ),
              trailing: const Icon(Icons.chevron_left),
              onTap: _pickDate,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _birthDate != null ? _calculateAge : null, child: const Text('محاسبه سن'))),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    if (_result.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.cake_outlined, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text('تاریخ تولد خود را انتخاب کنید', style: TextStyle(color: Colors.grey[500])),
      ]));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.rose, AppColors.persianBlue]), borderRadius: BorderRadius.circular(20)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.cake, size: 48, color: Colors.white),
          const SizedBox(height: 16),
          Text(_result, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _calculateAge() {
    if (_birthDate == null) return;
    final today = PersianDate.today();
    final birth = PersianDate.gregorianToJalali(_birthDate!.year, _birthDate!.month, _birthDate!.day);
    var years = today[0] - birth[0];
    var months = today[1] - birth[1];
    var days = today[2] - birth[2];
    if (days < 0) { months--; days += 30; }
    if (months < 0) { years--; months += 12; }
    setState(() => _result = '${PersianNumbers.toPersianNumber(years)} سال و ${PersianNumbers.toPersianNumber(months)} ماه و ${PersianNumbers.toPersianNumber(days)} روز');
  }
}
