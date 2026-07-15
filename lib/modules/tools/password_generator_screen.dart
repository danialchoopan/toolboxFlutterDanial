import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/persian_numbers.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  int _length = 16;
  bool _includeUppercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  String _password = '';
  double _strength = 0;

  final _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  final _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final _numbers = '0123456789';
  final _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سازنده رمز عبور'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Generated Password
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
                border: Border.all(
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _password,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Strength indicator
                  LinearProgressIndicator(
                    value: _strength,
                    backgroundColor: Colors.grey[300],
                    color: _strength < 0.3
                        ? Colors.red
                        : _strength < 0.6
                            ? Colors.orange
                            : _strength < 0.8
                                ? Colors.yellow[700]
                                : Colors.green,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _strengthText,
                    style: TextStyle(
                      fontSize: 12,
                      color: _strength < 0.3
                          ? Colors.red
                          : _strength < 0.6
                              ? Colors.orange
                              : _strength < 0.8
                                  ? Colors.yellow[700]
                                  : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generatePassword,
                    icon: const Icon(Icons.refresh),
                    label: const Text('تولید'),
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _copyPassword,
                    icon: const Icon(Icons.copy),
                    label: const Text('کپی'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.xl),

            // Length Slider
            Text('طول رمز: ${PersianNumbers.toPersianNumber(_length)}'),
            Slider(
              value: _length.toDouble(),
              min: 6,
              max: 64,
              divisions: 58,
              label: PersianNumbers.toPersianNumber(_length),
              onChanged: (v) => setState(() {
                _length = v.round();
                _generatePassword();
              }),
            ),
            const SizedBox(height: AppDimensions.md),

            // Options
            SwitchListTile(
              title: const Text('شامل حروف بزرگ'),
              value: _includeUppercase,
              onChanged: (v) => setState(() {
                _includeUppercase = v;
                _generatePassword();
              }),
              activeColor: AppColors.turquoise,
            ),
            SwitchListTile(
              title: const Text('شامل اعداد'),
              value: _includeNumbers,
              onChanged: (v) => setState(() {
                _includeNumbers = v;
                _generatePassword();
              }),
              activeColor: AppColors.turquoise,
            ),
            SwitchListTile(
              title: const Text('شامل نمادها'),
              value: _includeSymbols,
              onChanged: (v) => setState(() {
                _includeSymbols = v;
                _generatePassword();
              }),
              activeColor: AppColors.turquoise,
            ),
          ],
        ),
      ),
    );
  }

  String get _strengthText {
    if (_strength < 0.3) return 'ضعیف';
    if (_strength < 0.6) return 'متوسط';
    if (_strength < 0.8) return 'خوب';
    return 'قوی';
  }

  void _generatePassword() {
    var chars = _lowercase;
    if (_includeUppercase) chars += _uppercase;
    if (_includeNumbers) chars += _numbers;
    if (_includeSymbols) chars += _symbols;

    if (chars.isEmpty) chars = _lowercase;

    final random = Random.secure();
    final password = List.generate(_length, (_) => chars[random.nextInt(chars.length)]).join();

    setState(() {
      _password = password;
      _calculateStrength();
    });
  }

  void _calculateStrength() {
    double strength = 0;
    if (_password.length >= 8) strength += 0.2;
    if (_password.length >= 12) strength += 0.2;
    if (_password.length >= 16) strength += 0.1;
    if (_includeUppercase) strength += 0.15;
    if (_includeNumbers) strength += 0.15;
    if (_includeSymbols) strength += 0.2;
    _strength = strength.clamp(0.0, 1.0);
  }

  void _copyPassword() {
    Clipboard.setData(ClipboardData(text: _password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('رمز عبور کپی شد')),
    );
  }
}
