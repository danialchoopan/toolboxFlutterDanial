import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/persian_numbers.dart';

class ColorPickerScreen extends StatefulWidget {
  const ColorPickerScreen({super.key});

  @override
  State<ColorPickerScreen> createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  Color _selectedColor = AppColors.turquoise;
  double _red = 0;
  double _green = 137;
  double _blue = 123;

  String get _hex => '#${_selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  String get _rgb => 'RGB(${_red.round()}, ${_green.round()}, ${_blue.round()})';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('انتخاب رنگ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color Preview
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
                boxShadow: [
                  BoxShadow(
                    color: _selectedColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _hex,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _selectedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            // RGB Sliders
            _buildSlider('R', _red, Colors.red, (v) => setState(() {
              _red = v;
              _selectedColor = Color.fromRGBO(_red.round(), _green.round(), _blue.round(), 1);
            })),
            _buildSlider('G', _green, Colors.green, (v) => setState(() {
              _green = v;
              _selectedColor = Color.fromRGBO(_red.round(), _green.round(), _blue.round(), 1);
            })),
            _buildSlider('B', _blue, Colors.blue, (v) => setState(() {
              _blue = v;
              _selectedColor = Color.fromRGBO(_red.round(), _green.round(), _blue.round(), 1);
            })),
            const SizedBox(height: AppDimensions.xl),

            // Color Info
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildColorInfo('HEX', _hex),
                  _buildColorInfo('RGB', _rgb),
                  _buildColorInfo('Material', _selectedColor.toString()),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Preset Colors
            Text(
              'رنگ‌های آماده',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
                Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
                Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
                Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
                Colors.brown, Colors.grey, Colors.blueGrey, Colors.black,
              ].map((c) => GestureDetector(
                onTap: () => setState(() {
                  _selectedColor = c;
                  _red = c.r * 255;
                  _green = c.g * 255;
                  _blue = c.b * 255;
                }),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedColor == c ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: _selectedColor == c
                        ? [BoxShadow(color: c.withOpacity(0.5), blurRadius: 8)]
                        : null,
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Copy Button
            ElevatedButton.icon(
              onPressed: _copyColor,
              icon: const Icon(Icons.copy),
              label: const Text('کپی کد رنگ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, Color color, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: 0,
              max: 255,
              activeColor: color,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              PersianNumbers.toPersianNumber(value.round()),
              textDirection: TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }

  void _copyColor() {
    Clipboard.setData(ClipboardData(text: _hex));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('کد رنگ $_hex کپی شد')),
    );
  }
}
