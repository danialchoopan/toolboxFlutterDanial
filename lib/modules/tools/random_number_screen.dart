import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/persian_numbers.dart';

class RandomNumberScreen extends StatefulWidget {
  const RandomNumberScreen({super.key});

  @override
  State<RandomNumberScreen> createState() => _RandomNumberScreenState();
}

class _RandomNumberScreenState extends State<RandomNumberScreen> {
  final _minController = TextEditingController(text: '1');
  final _maxController = TextEditingController(text: '100');
  int? _result;
  final List<int> _history = [];
  bool _allowDuplicates = true;

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _generate() {
    final min = int.tryParse(_minController.text) ?? 1;
    final max = int.tryParse(_maxController.text) ?? 100;

    if (min >= max) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حداقل باید کمتر از حداکثر باشد')),
      );
      return;
    }

    if (!_allowDuplicates && _history.length >= (max - min + 1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('همه اعداد تولید شده‌اند')),
      );
      return;
    }

    int newResult;
    do {
      newResult = min + Random().nextInt(max - min + 1);
    } while (!_allowDuplicates && _history.contains(newResult));

    setState(() {
      _result = newResult;
      _history.insert(0, newResult);
      if (_history.length > 50) _history.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('عدد تصادفی'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => setState(() => _history.clear()),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Range Inputs
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(labelText: 'حداقل'),
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(labelText: 'حداکثر'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),

            // Allow Duplicates
            SwitchListTile(
              title: const Text('تکرار مجاز'),
              value: _allowDuplicates,
              onChanged: (v) => setState(() => _allowDuplicates = v),
              activeColor: AppColors.turquoise,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppDimensions.lg),

            // Generate Button
            ElevatedButton(
              onPressed: _generate,
              child: const Text('تولید عدد'),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Result
            if (_result != null)
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.turquoise, AppColors.persianBlue],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.turquoise.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      PersianNumbers.toPersianNumber(_result!),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: AppDimensions.xl),

            // History
            if (_history.isNotEmpty) ...[
              Text(
                'تاریخچه',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.sm),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _history.map((num) => Chip(
                  label: Text(
                    PersianNumbers.toPersianNumber(num),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
