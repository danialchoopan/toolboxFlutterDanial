import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class EggTimerScreen extends StatefulWidget {
  const EggTimerScreen({super.key});

  @override
  State<EggTimerScreen> createState() => _EggTimerScreenState();
}

class _EggTimerScreenState extends State<EggTimerScreen> {
  int _selectedMinutes = 5;
  int _remainingSeconds = 300;
  bool _isRunning = false;
  Timer? _timer;

  final List<Map<String, dynamic>> _presets = [
    {'name': 'نیمرو', 'minutes': 3, 'emoji': '🍳', 'color': Colors.amber},
    {'name': 'آب‌پز نرم', 'minutes': 6, 'emoji': '🥚', 'color': Colors.orange},
    {'name': 'آب‌پز معمولی', 'minutes': 10, 'emoji': '🥚', 'color': Colors.deepOrange},
    {'name': 'آب‌پز سفت', 'minutes': 12, 'emoji': '🥚', 'color': Colors.red},
  ];

  String _formatTime(int s) => '${PersianNumbers.toPersian((s ~/ 60).toString().padLeft(2, '0'))}:${PersianNumbers.toPersian((s % 60).toString().padLeft(2, '0'))}';

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  void _start() {
    setState(() { _isRunning = true; _remainingSeconds = _selectedMinutes * 60; });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (_remainingSeconds > 0) _remainingSeconds--;
        else { _timer?.cancel(); _isRunning = false; _showDoneDialog(); }
      });
    });
  }

  void _stop() { _timer?.cancel(); setState(() => _isRunning = false); }

  void _showDoneDialog() {
    showDialog(context: context, builder: (c) => AlertDialog(
      title: const Text('🥚 تخم‌مرغ آماده شد!'),
      content: const Text('زمان پخت تمام شده'),
      actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('تأیید'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_selectedMinutes * 60) > 0 ? _remainingSeconds / (_selectedMinutes * 60) : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('تایمر تخم‌مرغ')),
      body: Column(children: [
        // Egg visualization
        Expanded(
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Animated egg
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Container(
                    width: 180, height: 220,
                    decoration: BoxDecoration(
                      color: Color.lerp(Colors.white, Colors.orange, value),
                      borderRadius: BorderRadius.circular(90),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(_formatTime(_remainingSeconds), style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: _remainingSeconds < 30 ? Colors.red : Colors.black87)),
                        Text(_isRunning ? (_remainingSeconds < 30 ? 'نزدیک تمام!' : 'در حال پخت...') : 'آماده', style: TextStyle(color: Colors.grey[500])),
                      ]),
                    ),
                  );
                },
              ),
            ]),
          ),
        ),

        // Presets
        if (!_isRunning)
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _presets.length,
              itemBuilder: (context, i) {
                final preset = _presets[i];
                final isSelected = _selectedMinutes == preset['minutes'];
                return GestureDetector(
                  onTap: () => setState(() { _selectedMinutes = preset['minutes']; _remainingSeconds = preset['minutes'] * 60; }),
                  child: Container(
                    width: 100, margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? (preset['color'] as Color).withOpacity(0.1) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? preset['color'] as Color : Colors.transparent, width: 2),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(preset['emoji'], style: const TextStyle(fontSize: 24)),
                      Text(preset['name'], style: const TextStyle(fontSize: 11)),
                      Text('${preset['minutes']} دقیقه', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ]),
                  ),
                );
              },
            ),
          ),

        // Controls
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _btn(Icons.refresh, () { _timer?.cancel(); setState(() { _isRunning = false; _remainingSeconds = _selectedMinutes * 60; }); }),
            const SizedBox(width: 24),
            _btn(_isRunning ? Icons.pause : Icons.play_arrow, _isRunning ? _stop : _start, large: true),
          ]),
        ),
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap, {bool large = false}) {
    return Container(
      width: large ? 72 : 56, height: large ? 72 : 56,
      decoration: BoxDecoration(color: AppColors.turquoise.withOpacity(0.1), shape: BoxShape.circle),
      child: IconButton(icon: Icon(icon, size: large ? 32 : 24), color: AppColors.turquoise, onPressed: onTap),
    );
  }
}
