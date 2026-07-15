import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_routes.dart';
import '../common/tool_card.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.turquoise, AppColors.persianBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.build_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'جعبه ابزار',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ابزارهای کاربردی فارسی',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Quick Access Tools
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.calculate,
                    title: 'ماشین حساب',
                    route: AppRoutes.calculator,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.qr_code,
                    title: 'کد QR',
                    route: AppRoutes.qrCode,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.password,
                    title: 'سازنده رمز عبور',
                    route: AppRoutes.passwordGenerator,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.timer,
                    title: 'تایمر',
                    route: AppRoutes.timer,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.color_lens,
                    title: 'انتخاب رنگ',
                    route: AppRoutes.colorPicker,
                  ),
                  const Divider(),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings,
                    title: 'تنظیمات',
                    route: AppRoutes.settings,
                  ),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'نسخه ۱.۰.۰',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.turquoise,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Get.toNamed(route);
      },
    );
  }
}
