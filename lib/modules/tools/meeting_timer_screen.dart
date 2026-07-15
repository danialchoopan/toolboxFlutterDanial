import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class MeetingTimerScreen extends StatefulWidget {
  const MeetingTimerScreen({super.key});

  @override
  State<MeetingTimerScreen> createState() => _MeetingTimerScreenState();
}

class _MeetingTimerScreenState extends State<MeetingTimerScreen> {
  int _totalSeconds = 30 * 60; // 30 min default
  int _remainingSeconds = 30 * 60;
  bool _isRunning = false;
  Timer? _timer;
  final List<String> _notes = [];
  final _noteController = TextEditingController();

  // Agenda items
  final List<Map<String, dynamic>> _agenda = [];
  int _currentAgendaIndex = 0;

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${PersianNumbers.toPersian(m.toString().padLeft(2, '0'))}:${PersianNumbers.toPersian(s.toString().padLeft(2, '0'))}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تایمر جلسه'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            onPressed: _showAddAgenda,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Timer
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.darkCard : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.persianBlue.withOpacity(0.2),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _remainingSeconds < 60 ? AppColors.rose : AppColors.persianBlue,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          color: _remainingSeconds < 60 ? AppColors.rose : null,
                        ),
                      ),
                      Text(
                        'زمان باقی‌مانده',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Duration presets
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildDurationChip('۱۵ دقیقه', 15 * 60),
                _buildDurationChip('۳۰ دقیقه', 30 * 60),
                _buildDurationChip('۴۵ دقیقه', 45 * 60),
                _buildDurationChip('۶۰ دقیقه', 60 * 60),
              ],
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
              ],
            ),
            const SizedBox(height: 24),

            // Agenda
            if (_agenda.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('دستور کار', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${_currentAgendaIndex + 1}/${_agenda.length}'),
                ],
              ),
              const SizedBox(height: 8),
              ...(_agenda.asMap().entries.map((entry) => Card(
                color: entry.key == _currentAgendaIndex ? AppColors.persianBlue.withOpacity(0.1) : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: entry.key <= _currentAgendaIndex ? AppColors.turquoise : Colors.grey,
                    child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(entry.value['title']),
                  subtitle: Text('${entry.value['time']} دقیقه'),
                ),
              ))),
            ],

            // Notes
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: 'یادداشت...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.persianBlue),
                  onPressed: () {
                    if (_noteController.text.isNotEmpty) {
                      setState(() {
                        _notes.add(_noteController.text);
                        _noteController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...(_notes.map((note) => Card(
              child: ListTile(
                leading: const Icon(Icons.note, color: AppColors.persianBlue),
                title: Text(note),
              ),
            ))),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(String label, int seconds) {
    return ActionChip(
      label: Text(label),
      onPressed: () => setState(() {
        _totalSeconds = seconds;
        _remainingSeconds = seconds;
      }),
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

  void _showAddAgenda() {
    final titleController = TextEditingController();
    final timeController = TextEditingController(text: '10');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('افزودن دستور کار', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'عنوان'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'زمان (دقیقه)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _agenda.add({
                      'title': titleController.text,
                      'time': int.tryParse(timeController.text) ?? 10,
                    });
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
