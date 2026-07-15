import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class HiitTimerScreen extends StatefulWidget {
  const HiitTimerScreen({super.key});

  @override
  State<HiitTimerScreen> createState() => _HiitTimerScreenState();
}

class _HiitTimerScreenState extends State<HiitTimerScreen> {
  int _workSeconds = 30;
  int _restSeconds = 15;
  int _rounds = 8;
  int _currentRound = 1;
  int _remainingSeconds = 30;
  bool _isRunning = false;
  bool _isWork = true;
  Timer? _timer;

  String _formatTime(int s) => '${PersianNumbers.toPersian((s ~/ 60).toString().padLeft(2, '0'))}:${PersianNumbers.toPersian((s % 60).toString().padLeft(2, '0'))}';

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  void _start() {
    setState(() { _isRunning = true; _isWork = true; _remainingSeconds = _workSeconds; _currentRound = 1; });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (_remainingSeconds > 0) _remainingSeconds--;
        else {
          if (_isWork) { _isWork = false; _remainingSeconds = _restSeconds; }
          else {
            if (_currentRound >= _rounds) { _timer?.cancel(); _isRunning = false; }
            else { _currentRound++; _isWork = true; _remainingSeconds = _workSeconds; }
          }
        }
      });
    });
  }

  void _stop() { _timer?.cancel(); setState(() => _isRunning = false); }
  void _reset() { _timer?.cancel(); setState(() { _isRunning = false; _remainingSeconds = _workSeconds; _currentRound = 1; _isWork = true; }); }

  @override
  Widget build(BuildContext context) {
    final progress = (_isWork ? _workSeconds : _restSeconds) > 0 ? _remainingSeconds / (_isWork ? _workSeconds : _restSeconds) : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('تایمر HIIT')),
      body: Column(children: [
        Expanded(
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(color: (_isWork ? AppColors.rose : AppColors.turquoise).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(_isWork ? 'زمان کار' : 'زمان استراحت', style: TextStyle(color: _isWork ? AppColors.rose : AppColors.turquoise, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 250, height: 250,
                child: Stack(alignment: Alignment.center, children: [
                  CircularProgressIndicator(value: 1, strokeWidth: 10, backgroundColor: Colors.grey[200]),
                  CircularProgressIndicator(value: progress, strokeWidth: 10, backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation<Color>(_isWork ? AppColors.rose : AppColors.turquoise), strokeCap: StrokeCap.round),
                  Text(_formatTime(_remainingSeconds), style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: _isWork ? AppColors.rose : AppColors.turquoise)),
                ]),
              ),
              const SizedBox(height: 16),
              Text('دور $_currentRound از $_rounds', style: const TextStyle(fontSize: 18)),
            ]),
          ),
        ),
        if (!_isRunning) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(child: _setting('کار', _workSeconds, (v) => setState(() => _workSeconds = v))),
              const SizedBox(width: 12),
              Expanded(child: _setting('استراحت', _restSeconds, (v) => setState(() => _restSeconds = v))),
              const SizedBox(width: 12),
              Expanded(child: _setting('دور', _rounds, (v) => setState(() => _rounds = v))),
            ]),
          ),
        ],
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _btn(Icons.refresh, _reset),
            const SizedBox(width: 24),
            _btn(_isRunning ? Icons.pause : Icons.play_arrow, _isRunning ? _stop : _start, large: true),
          ]),
        ),
        const SizedBox(height: 24),
      ]),
    );
  }

  Widget _setting(String label, int value, Function(int) onChanged) {
    return Column(children: [
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(icon: const Icon(Icons.remove_circle_outline, size: 20), onPressed: value > 1 ? () => onChanged(value - 1) : null),
        Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.add_circle_outline, size: 20), onPressed: () => onChanged(value + 1)),
      ]),
    ]);
  }

  Widget _btn(IconData icon, VoidCallback onTap, {bool large = false}) {
    return Container(
      width: large ? 72 : 56, height: large ? 72 : 56,
      decoration: BoxDecoration(color: AppColors.rose.withOpacity(0.1), shape: BoxShape.circle),
      child: IconButton(icon: Icon(icon, size: large ? 32 : 24), color: AppColors.rose, onPressed: onTap),
    );
  }
}
