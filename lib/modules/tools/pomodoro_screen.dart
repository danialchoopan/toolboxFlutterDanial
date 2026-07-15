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
  final List<int> _sessionHistory = [];

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${PersianNumbers.toPersian(m.toString().padLeft(2, '0'))}:${PersianNumbers.toPersian(s.toString().padLeft(2, '0'))}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _onTimerComplete();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isBreak = false;
      _currentSession = 0;
      _totalSeconds = _workMinutes * 60;
      _remainingSeconds = _workMinutes * 60;
    });
  }

  void _onTimerComplete() {
    _timer?.cancel();
    setState(() => _isRunning = false);

    if (!_isBreak) {
      _completedSessions++;
      _sessionHistory.add(_workMinutes);

      if (_currentSession >= _sessionsBeforeLongBreak - 1) {
        _currentSession = 0;
        _isBreak = true;
        _totalSeconds = _longBreakMinutes * 60;
        _remainingSeconds = _longBreakMinutes * 60;
      } else {
        _currentSession++;
        _isBreak = true;
        _totalSeconds = _breakMinutes * 60;
        _remainingSeconds = _breakMinutes * 60;
      }
    } else {
      _isBreak = false;
      _totalSeconds = _workMinutes * 60;
      _remainingSeconds = _workMinutes * 60;
    }

    _showCompleteDialog();
  }

  void _showCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isBreak ? 'زمان استراحت تمام شد!' : 'کار تمام شد!'),
        content: Text(_isBreak ? 'وقت کار رسیده' : 'وقت استراحت رسیده'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startTimer();
            },
            child: const Text('شروع'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تایمر پومودورو'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: _showSettings),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: _isBreak ? AppColors.mint.withOpacity(0.1) : AppColors.rose.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isBreak ? 'زمان استراحت' : 'زمان کار',
                  style: TextStyle(
                    color: _isBreak ? AppColors.mint : AppColors.rose,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey[200],
                    ),
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isBreak ? AppColors.mint : AppColors.rose,
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(_remainingSeconds),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            color: _isBreak ? AppColors.mint : AppColors.rose,
                          ),
                        ),
                        Text(
                          'جلسه ${PersianNumbers.toPersianNumber(_currentSession + 1)} از ${PersianNumbers.toPersianNumber(_sessionsBeforeLongBreak)}',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(Icons.refresh, 'بازنشانی', _resetTimer),
                  const SizedBox(width: 24),
                  _buildControlButton(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    _isRunning ? 'توقف' : 'شروع',
                    _isRunning ? _pauseTimer : _startTimer,
                    isLarge: true,
                  ),
                  const SizedBox(width: 24),
                  _buildControlButton(Icons.skip_next, 'رد کردن', _onTimerComplete),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat('جلسات کامل', _completedSessions.toString()),
                  _buildStat('زمان کل', '${PersianNumbers.toPersianNumber(_sessionHistory.fold(0, (a, b) => a + b))} دقیقه'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap, {bool isLarge = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isLarge ? 72 : 56,
          height: isLarge ? 72 : 56,
          decoration: BoxDecoration(
            color: AppColors.rose.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, size: isLarge ? 32 : 24),
            color: AppColors.rose,
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.rose),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('تنظیمات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildSettingRow('زمان کار (دقیقه)', _workMinutes, (v) => setState(() => _workMinutes = v)),
            _buildSettingRow('زمان استراحت', _breakMinutes, (v) => setState(() => _breakMinutes = v)),
            _buildSettingRow('استراحت بلند', _longBreakMinutes, (v) => setState(() => _longBreakMinutes = v)),
            _buildSettingRow('جلسات قبل از استراحت بلند', _sessionsBeforeLongBreak, (v) => setState(() => _sessionsBeforeLongBreak = v)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _resetTimer();
              },
              child: const Text('اعمال'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(String label, int value, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: value > 1 ? () => onChanged(value - 1) : null,
              ),
              Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => onChanged(value + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
