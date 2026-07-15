import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// White noise and ambient sound generator.
///
/// Displays a grid of ambient sound options with animated visualization.
/// Note: This is a UI shell - actual audio playback requires platform-specific
/// audio packages (audioplayers, just_audio) which need native integration.
class WhiteNoiseScreen extends StatefulWidget {
  const WhiteNoiseScreen({super.key});

  @override
  State<WhiteNoiseScreen> createState() => _WhiteNoiseScreenState();
}

class _WhiteNoiseScreenState extends State<WhiteNoiseScreen> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  String _selectedSound = 'bari_rain';
  double _volume = 0.7;
  late AnimationController _animController;

  final List<Map<String, dynamic>> _sounds = [
    {'id': 'bari_rain', 'name': 'باران', 'icon': Icons.water_drop, 'color': AppColors.sky},
    {'id': 'thunder', 'name': 'رعد و برق', 'icon': Icons.flash_on, 'color': AppColors.saffron},
    {'id': 'ocean', 'name': 'امواج دریا', 'icon': Icons.waves, 'color': AppColors.persianBlue},
    {'id': 'forest', 'name': 'جنگل', 'icon': Icons.forest, 'color': AppColors.mint},
    {'id': 'birds', 'name': 'پرندگان', 'icon': Icons.pets, 'color': AppColors.coral},
    {'id': 'fire', 'name': 'شومینه', 'icon': Icons.local_fire_department, 'color': AppColors.rose},
    {'id': 'wind', 'name': 'باد', 'icon': Icons.air, 'color': AppColors.lavender},
    {'id': 'cafe', 'name': 'کافه', 'icon': Icons.coffee, 'color': AppColors.peach},
    {'id': 'train', 'name': 'قطار', 'icon': Icons.train, 'color': AppColors.dailyToolsColor},
    {'id': 'whitenoise', 'name': 'نویز سفید', 'icon': Icons.graphic_eq, 'color': AppColors.turquoise},
    {'id': 'pinknoise', 'name': 'نویز صورتی', 'icon': Icons.graphic_eq, 'color': AppColors.rose},
    {'id': 'brownnoise', 'name': 'نویز قهوه‌ای', 'icon': Icons.graphic_eq, 'color': AppColors.coral},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('نویز سفید')),
      body: isDesktop
          ? Row(children: [_buildMainSection(context, isDark), _buildSoundGrid(context, isDark)])
          : Column(children: [
              _buildMainSection(context, isDark),
              Expanded(child: _buildSoundGrid(context, isDark)),
            ]),
    );
  }

  Widget _buildMainSection(BuildContext context, bool isDark) {
    final selectedColor = _sounds.firstWhere((s) => s['id'] == _selectedSound)['color'] as Color;

    return Container(
      width: MediaQuery.of(context).size.width > 600 ? 300 : double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Animated visualizer
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: _isPlaying
                ? LinearGradient(colors: [selectedColor.withOpacity(0.3), selectedColor.withOpacity(0.1)])
                : null,
            color: _isPlaying ? null : (isDark ? AppColors.darkCard : Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: _isPlaying
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(20, (i) => AnimatedContainer(
                    duration: Duration(milliseconds: 300 + i * 50),
                    width: 4,
                    height: 20 + (i % 3) * 30.0,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(color: selectedColor, borderRadius: BorderRadius.circular(2)),
                  )))
                : Icon(Icons.graphic_eq, size: 60, color: Colors.grey[300]),
          ),
        ),
        const SizedBox(height: 16),
        // Sound name
        Text(_sounds.firstWhere((s) => s['id'] == _selectedSound)['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        // Volume slider
        Row(children: [
          const Icon(Icons.volume_down, size: 20),
          Expanded(child: Slider(value: _volume, onChanged: (v) => setState(() => _volume = v), activeColor: AppColors.turquoise)),
          const Icon(Icons.volume_up, size: 20),
        ]),
        const SizedBox(height: 16),
        // Play/Pause button
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _isPlaying ? AppColors.roseGradient : AppColors.turquoiseGradient,
            boxShadow: [BoxShadow(color: (_isPlaying ? AppColors.rose : AppColors.turquoise).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 40),
            color: Colors.white,
            onPressed: () {
              setState(() => _isPlaying = !_isPlaying);
              _isPlaying ? _animController.repeat() : _animController.stop();
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(_isPlaying ? 'در حال پخش' : 'برای پخش ضربه بزنید', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ]),
    );
  }

  Widget _buildSoundGrid(BuildContext context, bool isDark) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3,
          mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.9,
        ),
        itemCount: _sounds.length,
        itemBuilder: (context, index) {
          final sound = _sounds[index];
          final isSelected = sound['id'] == _selectedSound;
          final color = sound['color'] as Color;
          return GestureDetector(
            onTap: () => setState(() { _selectedSound = sound['id']; if (!_isPlaying) { _isPlaying = true; _animController.repeat(); } }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.2) : (isDark ? AppColors.darkCard : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? color : Colors.transparent, width: 2),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(sound['icon'], color: color, size: 28),
                const SizedBox(height: 8),
                Text(sound['name'], style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? color : null)),
              ]),
            ),
          );
        },
      ),
    );
  }
}
