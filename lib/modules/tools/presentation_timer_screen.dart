import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class PresentationTimerScreen extends StatefulWidget {
  const PresentationTimerScreen({super.key});

  @override
  State<PresentationTimerScreen> createState() => _PresentationTimerScreenState();
}

class _PresentationTimerScreenState extends State<PresentationTimerScreen> {
  int _totalSeconds = 10 * 60; // 10 min
  int _remainingSeconds = 10 * 60;
  bool _isRunning = false;
  Timer? _timer;

  // Cues
  final List<Map<String, dynamic>> _cues = [];
  int _currentCueIndex = -1;

  // Timer stages
  final List<Map<String, dynamic>> _stages = [
    {'name': 'معرفی', 'color': AppColors.turquoise, 'duration': 60},
    {'name': 'محتوا', 'color': AppColors.persianBlue, 'duration': 300},
    {'name': 'نتیجه‌گیری', 'color': AppColors.coral, 'duration': 120},
  ];
  int _currentStage = 0;

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
          _checkCues();
        } else {
          _timer?.cancel();
          _isRunning = false;
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
      _remainingSeconds = _totalSeconds;
      _currentCueIndex = -1;
      _currentStage = 0;
    });
  }

  void _checkCues() {
    final elapsed = _totalSeconds - _remainingSeconds;
    for (var i = 0; i < _cues.length; i++) {
      final cueTime = _cues[i]['time'] as int;
      if (elapsed >= cueTime && i > _currentCueIndex) {
        _currentCueIndex = i;
        _showCueNotification(_cues[i]['message']);
      }
    }
  }

  void _showCueNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.saffron,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تایمر ارائه'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showAddCue,
          ),
        ],
      ),
      body: Column(
        children: [
          // Main timer
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Current stage indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: (_stages[_currentStage]['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _stages[_currentStage]['name'],
                      style: TextStyle(
                        color: _stages[_currentStage]['color'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Timer circle
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            value: 1,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _remainingSeconds < 60
                                  ? AppColors.rose
                                  : _stages[_currentStage]['color'] as Color,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Text(
                          _formatTime(_remainingSeconds),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            color: _remainingSeconds < 60 ? AppColors.rose : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stage progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: _stages.asMap().entries.map((entry) {
                final isActive = entry.key == _currentStage;
                final color = entry.value['color'] as Color;
                return Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isActive ? color : Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(Icons.refresh, _resetTimer),
              const SizedBox(width: 24),
              _buildControlButton(
                _isRunning ? Icons.pause : Icons.play_arrow,
                _isRunning ? _pauseTimer : _startTimer,
                isLarge: true,
              ),
              const SizedBox(width: 24),
              _buildControlButton(Icons.skip_next, () {
                setState(() {
                  _currentStage = (_currentStage + 1) % _stages.length;
                });
              }),
            ],
          ),
          const SizedBox(height: 24),

          // Cues list
          if (_cues.isNotEmpty) ...[
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _cues.length,
                itemBuilder: (context, index) {
                  final cue = _cues[index];
                  final isCurrent = index == _currentCueIndex;
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.saffron.withOpacity(0.2) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCurrent ? AppColors.saffron : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatTime(cue['time']),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCurrent ? AppColors.saffron : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cue['message'],
                          style: const TextStyle(fontSize: 10),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onTap, {bool isLarge = false}) {
    return Container(
      width: isLarge ? 64 : 48,
      height: isLarge ? 64 : 48,
      decoration: BoxDecoration(
        color: AppColors.persianBlue.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: isLarge ? 32 : 24),
        color: AppColors.persianBlue,
        onPressed: onTap,
      ),
    );
  }

  void _showAddCue() {
    final messageController = TextEditingController();
    final timeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('افزودن نشانه', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: 'پیام'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'زمان (ثانیه از ابتدا)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (messageController.text.isNotEmpty && timeController.text.isNotEmpty) {
                  setState(() {
                    _cues.add({
                      'message': messageController.text,
                      'time': int.tryParse(timeController.text) ?? 0,
                    });
                    _cues.sort((a, b) => a['time'].compareTo(b['time']));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('افزودن'),
            ),
          ],
        ),
      ),
    );
  }
}
