import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import '../../core/constants/app_colors.dart';

class DevToolsScreen extends StatelessWidget {
  const DevToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {'title': 'UUID Generator', 'fa': 'تولید UUID', 'icon': Icons.tag, 'color': AppColors.turquoise, 'page': const UuidGeneratorScreen()},
      {'title': 'Password Generator', 'fa': 'تولید رمز عبور', 'icon': Icons.password, 'color': AppColors.rose, 'page': const AdvancedPasswordScreen()},
      {'title': 'Hash Generator', 'fa': 'تولید هش', 'icon': Icons.code, 'color': AppColors.persianBlue, 'page': const HashGeneratorScreen()},
      {'title': 'Encryption', 'fa': 'رمزگذاری', 'icon': Icons.lock, 'color': AppColors.dailyToolsColor, 'page': const EncryptionScreen()},
      {'title': 'Encoders', 'fa': 'کدگذارها', 'icon': Icons.translate, 'color': AppColors.coral, 'page': const EncodersScreen()},
      {'title': 'Color Dev Tools', 'fa': 'ابزارهای رنگ', 'icon': Icons.palette, 'color': AppColors.lavender, 'page': const ColorDevToolsScreen()},
      {'title': 'Converters', 'fa': 'مبدل‌ها', 'icon': Icons.swap_horiz, 'color': AppColors.mint, 'page': const ConverterToolsScreen()},
      {'title': 'Data Formats', 'fa': 'فرمت‌های داده', 'icon': Icons.data_object, 'color': AppColors.saffron, 'page': const DataFormatScreen()},
      {'title': 'Network Tools', 'fa': 'ابزارهای شبکه+', 'icon': Icons.wifi, 'color': AppColors.sky, 'page': const NetworkDevToolsScreen()},
      {'title': 'Regex Tester', 'fa': 'تست Regex', 'icon': Icons.text_fields, 'color': AppColors.funToolsColor, 'page': const RegexTesterScreen()},
      {'title': 'QR/Barcode', 'fa': 'QR و بارکد', 'icon': Icons.qr_code, 'color': AppColors.persianBlue, 'page': const QrBarcodeDevScreen()},
      {'title': 'JWT Decoder', 'fa': 'رمزنگار JWT', 'icon': Icons.vpn_key, 'color': AppColors.orangeGradient.colors.first, 'page': const JwtDecoderScreen()},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('ابزارهای توسعه‌دهنده')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          final color = tool['color'] as Color;
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => tool['page'] as Widget)),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 8)],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(tool['icon'] as IconData, color: color, size: 28)),
                const SizedBox(height: 8),
                Text(tool['fa'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              ]),
            ),
          );
        },
      ),
    );
  }
}

// ─── UUID Generator ───
class UuidGeneratorScreen extends StatefulWidget {
  const UuidGeneratorScreen({super.key});
  @override
  State<UuidGeneratorScreen> createState() => _UuidGeneratorScreenState();
}

class _UuidGeneratorScreenState extends State<UuidGeneratorScreen> {
  String _uuid = '';
  String _version = 'v4';
  final List<String> _history = [];

  String _generateUuid(String version) {
    final random = Random();
    if (version == 'v4') {
      final bytes = List.generate(16, (_) => random.nextInt(256));
      bytes[6] = (bytes[6] & 0x0f) | 0x40;
      bytes[8] = (bytes[8] & 0x3f) | 0x80;
      return '${_hex(bytes.sublist(0, 4))}-${_hex(bytes.sublist(4, 6))}-${_hex(bytes.sublist(6, 8))}-${_hex(bytes.sublist(8, 10))}-${_hex(bytes.sublist(10, 16))}';
    } else if (version == 'v1') {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final bytes = List.generate(16, (_) => random.nextInt(256));
      return '${_hex([(timestamp >> 24) & 0xff, (timestamp >> 16) & 0xff, (timestamp >> 8) & 0xff, timestamp & 0xff])}-${_hex([(timestamp >> 40) & 0xff, (timestamp >> 32) & 0xff])}-1${_hex([(timestamp >> 52) & 0x0f, (timestamp >> 44) & 0xff])}-${_hex([0x80 | (random.nextInt(64)), random.nextInt(256)])}-${_hex(bytes.sublist(10, 16))}';
    } else {
      final bytes = List.generate(16, (_) => random.nextInt(256));
      return '${_hex(bytes.sublist(0, 4))}-${_hex(bytes.sublist(4, 6))}-5${_hex(bytes.sublist(7, 8))}-${_hex(bytes.sublist(8, 10))}-${_hex(bytes.sublist(10, 16))}';
    }
  }

  String _hex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تولید UUID')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('نسخه', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: ['v1', 'v4', 'v5'].map((v) => ChoiceChip(label: Text(v), selected: _version == v, onSelected: (_) => setState(() => _version = v), selectedColor: AppColors.turquoise, labelStyle: TextStyle(color: _version == v ? Colors.white : null))).toList()),
          const SizedBox(height: 24),
          if (_uuid.isNotEmpty) ...[
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.turquoise.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.turquoise.withOpacity(0.2))),
              child: SelectableText(_uuid, style: const TextStyle(fontFamily: 'monospace', fontSize: 16)),
            ),
            const SizedBox(height: 12),
            Row(children: [
              ElevatedButton.icon(onPressed: () { Clipboard.setData(ClipboardData(text: _uuid)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کپی شد'))); }, icon: const Icon(Icons.copy), label: const Text('کپی')),
              const SizedBox(width: 12),
              OutlinedButton.icon(onPressed: () => setState(() { _history.insert(0, _uuid); }), icon: const Icon(Icons.save), label: const Text('ذخیره')),
            ]),
            const SizedBox(height: 24),
          ],
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => setState(() { _uuid = _generateUuid(_version); }), child: const Text('تولید UUID'))),
          const SizedBox(height: 24),
          if (_history.isNotEmpty) ...[
            const Text('تاریخچه', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, i) => Card(child: ListTile(
                title: Text(_history[i], style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                trailing: IconButton(icon: const Icon(Icons.copy, size: 18), onPressed: () { Clipboard.setData(ClipboardData(text: _history[i])); }),
              )),
            )),
          ],
        ]),
      ),
    );
  }
}

// ─── Advanced Password Generator ───
class AdvancedPasswordScreen extends StatefulWidget {
  const AdvancedPasswordScreen({super.key});
  @override
  State<AdvancedPasswordScreen> createState() => _AdvancedPasswordScreenState();
}

class _AdvancedPasswordScreenState extends State<AdvancedPasswordScreen> {
  int _length = 16;
  bool _upper = true, _lower = true, _numbers = true, _symbols = true, _pronounceable = false;
  String _password = '';
  int _pinLength = 6;
  String _pin = '';

  String _generate() {
    if (_pronounceable) {
      const consonants = 'bcdfghjklmnpqrstvwxyz';
      const vowels = 'aeiou';
      final r = Random.secure();
      var pwd = '';
      for (var i = 0; i < _length; i++) {
        pwd += r.nextBool() ? consonants[r.nextInt(consonants.length)] : vowels[r.nextInt(vowels.length)];
        if (i.isOdd) pwd = pwd.substring(0, pwd.length - 1) + pwd[pwd.length - 1].toUpperCase();
      }
      return pwd;
    }
    var chars = '';
    if (_lower) chars += 'abcdefghijklmnopqrstuvwxyz';
    if (_upper) chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (_numbers) chars += '0123456789';
    if (_symbols) chars += '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    if (chars.isEmpty) chars = 'abcdefghijklmnopqrstuvwxyz';
    return List.generate(_length, (_) => chars[Random.secure().nextInt(chars.length)]).join();
  }

  String _generatePin() => List.generate(_pinLength, (_) => Random.secure().nextInt(10).toString()).join();

  double _strength(String pwd) {
    double s = 0;
    if (pwd.length >= 8) s += 0.15;
    if (pwd.length >= 12) s += 0.15;
    if (pwd.length >= 16) s += 0.1;
    if (RegExp(r'[A-Z]').hasMatch(pwd)) s += 0.2;
    if (RegExp(r'[0-9]').hasMatch(pwd)) s += 0.2;
    if (RegExp(r'[!@#\$%^&*]').hasMatch(pwd)) s += 0.2;
    return s.clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تولید رمز عبور پیشرفته')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('طول', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(children: [
            Expanded(child: Slider(value: _length.toDouble(), min: 4, max: 128, onChanged: (v) => setState(() => _length = v.round()))),
            Text('$_length', style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
          SwitchListTile(title: const Text('حروف بزرگ'), value: _upper, onChanged: (v) => setState(() => _upper = v), activeColor: AppColors.turquoise),
          SwitchListTile(title: const Text('حروف کوچک'), value: _lower, onChanged: (v) => setState(() => _lower = v), activeColor: AppColors.turquoise),
          SwitchListTile(title: const Text('اعداد'), value: _numbers, onChanged: (v) => setState(() => _numbers = v), activeColor: AppColors.turquoise),
          SwitchListTile(title: const Text('نمادها'), value: _symbols, onChanged: (v) => setState(() => _symbols = v), activeColor: AppColors.turquoise),
          SwitchListTile(title: const Text('تلفظ‌پذیر'), value: _pronounceable, onChanged: (v) => setState(() => _pronounceable = v), activeColor: AppColors.turquoise),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => setState(() => _password = _generate()), child: const Text('تولید رمز'))),
          if (_password.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SelectableText(_password, style: const TextStyle(fontFamily: 'monospace', fontSize: 16)),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: _strength(_password), backgroundColor: Colors.grey[300], color: _strength(_password) < 0.3 ? Colors.red : _strength(_password) < 0.6 ? Colors.orange : Colors.green),
                Text(_strength(_password) < 0.3 ? 'ضعیف' : _strength(_password) < 0.6 ? 'متوسط' : 'قوی', style: TextStyle(fontSize: 12, color: _strength(_password) < 0.3 ? Colors.red : _strength(_password) < 0.6 ? Colors.orange : Colors.green)),
              ]),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(onPressed: () { Clipboard.setData(ClipboardData(text: _password)); }, icon: const Icon(Icons.copy), label: const Text('کپی')),
          ],
          const Divider(height: 40),
          const Text('تولید PIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [
            const Text('طول: '),
            for (var l in [4, 6, 8]) Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(label: Text('$l'), selected: _pinLength == l, onSelected: (_) => setState(() => _pinLength = l)),
            ),
          ]),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => setState(() => _pin = _generatePin()), child: const Text('تولید PIN')),
          if (_pin.isNotEmpty) ...[
            const SizedBox(height: 12),
            SelectableText(_pin, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'monospace', letterSpacing: 8)),
          ],
        ]),
      ),
    );
  }
}

// ─── Hash Generator ───
class HashGeneratorScreen extends StatefulWidget {
  const HashGeneratorScreen({super.key});
  @override
  State<HashGeneratorScreen> createState() => _HashGeneratorScreenState();
}

class _HashGeneratorScreenState extends State<HashGeneratorScreen> {
  final _inputController = TextEditingController();
  Map<String, String> _hashes = {};

  void _generate() {
    final input = utf8.encode(_inputController.text);
    setState(() {
      _hashes = {
        'MD5': md5.convert(input).toString(),
        'SHA-1': sha1.convert(input).toString(),
        'SHA-256': sha256.convert(input).toString(),
        'SHA-512': sha512.convert(input).toString(),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تولید هش')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(controller: _inputController, maxLines: 3, decoration: const InputDecoration(labelText: 'ورودی', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _generate, child: const Text('تولید هش'))),
          const SizedBox(height: 24),
          Expanded(child: ListView.builder(
            itemCount: _hashes.length,
            itemBuilder: (context, i) {
              final entry = _hashes.entries.elementAt(i);
              return Card(
                child: ListTile(
                  title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: SelectableText(entry.value, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                  trailing: IconButton(icon: const Icon(Icons.copy, size: 18), onPressed: () { Clipboard.setData(ClipboardData(text: entry.value)); }),
                ),
              );
            },
          )),
        ]),
      ),
    );
  }
}

// ─── Encryption Screen ───
class EncryptionScreen extends StatefulWidget {
  const EncryptionScreen({super.key});
  @override
  State<EncryptionScreen> createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  final _inputController = TextEditingController();
  final _keyController = TextEditingController();
  String _result = '';
  String _mode = 'base64';

  void _process() {
    final input = _inputController.text;
    final key = _keyController.text;
    setState(() {
      switch (_mode) {
        case 'base64': _result = base64Encode(utf8.encode(input)); break;
        case 'base64_decode': try { _result = utf8.decode(base64Decode(input)); } catch (e) { _result = 'خطا: $e'; } break;
        case 'reverse': _result = input.split('').reversed.join(); break;
        case 'upper': _result = input.toUpperCase(); break;
        case 'lower': _result = input.toLowerCase(); break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رمزنگاری و کدگذاری')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (var m in ['base64', 'base64_decode', 'upper', 'lower', 'reverse'])
              ChoiceChip(label: Text(m), selected: _mode == m, onSelected: (_) => setState(() => _mode = m)),
          ]),
          const SizedBox(height: 16),
          TextField(controller: _inputController, maxLines: 3, decoration: const InputDecoration(labelText: 'ورودی', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _process, child: const Text('پردازش'))),
          const SizedBox(height: 24),
          if (_result.isNotEmpty) ...[
            const Text('خروجی:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: SelectableText(_result, style: const TextStyle(fontFamily: 'monospace')),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(onPressed: () { Clipboard.setData(ClipboardData(text: _result)); }, icon: const Icon(Icons.copy), label: const Text('کپی')),
          ],
        ]),
      ),
    );
  }
}

// ─── Encoders Screen ───
class EncodersScreen extends StatefulWidget {
  const EncodersScreen({super.key});
  @override
  State<EncodersScreen> createState() => _EncodersScreenState();
}

class _EncodersScreenState extends State<EncodersScreen> {
  final _inputController = TextEditingController();
  String _result = '';
  String _mode = 'binary';

  void _convert() {
    final input = _inputController.text;
    setState(() {
      switch (_mode) {
        case 'binary':
          _result = input.codeUnits.map((c) => c.toRadixString(2).padLeft(8, '0')).join(' ');
          break;
        case 'binary_to_text':
          try {
            final binaries = input.split(' ');
            _result = String.fromCharCodes(binaries.map((b) => int.parse(b, radix: 2)));
          } catch (e) { _result = 'خطا'; }
          break;
        case 'hex':
          _result = input.codeUnits.map((c) => c.toRadixString(16).padLeft(2, '0')).join(' ');
          break;
        case 'hex_to_text':
          try {
            final hexes = input.split(' ');
            _result = String.fromCharCodes(hexes.map((h) => int.parse(h, radix: 16)));
          } catch (e) { _result = 'خطا'; }
          break;
        case 'decimal':
          _result = input.codeUnits.join(' ');
          break;
        case 'ascii':
          _result = input.codeUnits.join(' ');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('کدگذارها')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (var m in ['binary', 'binary_to_text', 'hex', 'hex_to_text', 'decimal', 'ascii'])
              ChoiceChip(label: Text(m.replaceAll('_', ' → ')), selected: _mode == m, onSelected: (_) => setState(() => _mode = m)),
          ]),
          const SizedBox(height: 16),
          TextField(controller: _inputController, decoration: const InputDecoration(labelText: 'ورودی', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _convert, child: const Text('تبدیل'))),
          const SizedBox(height: 24),
          if (_result.isNotEmpty) ...[
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: SelectableText(_result, style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(onPressed: () { Clipboard.setData(ClipboardData(text: _result)); }, icon: const Icon(Icons.copy), label: const Text('کپی')),
          ],
        ]),
      ),
    );
  }
}

// ─── Color Dev Tools ───
class ColorDevToolsScreen extends StatefulWidget {
  const ColorDevToolsScreen({super.key});
  @override
  State<ColorDevToolsScreen> createState() => _ColorDevToolsScreenState();
}

class _ColorDevToolsScreenState extends State<ColorDevToolsScreen> {
  Color _color = AppColors.turquoise;

  String get _hex => '#${_color.value.toRadixString(16).substring(2).toUpperCase()}';
  String get _rgb => 'rgb(${(_color.r * 255).round()}, ${(_color.g * 255).round()}, ${(_color.b * 255).round()})';
  double get _luminance => _color.computeLuminance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ابزارهای رنگ توسعه‌دهنده')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, height: 120,
            decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(_hex, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _luminance > 0.5 ? Colors.black : Colors.white))),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _formatCard('HEX', _hex)),
            const SizedBox(width: 8),
            Expanded(child: _formatCard('RGB', _rgb)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _formatCard('Luminance', _luminance.toStringAsFixed(3))),
            const SizedBox(width: 8),
            Expanded(child: _formatCard('Contrast (white)', '${(_luminance + 0.05) / 1.05 > 0.5 ? 'PASS' : 'FAIL'}')),
          ]),
          const SizedBox(height: 16),
          const Text('انتخاب رنگ', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [
            _slider('R', (_color.r * 255).round().toDouble(), Colors.red, (v) => setState(() => _color = Color.fromARGB(255, v.round(), (_color.g * 255).round(), (_color.b * 255).round()))),
            const SizedBox(width: 8),
            _slider('G', (_color.g * 255).round().toDouble(), Colors.green, (v) => setState(() => _color = Color.fromARGB(255, (_color.r * 255).round(), v.round(), (_color.b * 255).round()))),
            const SizedBox(width: 8),
            _slider('B', (_color.b * 255).round().toDouble(), Colors.blue, (v) => setState(() => _color = Color.fromARGB(255, (_color.r * 255).round(), (_color.g * 255).round(), v.round()))),
          ]),
          const SizedBox(height: 24),
          const Text('شبیه‌ساز کوری رنگ', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _blindnessCard('normal', 'عادی', _color),
            _blindnessCard('protanopia', 'قرمز-کور', _simulateColorBlindness(_color, 0)),
            _blindnessCard('deuteranopia', 'سبز-کور', _simulateColorBlindness(_color, 1)),
            _blindnessCard('tritanopia', 'آبی-کور', _simulateColorBlindness(_color, 2)),
          ]),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () { Clipboard.setData(ClipboardData(text: _hex)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کپی شد'))); },
            icon: const Icon(Icons.copy), label: const Text('کپی HEX'),
          ),
        ]),
      ),
    );
  }

  Widget _formatCard(String label, String value) {
    return Card(child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        Text(value, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
      ]),
    ));
  }

  Widget _slider(String label, double value, Color color, Function(double) onChanged) {
    return Expanded(child: Column(children: [
      Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      Slider(value: value, min: 0, max: 255, activeColor: color, onChanged: onChanged),
    ]));
  }

  Widget _blindnessCard(String type, String label, Color color) {
    return Container(
      width: 80, padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white)),
      ]),
    );
  }

  Color _simulateColorBlindness(Color color, int type) {
    final r = color.r, g = color.g, b = color.b;
    switch (type) {
      case 0: return Color.fromARGB(1, (r * 0.567 + g * 0.433).toInt(), (r * 0.558 + g * 0.442).toInt(), (g * 0.242 + b * 0.758).toInt());
      case 1: return Color.fromARGB(1, (r * 0.625 + g * 0.375).toInt(), (r * 0.7 + g * 0.3).toInt(), (g * 0.3 + b * 0.7).toInt());
      case 2: return Color.fromARGB(1, (r * 0.95 + b * 0.05).toInt(), (g * 0.433 + b * 0.567).toInt(), (g * 0.475 + b * 0.525).toInt());
      default: return color;
    }
  }
}

// ─── Converter Tools ───
class ConverterToolsScreen extends StatefulWidget {
  const ConverterToolsScreen({super.key});
  @override
  State<ConverterToolsScreen> createState() => _ConverterToolsScreenState();
}

class _ConverterToolsScreenState extends State<ConverterToolsScreen> {
  final _inputController = TextEditingController();
  String _result = '';
  String _mode = 'px_to_dp';

  void _convert() {
    final input = double.tryParse(_inputController.text) ?? 0;
    setState(() {
      switch (_mode) {
        case 'px_to_dp': _result = (input / 2.75).toStringAsFixed(2); break;
        case 'dp_to_px': _result = (input * 2.75).toStringAsFixed(2); break;
        case 'px_to_mm': _result = (input * 0.264583).toStringAsFixed(2); break;
        case 'mm_to_px': _result = (input / 0.264583).toStringAsFixed(2); break;
        case 'density': _result = 'mdpi: ${(input * 1).round()} / hdpi: ${(input * 1.5).round()} / xhdpi: ${(input * 2).round()} / xxhdpi: ${(input * 3).round()} / xxxhdpi: ${(input * 4).round()}'; break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مبدل‌ها')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (var m in ['px_to_dp', 'dp_to_px', 'px_to_mm', 'mm_to_px', 'density'])
              ChoiceChip(label: Text(m.replaceAll('_', ' → ')), selected: _mode == m, onSelected: (_) => setState(() => _mode = m)),
          ]),
          const SizedBox(height: 16),
          TextField(controller: _inputController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'مقدار', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _convert, child: const Text('تبدیل'))),
          const SizedBox(height: 24),
          if (_result.isNotEmpty) Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.turquoise.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: SelectableText(_result, style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
          ),
        ]),
      ),
    );
  }
}

// ─── Data Format Screen ───
class DataFormatScreen extends StatefulWidget {
  const DataFormatScreen({super.key});
  @override
  State<DataFormatScreen> createState() => _DataFormatScreenState();
}

class _DataFormatScreenState extends State<DataFormatScreen> {
  final _inputController = TextEditingController();
  String _result = '';
  String _mode = 'json_format';

  void _process() {
    final input = _inputController.text.trim();
    setState(() {
      switch (_mode) {
        case 'json_format':
          try {
            final obj = jsonDecode(input);
            _result = const JsonEncoder.withIndent('  ').convert(obj);
          } catch (e) { _result = 'خطا: JSON نامعتبر'; }
          break;
        case 'json_minify':
          try {
            final obj = jsonDecode(input);
            _result = jsonEncode(obj);
          } catch (e) { _result = 'خطا: JSON نامعتبر'; }
          break;
        case 'html_to_md':
          _result = input.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll(RegExp(r'\n\s*\n'), '\n\n');
          break;
        case 'md_to_html':
          _result = input.replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'<strong>$1</strong>').replaceAll(RegExp(r'\*(.*?)\*'), r'<em>$1</em>').replaceAll(RegExp(r'^# (.*)', multiLine: true), r'<h1>$1</h1>').replaceAll(RegExp(r'^## (.*)', multiLine: true), r'<h2>$1</h2>');
          break;
        case 'sql_format':
          _result = input.replaceAll(RegExp(r'\bSELECT\b', caseSensitive: false), 'SELECT').replaceAll(RegExp(r'\bFROM\b', caseSensitive: false), '\nFROM').replaceAll(RegExp(r'\bWHERE\b', caseSensitive: false), '\nWHERE').replaceAll(RegExp(r'\bAND\b', caseSensitive: false), '\n  AND').replaceAll(RegExp(r'\bOR\b', caseSensitive: false), '\n  OR');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('فرمت‌های داده')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (var m in ['json_format', 'json_minify', 'html_to_md', 'md_to_html', 'sql_format'])
              ChoiceChip(label: Text(m.replaceAll('_', ' ')), selected: _mode == m, onSelected: (_) => setState(() => _mode = m)),
          ]),
          const SizedBox(height: 16),
          TextField(controller: _inputController, maxLines: 4, decoration: const InputDecoration(labelText: 'ورودی', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _process, child: const Text('پردازش'))),
          const SizedBox(height: 16),
          if (_result.isNotEmpty) Expanded(
            child: Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(child: SelectableText(_result, style: const TextStyle(fontFamily: 'monospace', fontSize: 13))),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Network Dev Tools ───
class NetworkDevToolsScreen extends StatefulWidget {
  const NetworkDevToolsScreen({super.key});
  @override
  State<NetworkDevToolsScreen> createState() => _NetworkDevToolsScreenState();
}

class _NetworkDevToolsScreenState extends State<NetworkDevToolsScreen> {
  final _ipController = TextEditingController(text: '192.168.1.0');
  final _maskController = TextEditingController(text: '24');
  String _result = '';

  void _calculate() {
    final ip = _ipController.text;
    final mask = int.tryParse(_maskController.text) ?? 24;
    final ipParts = ip.split('.').map(int.parse).toList();
    final maskInt = 0xFFFFFFFF << (32 - mask);
    final network = ipParts[0] << 24 | ipParts[1] << 16 | ipParts[2] << 8 | ipParts[3];
    final netAddr = network & maskInt;
    final broadcast = netAddr | ~maskInt;
    final hosts = (1 << (32 - mask)) - 2;

    setState(() {
      _result = 'آدرس شبکه: ${_intToIp(netAddr)}\nبرادکست: ${_intToIp(broadcast)}\nماسک: ${_intToIp(maskInt)}\nمیزبان‌ها: $hosts\n CIDR: /$mask';
    });
  }

  String _intToIp(int ip) => '${(ip >> 24) & 0xff}.${(ip >> 16) & 0xff}.${(ip >> 8) & 0xff}.${ip & 0xff}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ابزارهای شبکه توسعه‌دهنده')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('محاسبه subnet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: TextField(controller: _ipController, decoration: const InputDecoration(labelText: 'آدرس IP', border: OutlineInputBorder()))),
            const SizedBox(width: 12),
            SizedBox(width: 80, child: TextField(controller: _maskController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'CIDR', border: OutlineInputBorder()))),
          ]),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _calculate, child: const Text('محاسبه'))),
          const SizedBox(height: 24),
          if (_result.isNotEmpty) ...[
            const Text('نتیجه:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.turquoise.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
              child: SelectableText(_result, style: const TextStyle(fontFamily: 'monospace')),
            ),
          ],
        ]),
      ),
    );
  }
}

// ─── Regex Tester ───
class RegexTesterScreen extends StatefulWidget {
  const RegexTesterScreen({super.key});
  @override
  State<RegexTesterScreen> createState() => _RegexTesterScreenState();
}

class _RegexTesterScreenState extends State<RegexTesterScreen> {
  final _patternController = TextEditingController();
  final _inputController = TextEditingController();
  List<RegExpMatch> _matches = [];
  String? _error;

  void _test() {
    try {
      final regex = RegExp(_patternController.text);
      setState(() { _matches = regex.allMatches(_inputController.text).toList(); _error = null; });
    } catch (e) { setState(() { _matches = []; _error = e.toString(); }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تست Regex')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(controller: _patternController, decoration: const InputDecoration(labelText: 'الگو (Regex)', border: OutlineInputBorder(), hintText: r'^\d+$'), textDirection: TextDirection.ltr),
          const SizedBox(height: 12),
          TextField(controller: _inputController, maxLines: 3, decoration: const InputDecoration(labelText: 'متن تست', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _test, child: const Text('تست'))),
          const SizedBox(height: 16),
          if (_error != null) Text('خطا: $_error', style: const TextStyle(color: Colors.red)),
          if (_matches.isNotEmpty) ...[
            Text('یافت شده: ${_matches.length} مورد', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(child: ListView.builder(
              itemCount: _matches.length,
              itemBuilder: (context, i) => Card(child: ListTile(
                title: Text(_matches[i].group(0) ?? '', style: const TextStyle(fontFamily: 'monospace')),
                subtitle: Text('موقعیت: ${_matches[i].start}-${_matches[i].end}'),
              )),
            )),
          ],
          const Divider(height: 30),
          const Text('راهنما', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 4, children: [
            _cheat('. - هر کاراکتر'), _cheat(r'\d - عدد'), _cheat(r'\w - حرف/عدد'),
            _cheat(r'\s - فاصله'), _cheat('* - صفر یا بیشتر'), _cheat('+ - یک یا بیشتر'),
            _cheat('? - صفر یا یک'), _cheat('^ - شروع'), _cheat(r'$ - پایان'),
          ]),
        ]),
      ),
    );
  }

  Widget _cheat(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
    child: Text(text, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
  );
}

// ─── QR/Barcode Dev Screen ───
class QrBarcodeDevScreen extends StatelessWidget {
  const QrBarcodeDevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR و بارکد')),
      body: const Center(child: Text('ابزار QR Code و Barcode', style: TextStyle(fontSize: 18))),
    );
  }
}

// ─── JWT Decoder ───
class JwtDecoderScreen extends StatefulWidget {
  const JwtDecoderScreen({super.key});
  @override
  State<JwtDecoderScreen> createState() => _JwtDecoderScreenState();
}

class _JwtDecoderScreenState extends State<JwtDecoderScreen> {
  final _jwtController = TextEditingController();
  String _header = '';
  String _payload = '';
  String _error = '';

  void _decode() {
    try {
      final parts = _jwtController.text.split('.');
      if (parts.length != 3) { setState(() { _error = 'JWT نامعتبر'; _header = ''; _payload = ''; }); return; }
      final header = utf8.decode(base64Url.decode(parts[0]));
      final payload = utf8.decode(base64Url.decode(parts[1]));
      setState(() { _header = const JsonEncoder.withIndent('  ').convert(jsonDecode(header)); _payload = const JsonEncoder.withIndent('  ').convert(jsonDecode(payload)); _error = ''; });
    } catch (e) { setState(() { _error = 'خطا: $e'; _header = ''; _payload = ''; }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رمزنگار JWT')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(controller: _jwtController, maxLines: 3, decoration: const InputDecoration(labelText: 'Token JWT', border: OutlineInputBorder(), hintText: 'eyJhbGciOiJIUzI1NiJ9...'), textDirection: TextDirection.ltr),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _decode, child: const Text('رمزنگاری'))),
          if (_error.isNotEmpty) ...[const SizedBox(height: 12), Text(_error, style: const TextStyle(color: Colors.red))],
          if (_header.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Header', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: SingleChildScrollView(child: SelectableText(_header, style: const TextStyle(fontFamily: 'monospace', fontSize: 12))))),
            const SizedBox(height: 12),
            const Text('Payload', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: SingleChildScrollView(child: SelectableText(_payload, style: const TextStyle(fontFamily: 'monospace', fontSize: 12))))),
          ],
        ]),
      ),
    );
  }
}
