import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('محاسبه سن'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Birth Date Picker
            Card(
              child: ListTile(
                leading: const Icon(Icons.cake, color: AppColors.rose),
                title: Text(
                  _birthDate == null
                      ? 'تاریخ تولد را انتخاب کنید'
                      : '${PersianNumbers.toPersian(_birthDate!.day.toString().padLeft(2, '0'))}/${PersianNumbers.toPersian(_birthDate!.month.toString().padLeft(2, '0'))}/${PersianNumbers.toPersian(_birthDate!.year.toString())}',
                ),
                trailing: const Icon(Icons.chevron_left),
                onTap: _pickDate,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            ElevatedButton(
              onPressed: _birthDate != null ? _calculateAge : null,
              child: const Text('محاسبه سن'),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Result
            if (_result.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.xl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.rose, AppColors.persianBlue],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cake, size: 48, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  void _calculateAge() {
    if (_birthDate == null) return;

    final now = DateTime.now();
    final today = PersianDate.today();
    final birth = PersianDate.gregorianToJalali(
      _birthDate!.year,
      _birthDate!.month,
      _birthDate!.day,
    );

    var years = today[0] - birth[0];
    var months = today[1] - birth[1];
    var days = today[2] - birth[2];

    if (days < 0) {
      months--;
      days += 30;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    setState(() {
      _result = '${PersianNumbers.toPersianNumber(years)} سال و ${PersianNumbers.toPersianNumber(months)} ماه و ${PersianNumbers.toPersianNumber(days)} روز';
    });
  }
}
