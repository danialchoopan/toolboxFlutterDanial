import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/persian_numbers.dart';

class WorldClockScreen extends StatefulWidget {
  const WorldClockScreen({super.key});

  @override
  State<WorldClockScreen> createState() => _WorldClockScreenState();
}

class _WorldClockScreenState extends State<WorldClockScreen> {
  Timer? _timer;
  final List<Map<String, dynamic>> _clocks = [
    {'city': 'تهران', 'offset': 3.5, 'flag': '🇮🇷'},
    {'city': 'لندن', 'offset': 1.0, 'flag': '🇬🇧'},
    {'city': 'نیویورک', 'offset': -4.0, 'flag': '🇺🇸'},
    {'city': 'توکیو', 'offset': 9.0, 'flag': '🇯🇵'},
    {'city': 'دبی', 'offset': 4.0, 'flag': '🇦🇪'},
    {'city': 'استانبول', 'offset': 3.0, 'flag': '🇹🇷'},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getTime(double offset) {
    final now = DateTime.now().toUtc();
    final local = now.add(Duration(hours: offset.toInt(), minutes: (offset * 60).toInt() % 60));
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}:${local.second.toString().padLeft(2, '0')}';
  }

  String _getDate(double offset) {
    final now = DateTime.now().toUtc();
    final local = now.add(Duration(hours: offset.toInt(), minutes: (offset * 60).toInt() % 60));
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ساعت جهانی'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.lg),
        itemCount: _clocks.length,
        itemBuilder: (context, index) {
          final clock = _clocks[index];
          return Card(
            margin: const EdgeInsets.only(bottom: AppDimensions.sm),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Row(
                children: [
                  Text(
                    clock['flag'],
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clock['city'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _getDate(clock['offset']),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    PersianNumbers.toPersian(_getTime(clock['offset'])),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      color: AppColors.turquoise,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
