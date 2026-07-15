import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

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
  void initState() { super.initState(); _generatePassword(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('سازنده رمز عبور')),
      body: isDesktop
          ? Row(
              children: [
                Expanded(flex: 3, child: _buildDisplay(context)),
                Container(width: 1, color: Colors.grey[300]),
                Expanded(flex: 2, child: _buildOptions(context)),
              ],
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [_buildDisplay(context), const SizedBox(height: 24), _buildOptions(context)]),
            ),
    );
  }

  Widget _buildDisplay(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 32 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkDivider : Colors.grey[200]!),
            ),
            child: Column(
              children: [
                SelectableText(_password, style: const TextStyle(fontSize: 20, fontFamily: 'monospace', letterSpacing: 2)),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _strength,
                  backgroundColor: Colors.grey[300],
                  color: _strength < 0.3 ? Colors.red : _strength < 0.6 ? Colors.orange : _strength < 0.8 ? Colors.yellow[700] : Colors.green,
                ),
                const SizedBox(height: 8),
                Text(_strength < 0.3 ? 'ضعیف' : _strength < 0.6 ? 'متوسط' : _strength < 0.8 ? 'خوب' : 'قوی',
                    style: TextStyle(fontSize: 12, color: _strength < 0.3 ? Colors.red : _strength < 0.6 ? Colors.orange : _strength < 0.8 ? Colors.yellow[700] : Colors.green)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ElevatedButton.icon(onPressed: _generatePassword, icon: const Icon(Icons.refresh), label: const Text('تولید'))),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton.icon(onPressed: _copyPassword, icon: const Icon(Icons.copy), label: const Text('کپی'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 32 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('تنظیمات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('طول رمز: ${_length.toString()}'),
          Slider(value: _length.toDouble(), min: 6, max: 64, divisions: 58, label: '$_length', onChanged: (v) => setState(() { _length = v.round(); _generatePassword(); })),
          SwitchListTile(title: const Text('شامل حروف بزرگ'), value: _includeUppercase, onChanged: (v) => setState(() { _includeUppercase = v; _generatePassword(); }), activeColor: AppColors.turquoise),
          SwitchListTile(title: const Text('شامل اعداد'), value: _includeNumbers, onChanged: (v) => setState(() { _includeNumbers = v; _generatePassword(); }), activeColor: AppColors.turquoise),
          SwitchListTile(title: const Text('شامل نمادها'), value: _includeSymbols, onChanged: (v) => setState(() { _includeSymbols = v; _generatePassword(); }), activeColor: AppColors.turquoise),
        ],
      ),
    );
  }

  void _generatePassword() {
    var chars = _lowercase;
    if (_includeUppercase) chars += _uppercase;
    if (_includeNumbers) chars += _numbers;
    if (_includeSymbols) chars += _symbols;
    if (chars.isEmpty) chars = _lowercase;
    final random = Random.secure();
    final password = List.generate(_length, (_) => chars[random.nextInt(chars.length)]).join();
    setState(() { _password = password; _calculateStrength(); });
  }

  void _calculateStrength() {
    double s = 0;
    if (_password.length >= 8) s += 0.2;
    if (_password.length >= 12) s += 0.2;
    if (_password.length >= 16) s += 0.1;
    if (_includeUppercase) s += 0.15;
    if (_includeNumbers) s += 0.15;
    if (_includeSymbols) s += 0.2;
    _strength = s.clamp(0.0, 1.0);
  }

  void _copyPassword() {
    Clipboard.setData(ClipboardData(text: _password));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('رمز عبور کپی شد')));
  }
}
