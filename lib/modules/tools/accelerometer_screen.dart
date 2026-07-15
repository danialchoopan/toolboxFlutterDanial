import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../core/constants/app_colors.dart';

class AccelerometerScreen extends StatefulWidget {
  const AccelerometerScreen({super.key});

  @override
  State<AccelerometerScreen> createState() => _AccelerometerScreenState();
}

class _AccelerometerScreenState extends State<AccelerometerScreen> {
  double _x = 0, _y = 0, _z = 0;
  double _maxX = 0, _maxY = 0, _maxZ = 0;
  StreamSubscription? _subscription;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _startListening() {
    _subscription = accelerometerEventStream().listen((event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;
        if (_isRecording) {
          _maxX = _x.abs() > _maxX ? _x.abs() : _maxX;
          _maxY = _y.abs() > _maxY ? _y.abs() : _maxY;
          _maxZ = _z.abs() > _maxZ ? _z.abs() : _maxZ;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('شتاب‌سنج'),
        actions: [
          IconButton(
            icon: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record),
            onPressed: () {
              setState(() {
                _isRecording = !_isRecording;
                if (_isRecording) {
                  _maxX = 0;
                  _maxY = 0;
                  _maxZ = 0;
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 3D Ball indicator
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.turquoise.withOpacity(0.2), AppColors.persianBlue.withOpacity(0.2)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.turquoise.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Grid lines
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: _GridPainter(),
                  ),
                  // Ball
                  Transform.translate(
                    offset: Offset(_x * 10, -_y * 10),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.turquoiseGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.turquoise.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // X, Y, Z values
            _buildValueCard('محور X', _x, Colors.red),
            const SizedBox(height: 12),
            _buildValueCard('محور Y', _y, Colors.green),
            const SizedBox(height: 12),
            _buildValueCard('محور Z', _z, Colors.blue),

            if (_isRecording) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.rose.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text('حداکثر مقادیر', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMaxValue('X', _maxX, Colors.red),
                        _buildMaxValue('Y', _maxY, Colors.green),
                        _buildMaxValue('Z', _maxZ, Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(
            '${value.toStringAsFixed(3)} m/s²',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaxValue(String axis, double value, Color color) {
    return Column(
      children: [
        Text(axis, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Circles
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * i / 4, paint);
    }

    // Cross
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
