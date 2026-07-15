import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class EnhancedWorldClockScreen extends StatefulWidget {
  const EnhancedWorldClockScreen({super.key});

  @override
  State<EnhancedWorldClockScreen> createState() => _EnhancedWorldClockScreenState();
}

class _EnhancedWorldClockScreenState extends State<EnhancedWorldClockScreen> {
  Timer? _timer;
  bool _isAnalog = false;
  String _selectedCity = 'تهران';

  final List<Map<String, dynamic>> _cities = [
    {'city': 'تهران', 'offset': 3.5, 'flag': '🇮🇷', 'country': 'ایران'},
    {'city': 'لندن', 'offset': 1.0, 'flag': '🇬🇧', 'country': 'انگلیس'},
    {'city': 'نیویورک', 'offset': -4.0, 'flag': '🇺🇸', 'country': 'آمریکا'},
    {'city': 'توکیو', 'offset': 9.0, 'flag': '🇯🇵', 'country': 'ژاپن'},
    {'city': 'دبی', 'offset': 4.0, 'flag': '🇦🇪', 'country': 'امارات'},
    {'city': 'استانبول', 'offset': 3.0, 'flag': '🇹🇷', 'country': 'ترکیه'},
    {'city': 'پاریس', 'offset': 2.0, 'flag': '🇫🇷', 'country': 'فرانسه'},
    {'city': 'برلین', 'offset': 2.0, 'flag': '🇩🇪', 'country': 'آلمان'},
    {'city': 'مسکو', 'offset': 3.0, 'flag': '🇷🇺', 'country': 'روسیه'},
    {'city': 'پکن', 'offset': 8.0, 'flag': '🇨🇳', 'country': 'چین'},
    {'city': 'سیدنی', 'offset': 11.0, 'flag': '🇦🇺', 'country': 'استرالیا'},
    {'city': 'لس‌آنجلس', 'offset': -7.0, 'flag': '🇺🇸', 'country': 'آمریکا'},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  String _getTime(double offset) {
    final now = DateTime.now().toUtc();
    final local = now.add(Duration(hours: offset.toInt(), minutes: (offset * 60).toInt() % 60));
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}:${local.second.toString().padLeft(2, '0')}';
  }

  DateTime _getDate(double offset) {
    final now = DateTime.now().toUtc();
    return now.add(Duration(hours: offset.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ساعت جهانی'),
        actions: [
          IconButton(
            icon: Icon(_isAnalog ? Icons.access_time : Icons.access_time_filled),
            onPressed: () => setState(() => _isAnalog = !_isAnalog),
          ),
        ],
      ),
      body: _isAnalog ? _buildAnalogView() : _buildDigitalView(),
    );
  }

  Widget _buildDigitalView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _cities.length,
      itemBuilder: (context, index) {
        final clock = _cities[index];
        final time = _getTime(clock['offset']);
        final date = _getDate(clock['offset']);
        final weekdays = ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه'];

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Text(clock['flag'], style: const TextStyle(fontSize: 32)),
            title: Row(children: [
              Text(clock['city'], style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Text(clock['country'], style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            ]),
            subtitle: Text('${weekdays[date.weekday % 7]} ${date.day}/${date.month}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            trailing: Text(
              PersianNumbers.toPersian(time),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: AppColors.turquoise),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalogView() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          width: 300, height: 300,
          child: CustomPaint(painter: _AnalogClockPainter(
            hour: DateTime.now().hour.toDouble(),
            minute: DateTime.now().minute.toDouble(),
            second: DateTime.now().second.toDouble(),
          )),
        ),
        const SizedBox(height: 24),
        Text(
          PersianNumbers.toPersian(_getTime(3.5)),
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: AppColors.turquoise),
        ),
        const SizedBox(height: 8),
        const Text('تهران', style: TextStyle(fontSize: 16, color: Colors.grey)),
      ]),
    );
  }
}

class _AnalogClockPainter extends CustomPainter {
  final double hour, minute, second;
  _AnalogClockPainter({required this.hour, required this.minute, required this.second});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background
    canvas.drawCircle(center, radius, Paint()..color = Colors.white..style = PaintingStyle.fill);
    canvas.drawCircle(center, radius, Paint()..color = Colors.grey[300]!..style = PaintingStyle.stroke..strokeWidth = 3);

    // Numbers
    for (var i = 1; i <= 12; i++) {
      final angle = (i * 30 - 90) * 3.14159 / 180;
      final textPainter = TextPainter(
        text: TextSpan(text: '$i', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(center.dx + (radius - 30) * cos(angle) - textPainter.width / 2, center.dy + (radius - 30) * sin(angle) - textPainter.height / 2));
    }

    // Hour hand
    final hourAngle = ((hour % 12) * 30 + minute * 0.5 - 90) * 3.14159 / 180;
    canvas.drawLine(center, Offset(center.dx + (radius * 0.5) * cos(hourAngle), center.dy + (radius * 0.5) * sin(hourAngle)), Paint()..color = Colors.black87..strokeWidth = 6..strokeCap = StrokeCap.round);

    // Minute hand
    final minAngle = (minute * 6 - 90) * 3.14159 / 180;
    canvas.drawLine(center, Offset(center.dx + (radius * 0.7) * cos(minAngle), center.dy + (radius * 0.7) * sin(minAngle)), Paint()..color = Colors.black54..strokeWidth = 4..strokeCap = StrokeCap.round);

    // Second hand
    final secAngle = (second * 6 - 90) * 3.14159 / 180;
    canvas.drawLine(center, Offset(center.dx + (radius * 0.8) * cos(secAngle), center.dy + (radius * 0.8) * sin(secAngle)), Paint()..color = Colors.red..strokeWidth = 2..strokeCap = StrokeCap.round);

    // Center dot
    canvas.drawCircle(center, 6, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
