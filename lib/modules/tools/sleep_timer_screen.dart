import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class SleepTimerScreen extends StatefulWidget {
  const SleepTimerScreen({super.key});

  @override
  State<SleepTimerScreen> createState() => _SleepTimerScreenState();
}

class _SleepTimerScreenState extends State<SleepTimerScreen> {
  int _selectedMinutes = 30;
  int _remainingSeconds = 1800;
  bool _isRunning = false;
  Timer? _timer;

  final List<int> _presets = [5, 10, 15, 20, 30, 45, 60, 90, 120];

  String _formatTime(int s) => '${PersianNumbers.toPersian((s ~/ 60).toString().padLeft(2, '0'))}:${PersianNumbers.toPersian((s % 60).toString().padLeft(2, '0'))}';

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  void _start() {
    setState(() { _isRunning = true; _remainingSeconds = _selectedMinutes * 60; });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (_remainingSeconds > 0) _remainingSeconds--;
        else { _timer?.cancel(); _isRunning = false; _showDone(); }
      });
    });
  }

  void _stop() { _timer?.cancel(); setState(() => _isRunning = false); }

  void _showDone() {
    showDialog(context: context, builder: (c) => AlertDialog(
      title: const Text('زمان خواب فرا رسید'),
      content: const Text(' شب بخیر!'),
      actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('تأیید'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_selectedMinutes * 60) > 0 ? _remainingSeconds / (_selectedMinutes * 60) : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(backgroundColor: const Color(0xFF0D1117), title: const Text('تایمر خواب'), foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Moon
              Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF283593)]),
                  boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.5), blurRadius: 40, spreadRadius: 10)],
                ),
                child: Stack(alignment: Alignment.center, children: [
                  CircularProgressIndicator(value: progress, strokeWidth: 6, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber)),
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('🌙', style: TextStyle(fontSize: 40)),
                    Text(_formatTime(_remainingSeconds), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: Colors.white)),
                  ]),
                ]),
              ),
              const SizedBox(height: 24),
              Text(_isRunning ? 'در حال شمارش...' : 'زمان خواب', style: const TextStyle(color: Colors.white54, fontSize: 16)),
            ]),
          ),
        ),

        // Presets
        if (!_isRunning)
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _presets.length,
              itemBuilder: (context, i) {
                final m = _presets[i];
                final isSelected = _selectedMinutes == m;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text('$m دقیقه', style: TextStyle(color: isSelected ? Colors.white : Colors.white70)),
                    selected: isSelected,
                    onSelected: (_) => setState(() { _selectedMinutes = m; _remainingSeconds = m * 60; }),
                    selectedColor: Colors.indigo,
                    backgroundColor: Colors.white10,
                  ),
                );
              },
            ),
          ),

        // Controls
        Padding(
          padding: const EdgeInsets.all(32),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _btn(Icons.refresh, () { _timer?.cancel(); setState(() { _isRunning = false; _remainingSeconds = _selectedMinutes * 60; }); }),
            const SizedBox(width: 32),
            _btn(_isRunning ? Icons.pause : Icons.play_arrow, _isRunning ? _stop : _start, large: true),
          ]),
        ),
        const SizedBox(height: 24),
      ]),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap, {bool large = false}) {
    return Container(
      width: large ? 80 : 56, height: large ? 80 : 56,
      decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.3), shape: BoxShape.circle),
      child: IconButton(icon: Icon(icon, size: large ? 36 : 24), color: Colors.white, onPressed: onTap),
    );
  }
}
