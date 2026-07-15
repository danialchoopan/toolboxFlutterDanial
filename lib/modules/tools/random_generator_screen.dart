import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class RandomGeneratorScreen extends StatefulWidget {
  const RandomGeneratorScreen({super.key});

  @override
  State<RandomGeneratorScreen> createState() => _RandomGeneratorScreenState();
}

class _RandomGeneratorScreenState extends State<RandomGeneratorScreen> {
  int _currentTab = 0;
  String _result = '';
  final _controller = TextEditingController();

  // Dice
  int _diceValue = 1;

  // Coin
  bool _isHeads = true;
  bool _coinFlipping = false;

  // Wheel
  final List<String> _wheelItems = ['بله', 'خیر', 'شاید'];
  double _wheelRotation = 0;

  // Decision
  final List<String> _decisions = ['بله', 'خیر', 'شاید', 'دوباره بپرس'];

  // Name picker
  final List<String> _names = [];
  final _nameController = TextEditingController();

  // Color
  Color _randomColor = Colors.blue;

  // Card
  final List<String> _suits = ['♥', '♦', '♣', '♠'];
  final List<String> _values = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('تولیدکننده تصادفی')),
      body: Column(
        children: [
          // Tab bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _tab('عدد', 0), _tab('تاس', 1), _tab('سکه', 2),
                  _tab('چرخ', 3), _tab('تصمیم', 4), _tab('رنگ', 5),
                  _tab('کارت', 6), _tab('نام', 7),
                ],
              ),
            ),
          ),
          const Divider(),
          // Content
          Expanded(child: _buildContent(isDesktop)),
        ],
      ),
    );
  }

  Widget _tab(String label, int index) {
    final isSelected = _currentTab == index;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _currentTab = index),
        selectedColor: AppColors.turquoise,
        labelStyle: TextStyle(color: isSelected ? Colors.white : null),
      ),
    );
  }

  Widget _buildContent(bool isDesktop) {
    switch (_currentTab) {
      case 0: return _buildNumberGen(isDesktop);
      case 1: return _buildDice(isDesktop);
      case 2: return _buildCoin(isDesktop);
      case 3: return _buildWheel(isDesktop);
      case 4: return _buildDecision(isDesktop);
      case 5: return _buildColor(isDesktop);
      case 6: return _buildCard(isDesktop);
      case 7: return _buildNamePicker(isDesktop);
      default: return _buildNumberGen(isDesktop);
    }
  }

  Widget _buildNumberGen(bool isDesktop) {
    return Center(
      child: Container(
        width: isDesktop ? 400 : double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (_result.isNotEmpty) ...[
            Container(
              width: 200, height: 200,
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.turquoiseGradient, boxShadow: [BoxShadow(color: AppColors.turquoise.withOpacity(0.3), blurRadius: 20)]),
              child: Center(child: Text(PersianNumbers.toPersian(_result), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white))),
            ),
            const SizedBox(height: 32),
          ],
          Row(children: [
            Expanded(child: TextField(controller: _controller, keyboardType: TextInputType.number, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'از'))),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('تا')),
            Expanded(child: TextField(controller: _controller, keyboardType: TextInputType.number, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'تا'))),
          ]),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () {
            final min = 1, max = 100;
            setState(() => _result = (min + Random().nextInt(max - min + 1)).toString());
          }, child: const Text('تولید عدد')),
        ]),
      ),
    );
  }

  Widget _buildDice(bool isDesktop) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        GestureDetector(
          onTap: () => setState(() {
            _diceValue = 1 + Random().nextInt(6);
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 150, height: 150,
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Center(child: Text('$_diceValue', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold))),
          ),
        ),
        const SizedBox(height: 24),
        const Text('برای پرتاب ضربه بزنید', style: TextStyle(color: Colors.grey)),
      ]),
    );
  }

  Widget _buildCoin(bool isDesktop) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        GestureDetector(
          onTap: () {
            setState(() => _coinFlipping = true);
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() { _isHeads = Random().nextBool(); _coinFlipping = false; });
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 150, height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _isHeads ? AppColors.orangeGradient : AppColors.blueGradient,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)],
            ),
            child: Center(child: _coinFlipping
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(_isHeads ? 'شیر' : 'خط', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white))),
          ),
        ),
        const SizedBox(height: 24),
        Text(_coinFlipping ? 'در حال پرتاب...' : 'برای پرتاب ضربه بزنید', style: const TextStyle(color: Colors.grey)),
      ]),
    );
  }

  Widget _buildWheel(bool isDesktop) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          width: 250, height: 250,
          child: Stack(alignment: Alignment.center, children: [
            Transform.rotate(
              angle: _wheelRotation,
              child: CustomPaint(size: const Size(250, 250), painter: _WheelPainter(items: _wheelItems)),
            ),
            const Icon(Icons.arrow_drop_up, size: 40, color: Colors.red),
          ]),
        ),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () {
          setState(() { _wheelRotation += 5 + Random().nextDouble() * 10; });
        }, child: const Text('چرخاندن')),
        const SizedBox(height: 16),
        Wrap(spacing: 8, children: [
          ActionChip(label: const Text('+ افزودن'), onPressed: () {
            showModalBottomSheet(context: context, builder: (c) => Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'گزینه')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () { setState(() => _wheelItems.add(_nameController.text)); Navigator.pop(c); }, child: const Text('افزودن')),
              ]),
            ));
          }),
        ]),
      ]),
    );
  }

  Widget _buildDecision(bool isDesktop) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 200, height: 200,
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.purpleGradient, boxShadow: [BoxShadow(color: AppColors.lavender.withOpacity(0.3), blurRadius: 20)]),
          child: Center(child: Text(_result.isEmpty ? '?' : _result, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white))),
        ),
        const SizedBox(height: 32),
        ElevatedButton(onPressed: () {
          setState(() => _result = _decisions[Random().nextInt(_decisions.length)]);
        }, child: const Text('تصمیم بگیر')),
      ]),
    );
  }

  Widget _buildColor(bool isDesktop) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 200, height: 200,
          decoration: BoxDecoration(color: _randomColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: _randomColor.withOpacity(0.5), blurRadius: 20)]),
          child: Center(child: Text('#${_randomColor.value.toRadixString(16).substring(2).toUpperCase()}', style: TextStyle(color: _randomColor.computeLuminance() > 0.5 ? Colors.black : Colors.white, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 32),
        ElevatedButton(onPressed: () {
          setState(() => _randomColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1));
        }, child: const Text('رنگ تصادفی')),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () { Clipboard.setData(ClipboardData(text: '#${_randomColor.value.toRadixString(16).substring(2).toUpperCase()}')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کپی شد'))); },
          icon: const Icon(Icons.copy), label: const Text('کپی کد'),
        ),
      ]),
    );
  }

  Widget _buildCard(bool isDesktop) {
    final suit = _suits[Random().nextInt(4)];
    final value = _values[Random().nextInt(13)];
    final isRed = suit == '♥' || suit == '♦';

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 150, height: 220,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)],
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(value, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: isRed ? Colors.red : Colors.black)),
            Text(suit, style: TextStyle(fontSize: 48, color: isRed ? Colors.red : Colors.black)),
          ]),
        ),
        const SizedBox(height: 32),
        ElevatedButton(onPressed: () => setState(() {}), child: const Text('کارت جدید')),
      ]),
    );
  }

  Widget _buildNamePicker(bool isDesktop) {
    return Center(
      child: Container(
        width: isDesktop ? 400 : double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (_result.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.turquoise.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Text(_result, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.turquoise)),
            ),
            const SizedBox(height: 24),
          ],
          Row(children: [
            Expanded(child: TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'نام'))),
            IconButton(icon: const Icon(Icons.add_circle, color: AppColors.turquoise), onPressed: () {
              if (_nameController.text.isNotEmpty) { setState(() => _names.add(_nameController.text)); _nameController.clear(); }
            }),
          ]),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: _names.map((n) => Chip(label: Text(n), onDeleted: () => setState(() => _names.remove(n)))).toList()),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _names.isNotEmpty ? () => setState(() => _result = _names[Random().nextInt(_names.length)]) : null,
            child: const Text('انتخاب تصادفی'),
          ),
        ]),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<String> items;
  _WheelPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.pink, Colors.amber];

    for (var i = 0; i < items.length; i++) {
      final startAngle = (2 * 3.14159 / items.length) * i;
      final sweepAngle = 2 * 3.14159 / items.length;
      final paint = Paint()..color = colors[i % colors.length];
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, true, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
