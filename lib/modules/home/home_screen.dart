import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/theme_controller.dart';
import '../../widgets/common/tool_card.dart';
import '../../widgets/common/search_bar_widget.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../../widgets/navigation/side_drawer.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('جعبه ابزار'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => Get.find<ThemeController>().toggleTheme(),
          ),
        ],
      ),
      drawer: const SideDrawer(),
      body: Obx(() => _buildBody(context, controller)),
      bottomNavigationBar: Obx(() => BottomNavBar(
        currentIndex: controller.currentTab.value,
        onTap: controller.changeTab,
      )),
    );
  }

  Widget _buildBody(BuildContext context, HomeController controller) {
    switch (controller.currentTab.value) {
      case 0:
        return _buildHomeTab(context, controller);
      case 1:
        return _buildCategoriesTab(context);
      case 2:
        return _buildFavoritesTab(context, controller);
      case 3:
        return _buildSearchTab(context, controller);
      case 4:
        return _buildSettingsTab(context);
      default:
        return _buildHomeTab(context, controller);
    }
  }

  Widget _buildHomeTab(BuildContext context, HomeController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          SearchBarWidget(
            onChanged: (value) => controller.searchQuery.value = value,
          ),
          const SizedBox(height: AppDimensions.xl),

          // Quick Access
          _buildSectionTitle(context, 'دسترسی سریع'),
          const SizedBox(height: AppDimensions.sm),
          _buildQuickAccessGrid(context),
          const SizedBox(height: AppDimensions.xl),

          // All Tools
          _buildSectionTitle(context, 'همه ابزارها'),
          const SizedBox(height: AppDimensions.sm),
          _buildAllToolsGrid(context, controller),
        ],
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppDimensions.sm,
      crossAxisSpacing: AppDimensions.sm,
      childAspectRatio: 0.9,
      children: [
        ToolCard(
          title: 'ماشین حساب',
          icon: Icons.calculate,
          color: AppColors.calcToolsColor,
          onTap: () => Get.toNamed(AppRoutes.calculator),
        ),
        ToolCard(
          title: 'QR Code',
          icon: Icons.qr_code,
          color: AppColors.persianBlue,
          onTap: () => Get.toNamed(AppRoutes.qrCode),
        ),
        ToolCard(
          title: 'تایمر',
          icon: Icons.timer,
          color: AppColors.dailyToolsColor,
          onTap: () => Get.toNamed(AppRoutes.timer),
        ),
        ToolCard(
          title: 'رمزنگار',
          icon: Icons.password,
          color: AppColors.rose,
          onTap: () => Get.toNamed(AppRoutes.passwordGenerator),
        ),
      ],
    );
  }

  Widget _buildAllToolsGrid(BuildContext context, HomeController controller) {
    final tools = controller.allTools;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppDimensions.sm,
        crossAxisSpacing: AppDimensions.sm,
        childAspectRatio: 0.9,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return ToolCard(
          title: tool['title'],
          icon: tool['icon'],
          color: tool['color'],
          onTap: () => Get.toNamed(tool['route']),
        );
      },
    );
  }

  Widget _buildCategoriesTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'دسته‌بندی ابزارها'),
          const SizedBox(height: AppDimensions.md),
          _buildCategoryCard(
            context,
            title: 'ابزارهای متنی',
            icon: Icons.text_fields,
            color: AppColors.textToolsColor,
            tools: ['ویرایشگر متن', 'شمارش کلمات'],
            routes: [AppRoutes.textEditor, AppRoutes.wordCounter],
          ),
          _buildCategoryCard(
            context,
            title: 'ماشین حساب و تبدیل',
            icon: Icons.calculate,
            color: AppColors.calcToolsColor,
            tools: ['ماشین حساب', 'تبدیل واحد', 'تبدیل ارز', 'کد QR', 'رمزعبور'],
            routes: [
              AppRoutes.calculator,
              AppRoutes.unitConverter,
              AppRoutes.currencyConverter,
              AppRoutes.qrCode,
              AppRoutes.passwordGenerator,
            ],
          ),
          _buildCategoryCard(
            context,
            title: 'ابزارهای روزمره',
            icon: Icons.access_time,
            color: AppColors.dailyToolsColor,
            tools: ['کرنومتر', 'تایمر', 'ساعت جهانی', 'چراغ قوه', 'قطب‌نما'],
            routes: [
              AppRoutes.stopwatch,
              AppRoutes.timer,
              AppRoutes.worldClock,
              AppRoutes.flashlight,
              AppRoutes.compass,
            ],
          ),
          _buildCategoryCard(
            context,
            title: 'سلامت و سبک زندگی',
            icon: Icons.favorite,
            color: AppColors.healthToolsColor,
            tools: ['BMI', 'محاسبه سن', 'تخفیف', 'انعام'],
            routes: [
              AppRoutes.bmiCalculator,
              AppRoutes.ageCalculator,
              AppRoutes.discountCalculator,
              AppRoutes.tipCalculator,
            ],
          ),
          _buildCategoryCard(
            context,
            title: 'سرگرمی و خلاقیت',
            icon: Icons.star,
            color: AppColors.funToolsColor,
            tools: ['عدد تصادفی'],
            routes: [AppRoutes.randomNumber],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<String> tools,
    required List<String> routes,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        children: tools.asMap().entries.map((entry) {
          return ListTile(
            title: Text(entry.value),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => Get.toNamed(routes[entry.key]),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFavoritesTab(BuildContext context, HomeController controller) {
    if (controller.favoriteTools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: AppColors.lightTextSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'هنوز علاقه‌مندی اضافه نشده',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.lg),
      itemCount: controller.favoriteTools.length,
      itemBuilder: (context, index) {
        final tool = controller.favoriteTools[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.sm),
          child: ListTile(
            leading: Icon(tool['icon'], color: tool['color']),
            title: Text(tool['title']),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => Get.toNamed(tool['route']),
          ),
        );
      },
    );
  }

  Widget _buildSearchTab(BuildContext context, HomeController controller) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        children: [
          SearchBarWidget(
            controller: controller.searchController,
            onChanged: (value) => controller.searchQuery.value = value,
            autofocus: true,
          ),
          const SizedBox(height: AppDimensions.lg),
          Expanded(
            child: Obx(() {
              final results = controller.searchResults;
              if (results.isEmpty) {
                return Center(
                  child: Text(
                    'ابزاری یافت نشد',
                    style: TextStyle(
                      color: AppColors.lightTextSecondary,
                      fontSize: 16,
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final tool = results[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: ListTile(
                      leading: Icon(tool['icon'], color: tool['color']),
                      title: Text(tool['title']),
                      trailing: const Icon(Icons.chevron_left),
                      onTap: () => Get.toNamed(tool['route']),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(BuildContext context) {
    return const Center(
      child: Text('تنظیمات'),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
    );
  }
}
