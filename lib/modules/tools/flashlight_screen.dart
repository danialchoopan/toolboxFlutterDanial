import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});

  @override
  State<FlashlightScreen> createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  bool _isOn = false;

  void _toggleFlashlight() {
    setState(() => _isOn = !_isOn);
    // Note: Actual flashlight control requires platform-specific code
    // This is a visual representation
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('چراغ قوه'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flashlight Icon
            GestureDetector(
              onTap: _toggleFlashlight,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isOn ? AppColors.saffron : (isDark ? AppColors.darkCard : Colors.grey[200]),
                  boxShadow: _isOn
                      ? [
                          BoxShadow(
                            color: AppColors.saffron.withOpacity(0.5),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  _isOn ? Icons.flash_on : Icons.flash_off,
                  size: 80,
                  color: _isOn ? Colors.white : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _isOn ? 'روشن' : 'خاموش',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isOn ? AppColors.saffron : Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'برای ${_isOn ? 'خاموش' : 'روشن'} کردن ضربه بزنید',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
