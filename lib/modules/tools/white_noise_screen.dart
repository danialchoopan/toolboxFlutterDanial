import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class WhiteNoiseScreen extends StatefulWidget {
  const WhiteNoiseScreen({super.key});

  @override
  State<WhiteNoiseScreen> createState() => _WhiteNoiseScreenState();
}

class _WhiteNoiseScreenState extends State<WhiteNoiseScreen> {
  bool _isPlaying = false;
  String _selectedSound = 'bari_rain';
  double _volume = 0.7;

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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('نویز سفید'),
      ),
      body: Column(
        children: [
          // Visualizer
          Container(
            height: 150,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: _isPlaying
                  ? LinearGradient(
                      colors: [AppColors.turquoise.withOpacity(0.3), AppColors.persianBlue.withOpacity(0.3)],
                    )
                  : null,
              borderRadius: BorderRadius.circular(16),
              color: isDark ? AppColors.darkCard : Colors.white,
            ),
            child: Center(
              child: _isPlaying
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(20, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + index * 50),
                          width: 4,
                          height: 20 + (index % 3) * 30.0,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: AppColors.turquoise,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    )
                  : Icon(Icons.graphic_eq, size: 60, color: Colors.grey[300]),
            ),
          ),

          // Selected sound name
          Text(
            _sounds.firstWhere((s) => s['id'] == _selectedSound)['name'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Volume slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                const Icon(Icons.volume_down),
                Expanded(
                  child: Slider(
                    value: _volume,
                    onChanged: (v) => setState(() => _volume = v),
                    activeColor: AppColors.turquoise,
                  ),
                ),
                const Icon(Icons.volume_up),
              ],
            ),
          ),

          // Sound grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: _sounds.length,
              itemBuilder: (context, index) {
                final sound = _sounds[index];
                final isSelected = sound['id'] == _selectedSound;
                final color = sound['color'] as Color;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedSound = sound['id']);
                    if (!_isPlaying) {
                      setState(() => _isPlaying = true);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.2) : (isDark ? AppColors.darkCard : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(sound['icon'], color: color, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          sound['name'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? color : null,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Play/Pause button
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _isPlaying ? AppColors.roseGradient : AppColors.turquoiseGradient,
                boxShadow: [
                  BoxShadow(
                    color: (_isPlaying ? AppColors.rose : AppColors.turquoise).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 40),
                color: Colors.white,
                onPressed: () => setState(() => _isPlaying = !_isPlaying),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
