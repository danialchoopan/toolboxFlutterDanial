import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _totalSeconds = 300;
  int _remainingSeconds = 300;
  bool _isRunning = false;
  Timer? _timer;

  String _formatTime(int s) {
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final sec = s % 60;
    return h > 0
        ? '${PersianNumbers.toPersian(h.toString().padLeft(2, '0'))}:${PersianNumbers.toPersian(m.toString().padLeft(2, '0'))}:${PersianNumbers.toPersian(sec.toString().padLeft(2, '0'))}'
        : '${PersianNumbers.toPersian(m.toString().padLeft(2, '0'))}:${PersianNumbers.toPersian(sec.toString().padLeft(2, '0'))}';
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;
    final progress = _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('تایمر')),
      body: isDesktop
          ? Row(
              children: [
                Expanded(flex: 3, child: _buildTimerDisplay(context, progress, isDark)),
                Container(width: 1, color: Colors.grey[300]),
                Expanded(flex: 2, child: _buildControls(context)),
              ],
            )
          : Column(
              children: [
                Expanded(flex: 3, child: _buildTimerDisplay(context, progress, isDark)),
                Expanded(flex: 2, child: _buildControls(context)),
              ],
            ),
    );
  }

  Widget _buildTimerDisplay(BuildContext context, double progress, bool isDark) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width > 600 ? 280 : 220,
        height: MediaQuery.of(context).size.width > 600 ? 280 : 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(value: 1, strokeWidth: 8, backgroundColor: Colors.grey[200]),
            CircularProgressIndicator(
              value: progress, strokeWidth: 8, backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(_remainingSeconds <= 10 ? Colors.red : AppColors.turquoise),
              strokeCap: StrokeCap.round,
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text(_formatTime(_remainingSeconds), style: TextStyle(fontSize: MediaQuery.of(context).size.width > 600 ? 56 : 42, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: _remainingSeconds <= 10 ? Colors.red : null)),
              Text(_isRunning ? 'در حال اجرا' : (_remainingSeconds == _totalSeconds ? 'آماده' : 'متوقف شده'), style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_isRunning && _remainingSeconds == _totalSeconds) ...[
            const Text('تنظیم زمان', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildTimePicker('ساعت', _totalSeconds ~/ 3600, (v) => setState(() { _totalSeconds = v * 3600 + (_totalSeconds % 3600); _remainingSeconds = _totalSeconds; })),
              const Text(':', style: TextStyle(fontSize: 24)),
              _buildTimePicker('دقیقه', (_totalSeconds % 3600) ~/ 60, (v) => setState(() { _totalSeconds = (_totalSeconds ~/ 3600) * 3600 + v * 60 + (_totalSeconds % 60); _remainingSeconds = _totalSeconds; })),
              const Text(':', style: TextStyle(fontSize: 24)),
              _buildTimePicker('ثانیه', _totalSeconds % 60, (v) => setState(() { _totalSeconds = (_totalSeconds ~/ 60) * 60 + v; _remainingSeconds = _totalSeconds; })),
            ]),
            const SizedBox(height: 16),
            Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
              _buildPreset('۱ دقیقه', 60), _buildPreset('۳ دقیقه', 180), _buildPreset('۵ دقیقه', 300),
              _buildPreset('۱۰ دقیقه', 600), _buildPreset('۱۵ دقیقه', 900), _buildPreset('۳۰ دقیقه', 1800),
            ]),
          ],
          const SizedBox(height: 32),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _buildBtn(Icons.refresh, 'بازنشانی', Colors.grey, _reset),
            const SizedBox(width: 24),
            _buildBtn(_isRunning ? Icons.pause : Icons.play_arrow, _isRunning ? 'توقف' : 'شروع', _isRunning ? Colors.orange : AppColors.turquoise, _totalSeconds > 0 ? _toggleTimer : null, large: true),
          ]),
        ],
      ),
    );
  }

  Widget _buildTimePicker(String label, int value, Function(int) onChanged) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      IconButton(icon: const Icon(Icons.keyboard_arrow_up), onPressed: () => onChanged((value + 1).clamp(0, 23))),
      SizedBox(width: 50, child: Text(PersianNumbers.toPersian(value.toString().padLeft(2, '0')), textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      IconButton(icon: const Icon(Icons.keyboard_arrow_down), onPressed: () => onChanged((value - 1).clamp(0, 23))),
      Text(label, style: const TextStyle(fontSize: 12)),
    ]);
  }

  Widget _buildPreset(String label, int seconds) {
    return ActionChip(label: Text(label), onPressed: () => setState(() { _totalSeconds = seconds; _remainingSeconds = seconds; }));
  }

  Widget _buildBtn(IconData icon, String label, Color color, VoidCallback? onTap, {bool large = false}) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: large ? 72 : 56, height: large ? 72 : 56,
        decoration: BoxDecoration(color: onTap != null ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
        child: IconButton(icon: Icon(icon, size: large ? 32 : 24), color: onTap != null ? color : Colors.grey, onPressed: onTap),
      ),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 12, color: onTap != null ? color : Colors.grey)),
    ]);
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) { _timer?.cancel(); _isRunning = false; }
      else { _isRunning = true; _timer = Timer.periodic(const Duration(seconds: 1), (t) { setState(() { if (_remainingSeconds > 0) _remainingSeconds--; else { _timer?.cancel(); _isRunning = false; _showCompleteDialog(); } }); }); }
    });
  }

  void _reset() { _timer?.cancel(); setState(() { _isRunning = false; _remainingSeconds = _totalSeconds; }); }

  void _showCompleteDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text('زمان تمام شد!'), content: const Text('تایمر به پایان رسید.'), actions: [TextButton(onPressed: () { Navigator.pop(context); _reset(); }, child: const Text('تأیید'))]));
  }
}
