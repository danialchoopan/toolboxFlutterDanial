import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

class ColorPaletteScreen extends StatefulWidget {
  const ColorPaletteScreen({super.key});

  @override
  State<ColorPaletteScreen> createState() => _ColorPaletteScreenState();
}

class _ColorPaletteScreenState extends State<ColorPaletteScreen> {
  List<Color> _palette = [];
  String _mode = 'random';

  final List<List<Color>> _savedPalettes = [];

  @override
  void initState() {
    super.initState();
    _generatePalette();
  }

  void _generatePalette() {
    final random = Random();
    switch (_mode) {
      case 'random':
        _palette = List.generate(5, (_) => Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1));
        break;
      case 'complementary':
        final base = HSLColor.fromColor(Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1));
        _palette = [base.toColor(), base.withHue((base.hue + 180) % 360).toColor()];
        _palette.addAll(List.generate(3, (_) => base.withLightness((base.lightness + random.nextDouble() * 0.3 - 0.15).clamp(0, 1)).toColor()));
        break;
      case 'analogous':
        final base = HSLColor.fromColor(Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1));
        _palette = List.generate(5, (i) => base.withHue((base.hue + i * 30 - 60) % 360).toColor());
        break;
      case 'triadic':
        final base = HSLColor.fromColor(Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1));
        _palette = [base.toColor(), base.withHue((base.hue + 120) % 360).toColor(), base.withHue((base.hue + 240) % 360).toColor()];
        _palette.addAll([base.withLightness(0.7).toColor(), base.withLightness(0.3).toColor()]);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('پالت رنگ'),
        actions: [
          IconButton(icon: const Icon(Icons.save_outlined), onPressed: _savePalette),
        ],
      ),
      body: Column(
        children: [
          // Mode selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(spacing: 8, children: [
              _modeBtn('تصادفی', 'random'),
              _modeBtn('مکمل', 'complementary'),
              _modeBtn('مشابه', 'analogous'),
              _modeBtn('سه‌گانه', 'triadic'),
            ]),
          ),

          // Palette display
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _palette.map((color) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: '#${color.value.toRadixString(16).substring(2).toUpperCase()}'));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('کپی شد: #${color.value.toRadixString(16).substring(2).toUpperCase()}')));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
                          child: Text('#${color.value.toRadixString(16).substring(2).toUpperCase()}', style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'monospace'), textAlign: TextAlign.center),
                        ),
                      ]),
                    ),
                  ),
                )).toList(),
              ),
            ),
          ),

          // Generate button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => setState(() { _generatePalette(); }),
                icon: const Icon(Icons.refresh),
                label: const Text('تولید پالت جدید'),
              ),
            ),
          ),

          // Saved palettes
          if (_savedPalettes.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(alignment: Alignment.centerRight, child: Text('پالت‌های ذخیره شده', style: TextStyle(fontWeight: FontWeight.bold))),
            ),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _savedPalettes.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 8, top: 8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: _savedPalettes[index].map((c) => Expanded(child: Container(color: c))).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _modeBtn(String label, String mode) {
    final isSelected = _mode == mode;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() { _mode = mode; _generatePalette(); }),
      selectedColor: AppColors.turquoise,
      labelStyle: TextStyle(color: isSelected ? Colors.white : null),
    );
  }

  void _savePalette() {
    setState(() => _savedPalettes.add(List.from(_palette)));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('پالت ذخیره شد')));
  }
}
