import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات'),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader('ظاهر', isDark),
          Obx(() => SwitchListTile(
            title: const Text('حالت تاریک'),
            subtitle: Text(
              themeController.isDark ? 'فعال' : 'غیرفعال',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            value: themeController.isDark,
            onChanged: (_) => themeController.toggleTheme(),
            secondary: Icon(
              themeController.isDark ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.turquoise,
            ),
          )),
          const Divider(),

          // Language Section
          _buildSectionHeader('زبان', isDark),
          ListTile(
            leading: const Icon(Icons.language, color: AppColors.persianBlue),
            title: const Text('زبان برنامه'),
            subtitle: Text(
              'فارسی',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            trailing: const Icon(Icons.chevron_left),
            onTap: () {},
          ),
          const Divider(),

          // About Section
          _buildSectionHeader('درباره', isDark),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.turquoise),
            title: const Text('نسخه برنامه'),
            subtitle: Text(
              '۱.۰.۰',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.code, color: AppColors.dailyToolsColor),
            title: const Text('ساخته شده با Flutter'),
          ),
          const Divider(),

          // Credits
          Padding(
            padding: const EdgeInsets.all(AppDimensions.xl),
            child: Text(
              'جعبه ابزار فارسی\nنسخه ۱.۰.۰',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.turquoise,
        ),
      ),
    );
  }
}
