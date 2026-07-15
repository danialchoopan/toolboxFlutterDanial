import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/persian_numbers.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<String> _laps = [];

  String _formatTime() {
    final elapsed = _stopwatch.elapsed;
    final minutes = elapsed.inMinutes;
    final seconds = elapsed.inSeconds % 60;
    final milliseconds = (elapsed.inMilliseconds % 1000) ~/ 10;
    return '${PersianNumbers.toPersian(minutes.toString().padLeft(2, '0'))}:${PersianNumbers.toPersian(seconds.toString().padLeft(2, '0'))}.${PersianNumbers.toPersian(milliseconds.toString().padLeft(2, '0'))}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('کرنومتر'),
      ),
      body: Column(
        children: [
          // Timer Display
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      color: _stopwatch.isRunning ? AppColors.turquoise : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _stopwatch.isRunning ? 'در حال اجرا' : (_stopwatch.isRunning || _laps.isNotEmpty ? 'متوقف شده' : 'آماده'),
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Controls
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Reset
                _buildControlButton(
                  icon: Icons.refresh,
                  label: 'بازنشانی',
                  color: Colors.grey,
                  onPressed: _reset,
                ),
                const SizedBox(width: 24),
                // Start/Stop
                _buildControlButton(
                  icon: _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                  label: _stopwatch.isRunning ? 'توقف' : 'شروع',
                  color: _stopwatch.isRunning ? Colors.orange : AppColors.turquoise,
                  isLarge: true,
                  onPressed: _toggleStopwatch,
                ),
                const SizedBox(width: 24),
                // Lap
                _buildControlButton(
                  icon: Icons.flag,
                  label: 'دور',
                  color: Colors.blue,
                  onPressed: _stopwatch.isRunning ? _addLap : null,
                ),
              ],
            ),
          ),

          // Laps
          Expanded(
            flex: 3,
            child: _laps.isEmpty
                ? Center(
                    child: Text(
                      'هنوز دوری ثبت نشده',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                    itemCount: _laps.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: ListTile(
                          leading: Text(
                            'دور ${PersianNumbers.toPersianNumber(_laps.length - index)}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Text(
                            _laps[index],
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    bool isLarge = false,
    VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isLarge ? 72 : 56,
          height: isLarge ? 72 : 56,
          decoration: BoxDecoration(
            color: onPressed != null ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, size: isLarge ? 32 : 24),
            color: onPressed != null ? color : Colors.grey,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: onPressed != null ? color : Colors.grey,
          ),
        ),
      ],
    );
  }

  void _toggleStopwatch() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
        _timer?.cancel();
      } else {
        _stopwatch.start();
        _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
          setState(() {});
        });
      }
    });
  }

  void _reset() {
    setState(() {
      _stopwatch.stop();
      _stopwatch.reset();
      _timer?.cancel();
      _laps.clear();
    });
  }

  void _addLap() {
    setState(() {
      _laps.insert(0, _formatTime());
    });
  }
}
