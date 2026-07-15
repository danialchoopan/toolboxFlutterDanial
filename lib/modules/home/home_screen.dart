import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/theme_controller.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final isTablet = width > 600 && width <= 900;

    if (isDesktop) {
      return _DesktopLayout(controller: controller);
    }
    return _MobileLayout(controller: controller);
  }
}

// ─── Desktop Layout ───
class _DesktopLayout extends StatelessWidget {
  final HomeController controller;
  const _DesktopLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border(
                left: BorderSide(color: isDark ? AppColors.darkDivider : Colors.grey[200]!),
              ),
            ),
            child: Column(
              children: [
                // Logo
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.turquoise, AppColors.persianBlue]),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.build_rounded, color: Colors.white, size: 36),
                      SizedBox(height: 12),
                      Text('جعبه ابزار فارسی', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('ابزارهای کاربردی', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Nav items
                _buildNavItem(context, Icons.home_rounded, 'خانه', 0, controller),
                _buildNavItem(context, Icons.category_rounded, 'دسته‌بندی‌ها', 1, controller),
                _buildNavItem(context, Icons.favorite_rounded, 'علاقه‌مندی‌ها', 2, controller),
                _buildNavItem(context, Icons.search_rounded, 'جستجو', 3, controller),
                const Divider(),
                _buildNavItem(context, Icons.settings_rounded, 'تنظیمات', 4, controller),
                const Spacer(),
                // Theme toggle
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() => ListTile(
                    leading: Icon(
                      Get.find<ThemeController>().isDark ? Icons.light_mode : Icons.dark_mode,
                      color: AppColors.saffron,
                    ),
                    title: Text(Get.find<ThemeController>().isDark ? 'حالت روشن' : 'حالت تاریک'),
                    onTap: () => Get.find<ThemeController>().toggleTheme(),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  )),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Obx(() => _buildDesktopBody(context, controller)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, HomeController controller) {
    final isSelected = controller.currentTab.value == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.changeTab(index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.turquoise.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? AppColors.turquoise : Colors.grey, size: 22),
              const SizedBox(width: 12),
              Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? AppColors.turquoise : null)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopBody(BuildContext context, HomeController controller) {
    switch (controller.currentTab.value) {
      case 0: return _DesktopHomeContent(controller: controller);
      case 1: return _DesktopCategoriesContent();
      case 2: return _DesktopFavoritesContent(controller: controller);
      case 3: return _DesktopSearchContent(controller: controller);
      case 4: return _DesktopSettingsContent();
      default: return _DesktopHomeContent(controller: controller);
    }
  }
}

// ─── Desktop Home Content ───
class _DesktopHomeContent extends StatelessWidget {
  final HomeController controller;
  const _DesktopHomeContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width - 260;
    final crossAxisCount = width > 1200 ? 8 : (width > 900 ? 6 : 4);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.turquoise, AppColors.persianBlue]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('جعبه ابزار فارسی', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('بیش از ۳۰ ابزار کاربردی برای بهره‌وری بیشتر', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    ],
                  ),
                ),
                Icon(Icons.build_rounded, color: Colors.white.withOpacity(0.3), size: 100),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Search
          _buildSearchBar(context, controller),
          const SizedBox(height: 32),

          // Quick Access
          const Text('دسترسی سریع', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildQuickAccessGrid(context, crossAxisCount),
          const SizedBox(height: 32),

          // All Tools
          const Text('همه ابزارها', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildAllToolsGrid(context, controller, crossAxisCount),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, HomeController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: (v) => controller.searchQuery.value = v,
        decoration: InputDecoration(
          hintText: 'جستجوی ابزار...',
          prefixIcon: const Icon(Icons.search_rounded),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context, int crossAxisCount) {
    final tools = [
      {'title': 'ماشین حساب', 'icon': Icons.calculate_rounded, 'gradient': AppColors.orangeGradient, 'route': AppRoutes.calculator},
      {'title': 'QR Code', 'icon': Icons.qr_code_rounded, 'gradient': AppColors.blueGradient, 'route': AppRoutes.qrCode},
      {'title': 'تایمر', 'icon': Icons.timer_rounded, 'gradient': AppColors.purpleGradient, 'route': AppRoutes.timer},
      {'title': 'تبدیل واحد', 'icon': Icons.swap_horiz_rounded, 'gradient': AppColors.turquoiseGradient, 'route': AppRoutes.unitConverter},
      {'title': 'پومودورو', 'icon': Icons.play_circle_rounded, 'gradient': AppColors.roseGradient, 'route': AppRoutes.pomodoro},
      {'title': 'لیست کارها', 'icon': Icons.checklist_rounded, 'gradient': AppColors.greenGradient, 'route': AppRoutes.todoList},
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return GestureDetector(
          onTap: () => Get.toNamed(tool['route'] as String),
          child: Container(
            decoration: BoxDecoration(
              gradient: tool['gradient'] as Gradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: (tool['gradient'] as LinearGradient).colors.first.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tool['icon'] as IconData, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                Text(tool['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAllToolsGrid(BuildContext context, HomeController controller, int crossAxisCount) {
    final tools = controller.allTools;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        final color = tool['color'] as Color;
        return GestureDetector(
          onTap: () => Get.toNamed(tool['route']),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(tool['icon'] as IconData, color: color, size: 28),
                ),
                const SizedBox(height: 8),
                Text(tool['title'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary), textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Desktop Categories Content ───
class _DesktopCategoriesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'ابزارهای متنی', 'icon': Icons.text_fields, 'color': AppColors.textToolsColor, 'tools': [
        {'title': 'ویرایشگر متن', 'route': AppRoutes.textEditor},
        {'title': 'شمارش کلمات', 'route': AppRoutes.wordCounter},
      ]},
      {'title': 'محاسبه و تبدیل', 'icon': Icons.calculate, 'color': AppColors.calcToolsColor, 'tools': [
        {'title': 'ماشین حساب', 'route': AppRoutes.calculator},
        {'title': 'تبدیل واحد', 'route': AppRoutes.unitConverter},
        {'title': 'تبدیل ارز', 'route': AppRoutes.currencyConverter},
        {'title': 'کد QR', 'route': AppRoutes.qrCode},
        {'title': 'رمزعبور', 'route': AppRoutes.passwordGenerator},
      ]},
      {'title': 'ابزارهای روزمره', 'icon': Icons.access_time, 'color': AppColors.dailyToolsColor, 'tools': [
        {'title': 'کرنومتر', 'route': AppRoutes.stopwatch},
        {'title': 'تایمر', 'route': AppRoutes.timer},
        {'title': 'ساعت جهانی', 'route': AppRoutes.worldClock},
        {'title': 'چراغ قوه', 'route': AppRoutes.flashlight},
        {'title': 'قطب‌نما', 'route': AppRoutes.compass},
      ]},
      {'title': 'سلامت', 'icon': Icons.favorite, 'color': AppColors.healthToolsColor, 'tools': [
        {'title': 'BMI', 'route': AppRoutes.bmiCalculator},
        {'title': 'محاسبه سن', 'route': AppRoutes.ageCalculator},
        {'title': 'تخفیف', 'route': AppRoutes.discountCalculator},
        {'title': 'انعام', 'route': AppRoutes.tipCalculator},
      ]},
      {'title': 'ابزارهای سنسور', 'icon': Icons.sensors, 'color': AppColors.mint, 'tools': [
        {'title': 'شتاب‌سنج', 'route': AppRoutes.accelerometer},
        {'title': 'ژیروسکوپ', 'route': AppRoutes.gyroscope},
        {'title': 'فشارسنج', 'route': AppRoutes.barometer},
      ]},
      {'title': 'بهره‌وری', 'icon': Icons.trending_up, 'color': AppColors.persianBlue, 'tools': [
        {'title': 'پومودورو', 'route': AppRoutes.pomodoro},
        {'title': 'لیست کارها', 'route': AppRoutes.todoList},
        {'title': 'یادداشت‌ها', 'route': AppRoutes.notes},
        {'title': 'ردیاب عادت', 'route': AppRoutes.habitTracker},
        {'title': 'برنامه روزانه', 'route': AppRoutes.dailyPlanner},
        {'title': 'نویز سفید', 'route': AppRoutes.whiteNoise},
        {'title': 'تایمر جلسه', 'route': AppRoutes.meetingTimer},
        {'title': 'تایمر ارائه', 'route': AppRoutes.presentationTimer},
        {'title': 'نقشه ذهنی', 'route': AppRoutes.mindMap},
      ]},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: categories.map((cat) {
          final color = cat['color'] as Color;
          return Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(cat['icon'] as IconData, color: color),
                    ),
                    const SizedBox(width: 12),
                    Text(cat['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (cat['tools'] as List).map((tool) => ActionChip(
                    label: Text(tool['title']),
                    onPressed: () => Get.toNamed(tool['route']),
                  )).toList(),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Desktop Favorites Content ───
class _DesktopFavoritesContent extends StatelessWidget {
  final HomeController controller;
  const _DesktopFavoritesContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: controller.favoriteTools.isEmpty
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.favorite_border_rounded, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text('هنوز علاقه‌مندی اضافه نشده', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
            ])
          : GridView.builder(
              padding: const EdgeInsets.all(32),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1),
              itemCount: controller.favoriteTools.length,
              itemBuilder: (context, index) {
                final tool = controller.favoriteTools[index];
                return Card(
                  child: InkWell(
                    onTap: () => Get.toNamed(tool['route']),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(tool['icon'], color: tool['color'], size: 32),
                      const SizedBox(height: 8),
                      Text(tool['title'], style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}

// ─── Desktop Search Content ───
class _DesktopSearchContent extends StatelessWidget {
  final HomeController controller;
  const _DesktopSearchContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: TextField(
              controller: controller.searchController,
              onChanged: (v) => controller.searchQuery.value = v,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'جستجوی ابزار...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(() {
              final results = controller.searchResults;
              if (results.isEmpty) return Center(child: Text('ابزاری یافت نشد', style: TextStyle(fontSize: 18, color: Colors.grey[500])));
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final tool = results[index];
                  return Card(
                    child: InkWell(
                      onTap: () => Get.toNamed(tool['route']),
                      borderRadius: BorderRadius.circular(12),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(tool['icon'], color: tool['color'], size: 32),
                        const SizedBox(height: 8),
                        Text(tool['title'], style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
                      ]),
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
}

// ─── Desktop Settings Content ───
class _DesktopSettingsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تنظیمات', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Card(
              child: Obx(() => SwitchListTile(
                title: const Text('حالت تاریک'),
                subtitle: Text(Get.find<ThemeController>().isDark ? 'فعال' : 'غیرفعال'),
                value: Get.find<ThemeController>().isDark,
                onChanged: (_) => Get.find<ThemeController>().toggleTheme(),
                secondary: Icon(Get.find<ThemeController>().isDark ? Icons.dark_mode : Icons.light_mode, color: AppColors.turquoise),
              )),
            ),
            const SizedBox(height: 12),
            Card(child: ListTile(leading: const Icon(Icons.language, color: AppColors.persianBlue), title: const Text('زبان برنامه'), subtitle: const Text('فارسی'))),
            const SizedBox(height: 12),
            Card(child: ListTile(leading: const Icon(Icons.info_outline, color: AppColors.turquoise), title: const Text('نسخه برنامه'), subtitle: const Text('۱.۰.۰'))),
          ],
        ),
      ),
    );
  }
}

// ─── Mobile Layout ───
class _MobileLayout extends StatelessWidget {
  final HomeController controller;
  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffold : AppColors.lightScaffold,
      body: SafeArea(child: Obx(() => _buildMobileBody(context, controller))),
      bottomNavigationBar: Obx(() => NavigationBar(
        selectedIndex: controller.currentTab.value,
        onDestinationSelected: controller.changeTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'خانه'),
          NavigationDestination(icon: Icon(Icons.category_rounded), label: 'دسته‌بندی'),
          NavigationDestination(icon: Icon(Icons.favorite_rounded), label: 'علاقه‌مندی'),
          NavigationDestination(icon: Icon(Icons.search_rounded), label: 'جستجو'),
          NavigationDestination(icon: Icon(Icons.settings_rounded), label: 'تنظیمات'),
        ],
      )),
    );
  }

  Widget _buildMobileBody(BuildContext context, HomeController controller) {
    switch (controller.currentTab.value) {
      case 0: return _MobileHomeTab(context, controller);
      case 1: return _MobileCategoriesTab(context);
      case 2: return _MobileFavoritesTab(context, controller);
      case 3: return _MobileSearchTab(context, controller);
      case 4: return _MobileSettingsTab(context);
      default: return _MobileHomeTab(context, controller);
    }
  }

  Widget _MobileHomeTab(BuildContext context, HomeController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tools = controller.allTools;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 140,
          floating: true,
          pinned: true,
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.turquoise,
          actions: [
            IconButton(
              icon: Icon(Get.find<ThemeController>().isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
              onPressed: () => Get.find<ThemeController>().toggleTheme(),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.turquoise, AppColors.persianBlue])),
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text('جعبه ابزار فارسی', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('بیش از ۳۰ ابزار کاربردی', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ]),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: controller.searchController,
              onChanged: (v) => controller.searchQuery.value = v,
              decoration: InputDecoration(
                hintText: 'جستجو...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: _buildMobileQuickAccess(context),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: const Text('همه ابزارها', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tool = tools[index];
                final color = tool['color'] as Color;
                return GestureDetector(
                  onTap: () => Get.toNamed(tool['route']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3))],
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(tool['icon'] as IconData, color: color, size: 22),
                      ),
                      const SizedBox(height: 6),
                      Text(tool['title'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ]),
                  ),
                );
              },
              childCount: tools.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildMobileQuickAccess(BuildContext context) {
    return Row(
      children: [
        _buildQuickItem('ماشین حساب', Icons.calculate_rounded, AppColors.orangeGradient, AppRoutes.calculator),
        const SizedBox(width: 8),
        _buildQuickItem('QR Code', Icons.qr_code_rounded, AppColors.blueGradient, AppRoutes.qrCode),
        const SizedBox(width: 8),
        _buildQuickItem('تایمر', Icons.timer_rounded, AppColors.purpleGradient, AppRoutes.timer),
        const SizedBox(width: 8),
        _buildQuickItem('تبدیل', Icons.swap_horiz_rounded, AppColors.turquoiseGradient, AppRoutes.unitConverter),
      ],
    );
  }

  Widget _buildQuickItem(String title, IconData icon, Gradient gradient, String route) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Get.toNamed(route),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
          ]),
        ),
      ),
    );
  }

  Widget _MobileCategoriesTab(BuildContext context) {
    final categories = [
      {'title': 'ابزارهای متنی', 'icon': Icons.text_fields, 'color': AppColors.textToolsColor, 'route': AppRoutes.textEditor},
      {'title': 'محاسبه و تبدیل', 'icon': Icons.calculate, 'color': AppColors.calcToolsColor, 'route': AppRoutes.calculator},
      {'title': 'ابزارهای روزمره', 'icon': Icons.access_time, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.timer},
      {'title': 'سلامت', 'icon': Icons.favorite, 'color': AppColors.healthToolsColor, 'route': AppRoutes.bmiCalculator},
      {'title': 'ابزارهای سنسور', 'icon': Icons.sensors, 'color': AppColors.mint, 'route': AppRoutes.accelerometer},
      {'title': 'بهره‌وری', 'icon': Icons.trending_up, 'color': AppColors.persianBlue, 'route': AppRoutes.pomodoro},
      {'title': 'سرگرمی', 'icon': Icons.star, 'color': AppColors.funToolsColor, 'route': AppRoutes.randomNumber},
    ];

    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('دسته‌بندی‌ها'), pinned: true),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.2),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final cat = categories[index];
                final color = cat['color'] as Color;
                return GestureDetector(
                  onTap: () => Get.toNamed(cat['route'] as String),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(cat['icon'] as IconData, color: color, size: 32),
                      const SizedBox(height: 8),
                      Text(cat['title'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                    ]),
                  ),
                );
              },
              childCount: categories.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _MobileFavoritesTab(BuildContext context, HomeController controller) {
    if (controller.favoriteTools.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.favorite_border_rounded, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text('هنوز علاقه‌مندی اضافه نشده', style: TextStyle(color: Colors.grey[500])),
      ]));
    }
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('علاقه‌مندی‌ها'), pinned: true),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tool = controller.favoriteTools[index];
                return GestureDetector(
                  onTap: () => Get.toNamed(tool['route']),
                  child: Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(tool['icon'], color: tool['color'], size: 28),
                    const SizedBox(height: 8),
                    Text(tool['title'], style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
                  ])),
                );
              },
              childCount: controller.favoriteTools.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _MobileSearchTab(BuildContext context, HomeController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: controller.searchController,
            onChanged: (v) => controller.searchQuery.value = v,
            autofocus: true,
            decoration: InputDecoration(hintText: 'جستجو...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final results = controller.searchResults;
              if (results.isEmpty) return Center(child: Text('ابزاری یافت نشد'));
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final tool = results[index];
                  return GestureDetector(
                    onTap: () => Get.toNamed(tool['route']),
                    child: Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(tool['icon'], color: tool['color'], size: 28),
                      const SizedBox(height: 8),
                      Text(tool['title'], style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
                    ])),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _MobileSettingsTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('تنظیمات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Card(
          child: Obx(() => SwitchListTile(
            title: const Text('حالت تاریک'),
            subtitle: Text(Get.find<ThemeController>().isDark ? 'فعال' : 'غیرفعال'),
            value: Get.find<ThemeController>().isDark,
            onChanged: (_) => Get.find<ThemeController>().toggleTheme(),
            secondary: Icon(Get.find<ThemeController>().isDark ? Icons.dark_mode : Icons.light_mode, color: AppColors.turquoise),
          )),
        ),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const Icon(Icons.language, color: AppColors.persianBlue), title: const Text('زبان برنامه'), subtitle: const Text('فارسی'))),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const Icon(Icons.info_outline, color: AppColors.turquoise), title: const Text('نسخه برنامه'), subtitle: const Text('۱.۰.۰'))),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const Icon(Icons.code, color: AppColors.dailyToolsColor), title: const Text('ساخته شده با Flutter'))),
      ],
    );
  }
}
