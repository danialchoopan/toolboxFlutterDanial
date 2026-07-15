import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class BarometerScreen extends StatefulWidget {
  const BarometerScreen({super.key});

  @override
  State<BarometerScreen> createState() => _BarometerScreenState();
}

class _BarometerScreenState extends State<BarometerScreen> {
  double _pressure = 1013.25; // Default atmospheric pressure in hPa

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('فشارسنج'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gauge
              SizedBox(
                width: 250,
                height: 250,
                child: CustomPaint(
                  painter: _GaugePainter(
                    value: _pressure / 1100,
                    color: AppColors.turquoise,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _pressure.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          'hPa',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.turquoiseGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('ارتفاع تقریبی', style: TextStyle(color: Colors.white70)),
                        Text(
                          '${(_altitude).toStringAsFixed(1)} m',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(width: 1, height: 40, color: Colors.white30),
                    Column(
                      children: [
                        const Text('فشار', style: TextStyle(color: Colors.white70)),
                        Text(
                          '${_pressure.toStringAsFixed(1)} hPa',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'این ابزار فشار جوی تقریبی را نمایش می‌دهد. در دستگاه‌هایی با سنسور فشارسنج، مقدار واقعی نمایش داده می‌شود.',
                        style: TextStyle(color: Colors.amber, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get _altitude => 44330 * (1 - _pow(_pressure / 1013.25, 1 / 5.255));

  double _pow(double base, double exponent) {
    if (exponent == 0) return 1;
    if (exponent == 1) return base;
    double result = 1;
    for (int i = 0; i < exponent.abs().toInt(); i++) {
      result *= base;
    }
    return result;
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;

  _GaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 * 0.75,
      3.14159 * 1.5,
      false,
      bgPaint,
    );

    // Value arc
    final valuePaint = Paint()
      ..shader = LinearGradient(
        colors: [color, color.withOpacity(0.5)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 * 0.75,
      3.14159 * 1.5 * value.clamp(0.0, 1.0),
      false,
      valuePaint,
    );

    // Needle
    final needleAngle = -3.14159 * 0.75 + 3.14159 * 1.5 * value.clamp(0.0, 1.0);
    final needlePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      Offset(
        center.dx + (radius - 20) * _cos(needleAngle),
        center.dy + (radius - 20) * _sin(needleAngle),
      ),
      needlePaint,
    );

    canvas.drawCircle(center, 6, Paint()..color = color);
  }

  double _cos(double angle) {
    // Taylor series approximation
    double result = 1;
    double term = 1;
    for (int i = 1; i <= 10; i++) {
      term *= -angle * angle / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  double _sin(double angle) {
    // Taylor series approximation
    double result = angle;
    double term = angle;
    for (int i = 1; i <= 10; i++) {
      term *= -angle * angle / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.value != value;
}
