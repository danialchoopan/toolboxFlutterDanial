import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/theme_controller.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffold : AppColors.lightScaffold,
      body: SafeArea(
        child: Obx(() => _buildBody(context, controller)),
      ),
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

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 120,
          floating: true,
          pinned: true,
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? AppColors.saffron : AppColors.persianBlue,
              ),
              onPressed: () => Get.find<ThemeController>().toggleTheme(),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? LinearGradient(colors: [AppColors.darkSurface, AppColors.darkBackground])
                    : LinearGradient(colors: [AppColors.turquoise, AppColors.persianBlue]),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'جعبه ابزار فارسی',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'بیش از ۲۰ ابزار کاربردی',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Search Bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSearchBar(context, controller),
          ),
        ),

        // Quick Access Grid
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, 'دسترسی سریع'),
                const SizedBox(height: 12),
                _buildQuickAccessGrid(context),
              ],
            ),
          ),
        ),

        // Categories Preview
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: _buildSectionTitle(context, 'دسته‌بندی‌ها'),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildCategoriesList(context),
        ),

        // All Tools
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: _buildSectionTitle(context, 'همه ابزارها'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: _buildAllToolsGrid(context, controller),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, HomeController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: (v) => controller.searchQuery.value = v,
        decoration: InputDecoration(
          hintText: 'جستجوی ابزار...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: [
        _buildQuickAccessCard(
          context,
          title: 'ماشین حساب',
          icon: Icons.calculate_rounded,
          gradient: AppColors.orangeGradient,
          onTap: () => Get.toNamed(AppRoutes.calculator),
        ),
        _buildQuickAccessCard(
          context,
          title: 'QR Code',
          icon: Icons.qr_code_rounded,
          gradient: AppColors.blueGradient,
          onTap: () => Get.toNamed(AppRoutes.qrCode),
        ),
        _buildQuickAccessCard(
          context,
          title: 'تایمر',
          icon: Icons.timer_rounded,
          gradient: AppColors.purpleGradient,
          onTap: () => Get.toNamed(AppRoutes.timer),
        ),
        _buildQuickAccessCard(
          context,
          title: 'تبدیل واحد',
          icon: Icons.swap_horiz_rounded,
          gradient: AppColors.turquoiseGradient,
          onTap: () => Get.toNamed(AppRoutes.unitConverter),
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = [
      {'title': 'متن و زبان', 'icon': Icons.text_fields, 'color': AppColors.textToolsColor, 'route': AppRoutes.textEditor},
      {'title': 'محاسبه و تبدیل', 'icon': Icons.calculate, 'color': AppColors.calcToolsColor, 'route': AppRoutes.calculator},
      {'title': 'ابزارهای روزمره', 'icon': Icons.access_time, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.timer},
      {'title': 'سلامت', 'icon': Icons.favorite, 'color': AppColors.healthToolsColor, 'route': AppRoutes.bmiCalculator},
      {'title': 'سرگرمی', 'icon': Icons.star, 'color': AppColors.funToolsColor, 'route': AppRoutes.randomNumber},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () => Get.toNamed(cat['route'] as String),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (cat['color'] as Color).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (cat['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat['title'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllToolsGrid(BuildContext context, HomeController controller) {
    final tools = controller.allTools;

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final tool = tools[index];
          return _buildToolCard(context, tool);
        },
        childCount: tools.length,
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, Map<String, dynamic> tool) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = tool['color'] as Color;

    return GestureDetector(
      onTap: () => Get.toNamed(tool['route']),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(tool['icon'] as IconData, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              tool['title'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTab(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('دسته‌بندی‌ها'), pinned: true),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildCategoryCard(context, title: 'ابزارهای متنی', icon: Icons.text_fields, color: AppColors.textToolsColor, tools: [
                {'title': 'ویرایشگر متن', 'route': AppRoutes.textEditor},
                {'title': 'شمارش کلمات', 'route': AppRoutes.wordCounter},
              ]),
              _buildCategoryCard(context, title: 'محاسبه و تبدیل', icon: Icons.calculate, color: AppColors.calcToolsColor, tools: [
                {'title': 'ماشین حساب', 'route': AppRoutes.calculator},
                {'title': 'تبدیل واحد', 'route': AppRoutes.unitConverter},
                {'title': 'تبدیل ارز', 'route': AppRoutes.currencyConverter},
                {'title': 'کد QR', 'route': AppRoutes.qrCode},
                {'title': 'رمزعبور', 'route': AppRoutes.passwordGenerator},
              ]),
              _buildCategoryCard(context, title: 'ابزارهای روزمره', icon: Icons.access_time, color: AppColors.dailyToolsColor, tools: [
                {'title': 'کرنومتر', 'route': AppRoutes.stopwatch},
                {'title': 'تایمر', 'route': AppRoutes.timer},
                {'title': 'ساعت جهانی', 'route': AppRoutes.worldClock},
                {'title': 'چراغ قوه', 'route': AppRoutes.flashlight},
                {'title': 'قطب‌نما', 'route': AppRoutes.compass},
              ]),
              _buildCategoryCard(context, title: 'سلامت و سبک زندگی', icon: Icons.favorite, color: AppColors.healthToolsColor, tools: [
                {'title': 'BMI', 'route': AppRoutes.bmiCalculator},
                {'title': 'محاسبه سن', 'route': AppRoutes.ageCalculator},
                {'title': 'تخفیف', 'route': AppRoutes.discountCalculator},
                {'title': 'انعام', 'route': AppRoutes.tipCalculator},
              ]),
              _buildCategoryCard(context, title: 'ابزارهای سنسور', icon: Icons.sensors, color: AppColors.mint, tools: [
                {'title': 'شتاب‌سنج', 'route': AppRoutes.accelerometer},
                {'title': 'ژیروسکوپ', 'route': AppRoutes.gyroscope},
                {'title': 'فشارسنج', 'route': AppRoutes.barometer},
              ]),
              _buildCategoryCard(context, title: 'سرگرمی و خلاقیت', icon: Icons.star, color: AppColors.funToolsColor, tools: [
                {'title': 'عدد تصادفی', 'route': AppRoutes.randomNumber},
              ]),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Map<String, String>> tools,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        children: tools.map((tool) => ListTile(
          title: Text(tool['title']!),
          trailing: const Icon(Icons.chevron_left),
          onTap: () => Get.toNamed(tool['route']!),
        )).toList(),
      ),
    );
  }

  Widget _buildFavoritesTab(BuildContext context, HomeController controller) {
    if (controller.favoriteTools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded, size: 80, color: AppColors.rose.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('هنوز علاقه‌مندی اضافه نشده', style: TextStyle(fontSize: 16, color: AppColors.lightTextSecondary)),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('علاقه‌مندی‌ها'), pinned: true),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tool = controller.favoriteTools[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(tool['icon'], color: tool['color']),
                    title: Text(tool['title']),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () => Get.toNamed(tool['route']),
                  ),
                );
              },
              childCount: controller.favoriteTools.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTab(BuildContext context, HomeController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSearchBar(context, controller),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final results = controller.searchResults;
              if (results.isEmpty) {
                return Center(child: Text('ابزاری یافت نشد', style: TextStyle(color: AppColors.lightTextSecondary)));
              }
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final tool = results[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
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
    return const Center(child: Text('تنظیمات'));
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
