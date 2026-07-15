import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _workMinutes = 25;
  int _breakMinutes = 5;
  int _longBreakMinutes = 15;
  int _sessionsBeforeLongBreak = 4;
  int _currentSession = 0;
  int _totalSeconds = 25 * 60;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  bool _isBreak = false;
  Timer? _timer;
  int _completedSessions = 0;

  String _formatTime(int s) => '${PersianNumbers.toPersian((s ~/ 60).toString().padLeft(2, '0'))}:${PersianNumbers.toPersian((s % 60).toString().padLeft(2, '0'))}';

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (_remainingSeconds > 0) _remainingSeconds--;
        else _onComplete();
      });
    });
  }

  void _pauseTimer() { _timer?.cancel(); setState(() => _isRunning = false); }

  void _resetTimer() {
    _timer?.cancel();
    setState(() { _isRunning = false; _isBreak = false; _currentSession = 0; _totalSeconds = _workMinutes * 60; _remainingSeconds = _workMinutes * 60; });
  }

  void _onComplete() {
    _timer?.cancel();
    setState(() => _isRunning = false);
    if (!_isBreak) {
      _completedSessions++;
      if (_currentSession >= _sessionsBeforeLongBreak - 1) { _currentSession = 0; _isBreak = true; _totalSeconds = _longBreakMinutes * 60; _remainingSeconds = _longBreakMinutes * 60; }
      else { _currentSession++; _isBreak = true; _totalSeconds = _breakMinutes * 60; _remainingSeconds = _breakMinutes * 60; }
    } else { _isBreak = false; _totalSeconds = _workMinutes * 60; _remainingSeconds = _workMinutes * 60; }
    showDialog(context: context, builder: (c) => AlertDialog(title: Text(_isBreak ? 'وقت کار رسیده' : 'وقت استراحت رسیده'), actions: [TextButton(onPressed: () { Navigator.pop(c); _startTimer(); }, child: const Text('شروع'))]));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;
    final progress = _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('تایمر پومودورو'), actions: [IconButton(icon: const Icon(Icons.settings), onPressed: _showSettings)]),
      body: isDesktop
          ? Row(children: [
              Expanded(flex: 3, child: _buildTimer(context, progress, isDark)),
              Container(width: 1, color: Colors.grey[300]),
              Expanded(flex: 2, child: _buildStatsAndControls()),
            ])
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(children: [_buildTimer(context, progress, isDark), const SizedBox(height: 32), _buildStatsAndControls()]),
            ),
    );
  }

  Widget _buildTimer(BuildContext context, double progress, bool isDark) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(color: _isBreak ? AppColors.mint.withOpacity(0.1) : AppColors.rose.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
          child: Text(_isBreak ? 'زمان استراحت' : 'زمان کار', style: TextStyle(color: _isBreak ? AppColors.mint : AppColors.rose, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: isDesktop ? 280 : 220, height: isDesktop ? 280 : 220,
          child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(value: 1, strokeWidth: 10, backgroundColor: Colors.grey[200]),
            CircularProgressIndicator(value: progress, strokeWidth: 10, backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation<Color>(_isBreak ? AppColors.mint : AppColors.rose), strokeCap: StrokeCap.round),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text(_formatTime(_remainingSeconds), style: TextStyle(fontSize: isDesktop ? 56 : 48, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: _isBreak ? AppColors.mint : AppColors.rose)),
              Text('جلسه ${PersianNumbers.toPersianNumber(_currentSession + 1)} از ${PersianNumbers.toPersianNumber(_sessionsBeforeLongBreak)}', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _buildStatsAndControls() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _buildBtn(Icons.refresh, _resetTimer), const SizedBox(width: 24),
          _buildBtn(_isRunning ? Icons.pause : Icons.play_arrow, _isRunning ? _pauseTimer : _startTimer, large: true),
          const SizedBox(width: 24), _buildBtn(Icons.skip_next, _onComplete),
        ]),
        const SizedBox(height: 32),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [Text('$_completedSessions', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.rose)), Text('جلسات', style: TextStyle(color: Colors.grey[500]))]),
          Column(children: [Text('${PersianNumbers.toPersianNumber(_sessionMinutes)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.rose)), Text('دقیقه', style: TextStyle(color: Colors.grey[500]))]),
        ]),
      ]),
    );
  }

  int get _sessionMinutes => _completedSessions * _workMinutes;

  Widget _buildBtn(IconData icon, VoidCallback onTap, {bool large = false}) {
    return Container(
      width: large ? 72 : 56, height: large ? 72 : 56,
      decoration: BoxDecoration(color: AppColors.rose.withOpacity(0.1), shape: BoxShape.circle),
      child: IconButton(icon: Icon(icon, size: large ? 32 : 24), color: AppColors.rose, onPressed: onTap),
    );
  }

  void _showSettings() {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (c) => Container(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('تنظیمات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _settingRow('زمان کار', _workMinutes, (v) => setState(() => _workMinutes = v)),
        _settingRow('استراحت', _breakMinutes, (v) => setState(() => _breakMinutes = v)),
        _settingRow('استراحت بلند', _longBreakMinutes, (v) => setState(() => _longBreakMinutes = v)),
        _settingRow('جلسات', _sessionsBeforeLongBreak, (v) => setState(() => _sessionsBeforeLongBreak = v)),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: () { Navigator.pop(c); _resetTimer(); }, child: const Text('اعمال')),
      ]),
    ));
  }

  Widget _settingRow(String label, int value, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label),
        Row(children: [
          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: value > 1 ? () => onChanged(value - 1) : null),
          Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => onChanged(value + 1)),
        ]),
      ]),
    );
  }
}
