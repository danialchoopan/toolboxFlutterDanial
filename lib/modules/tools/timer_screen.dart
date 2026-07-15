import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/persian_numbers.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _totalSeconds = 300; // 5 minutes default
  int _remainingSeconds = 300;
  bool _isRunning = false;
  Timer? _timer;

  String _formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${PersianNumbers.toPersian(hours.toString().padLeft(2, '0'))}:${PersianNumbers.toPersian(minutes.toString().padLeft(2, '0'))}:${PersianNumbers.toPersian(seconds.toString().padLeft(2, '0'))}';
    }
    return '${PersianNumbers.toPersian(minutes.toString().padLeft(2, '0'))}:${PersianNumbers.toPersian(seconds.toString().padLeft(2, '0'))}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تایمر'),
      ),
      body: Column(
        children: [
          // Timer Display
          Expanded(
            flex: 4,
            child: Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Progress Circle
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _remainingSeconds <= 10 ? Colors.red : AppColors.turquoise,
                        ),
                      ),
                    ),
                    // Time Display
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(_remainingSeconds),
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            color: _remainingSeconds <= 10 ? Colors.red : null,
                          ),
                        ),
                        Text(
                          _isRunning ? 'در حال اجرا' : (_remainingSeconds == _totalSeconds ? 'آماده' : 'متوقف شده'),
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Time Picker
          if (!_isRunning && _remainingSeconds == _totalSeconds)
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const Text('تنظیم زمان'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimePicker('ساعت', _totalSeconds ~/ 3600, (v) {
                        setState(() {
                          _totalSeconds = v * 3600 + (_totalSeconds % 3600);
                          _remainingSeconds = _totalSeconds;
                        });
                      }),
                      const Text(':', style: TextStyle(fontSize: 24)),
                      _buildTimePicker('دقیقه', (_totalSeconds % 3600) ~/ 60, (v) {
                        setState(() {
                          _totalSeconds = (_totalSeconds ~/ 3600) * 3600 + v * 60 + (_totalSeconds % 60);
                          _remainingSeconds = _totalSeconds;
                        });
                      }),
                      const Text(':', style: TextStyle(fontSize: 24)),
                      _buildTimePicker('ثانیه', _totalSeconds % 60, (v) {
                        setState(() {
                          _totalSeconds = (_totalSeconds ~/ 60) * 60 + v;
                          _remainingSeconds = _totalSeconds;
                        });
                      }),
                    ],
                  ),
                ],
              ),
            ),

          // Quick Presets
          if (!_isRunning && _remainingSeconds == _totalSeconds)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _buildPresetChip('۱ دقیقه', 60),
                  _buildPresetChip('۳ دقیقه', 180),
                  _buildPresetChip('۵ دقیقه', 300),
                  _buildPresetChip('۱۰ دقیقه', 600),
                  _buildPresetChip('۱۵ دقیقه', 900),
                  _buildPresetChip('۳۰ دقیقه', 1800),
                ],
              ),
            ),
          const SizedBox(height: AppDimensions.lg),

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
                  icon: _isRunning ? Icons.pause : Icons.play_arrow,
                  label: _isRunning ? 'توقف' : 'شروع',
                  color: _isRunning ? Colors.orange : AppColors.turquoise,
                  isLarge: true,
                  onPressed: _totalSeconds > 0 ? _toggleTimer : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
        ],
      ),
    );
  }

  Widget _buildTimePicker(String label, int value, Function(int) onChanged) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          onPressed: () => onChanged((value + 1).clamp(0, 23)),
        ),
        SizedBox(
          width: 50,
          child: Text(
            PersianNumbers.toPersian(value.toString().padLeft(2, '0')),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => onChanged((value - 1).clamp(0, 23)),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPresetChip(String label, int seconds) {
    return ActionChip(
      label: Text(label),
      onPressed: () => setState(() {
        _totalSeconds = seconds;
        _remainingSeconds = seconds;
      }),
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
        Text(label, style: TextStyle(fontSize: 12, color: onPressed != null ? color : Colors.grey)),
      ],
    );
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _timer?.cancel();
        _isRunning = false;
      } else {
        _isRunning = true;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (_remainingSeconds > 0) {
              _remainingSeconds--;
            } else {
              _timer?.cancel();
              _isRunning = false;
              _showCompleteDialog();
            }
          });
        });
      }
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _showCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('زمان تمام شد!'),
        content: const Text('تایمر به پایان رسید.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reset();
            },
            child: const Text('تأیید'),
          ),
        ],
      ),
    );
  }
}
