import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  double _heading = 0;

  String _getDirection(double heading) {
    if (heading >= 337.5 || heading < 22.5) return 'شمال';
    if (heading >= 22.5 && heading < 67.5) return 'شمال شرق';
    if (heading >= 67.5 && heading < 112.5) return 'شرق';
    if (heading >= 112.5 && heading < 157.5) return 'جنوب شرق';
    if (heading >= 157.5 && heading < 202.5) return 'جنوب';
    if (heading >= 202.5 && heading < 247.5) return 'جنوب غرب';
    if (heading >= 247.5 && heading < 292.5) return 'غرب';
    return 'شمال غرب';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('قطب‌نما'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Direction Text
            Text(
              _getDirection(_heading),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_heading.toStringAsFixed(1)}°',
              style: TextStyle(
                fontSize: 18,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Compass
            SizedBox(
              width: 280,
              height: 280,
              child: CustomPaint(
                painter: CompassPainter(heading: _heading),
              ),
            ),
            const SizedBox(height: 32),

            // Simulate rotation
            Slider(
              value: _heading,
              min: 0,
              max: 360,
              onChanged: (v) => setState(() => _heading = v),
            ),
          ],
        ),
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  final double heading;

  CompassPainter({required this.heading});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Border
    final borderPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    // Cardinal directions
    final directions = ['N', 'E', 'S', 'W'];
    final angles = [270, 0, 90, 180]; // N=up, E=right, S=down, W=left

    for (var i = 0; i < 4; i++) {
      final angle = (angles[i] - heading) * pi / 180;
      final textPainter = TextPainter(
        text: TextSpan(
          text: directions[i],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: i == 0 ? Colors.red : Colors.black87,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final offset = Offset(
        center.dx + (radius - 30) * cos(angle) - textPainter.width / 2,
        center.dy + (radius - 30) * sin(angle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, offset);
    }

    // Tick marks
    final tickPaint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 1;
    for (var i = 0; i < 36; i++) {
      final angle = (i * 10 - heading) * pi / 180;
      final innerRadius = radius - 15;
      final outerRadius = radius - 5;
      canvas.drawLine(
        Offset(center.dx + innerRadius * cos(angle), center.dy + innerRadius * sin(angle)),
        Offset(center.dx + outerRadius * cos(angle), center.dy + outerRadius * sin(angle)),
        tickPaint,
      );
    }

    // Needle
    final needlePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final needleAngle = -heading * pi / 180;
    canvas.drawLine(
      center,
      Offset(center.dx + (radius - 40) * cos(needleAngle), center.dy + (radius - 40) * sin(needleAngle)),
      needlePaint,
    );

    // Center dot
    final dotPaint = Paint()..color = Colors.black;
    canvas.drawCircle(center, 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CompassPainter oldDelegate) => oldDelegate.heading != heading;
}
