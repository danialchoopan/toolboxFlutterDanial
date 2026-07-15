import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
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
    final e = _stopwatch.elapsed;
    return '${PersianNumbers.toPersian(e.inMinutes.toString().padLeft(2, '0'))}:${PersianNumbers.toPersian((e.inSeconds % 60).toString().padLeft(2, '0'))}.${PersianNumbers.toPersian(((e.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0'))}';
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('کرنومتر')),
      body: isDesktop
          ? Row(
              children: [
                Expanded(flex: 3, child: _buildTimerSection(context)),
                Container(width: 1, color: Colors.grey[300]),
                Expanded(flex: 2, child: _buildLapsSection(context)),
              ],
            )
          : _buildMobileLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 3, child: _buildTimerSection(context)),
        Expanded(flex: 3, child: _buildLapsSection(context)),
      ],
    );
  }

  Widget _buildTimerSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 48 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_formatTime(), style: TextStyle(fontSize: MediaQuery.of(context).size.width > 600 ? 72 : 48, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: _stopwatch.isRunning ? AppColors.turquoise : null)),
            const SizedBox(height: 8),
            Text(_stopwatch.isRunning ? 'در حال اجرا' : (_laps.isNotEmpty ? 'متوقف شده' : 'آماده'), style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            const SizedBox(height: 40),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildBtn(Icons.refresh, 'بازنشانی', Colors.grey, _reset),
              const SizedBox(width: 24),
              _buildBtn(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow, _stopwatch.isRunning ? 'توقف' : 'شروع', _stopwatch.isRunning ? Colors.orange : AppColors.turquoise, _toggleStopwatch, large: true),
              const SizedBox(width: 24),
              _buildBtn(Icons.flag, 'دور', Colors.blue, _stopwatch.isRunning ? _addLap : null),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildLapsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _laps.isEmpty
        ? Center(child: Text('هنوز دوری ثبت نشده', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _laps.length,
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.only(bottom: 4),
              child: ListTile(
                leading: Text('دور ${PersianNumbers.toPersianNumber(_laps.length - i)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                trailing: Text(_laps[i], style: const TextStyle(fontFamily: 'monospace', fontSize: 16)),
              ),
            ),
          );
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

  void _toggleStopwatch() {
    setState(() {
      if (_stopwatch.isRunning) { _stopwatch.stop(); _timer?.cancel(); }
      else { _stopwatch.start(); _timer = Timer.periodic(const Duration(milliseconds: 30), (_) => setState(() {})); }
    });
  }

  void _reset() { setState(() { _stopwatch.stop(); _stopwatch.reset(); _timer?.cancel(); _laps.clear(); }); }

  void _addLap() { setState(() => _laps.insert(0, _formatTime())); }
}
