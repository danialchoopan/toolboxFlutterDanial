import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_routes.dart';
import '../../core/services/storage_service.dart';

/// Main controller for the home screen and navigation.
///
/// Manages:
/// - Bottom navigation state (5 tabs: Home, Categories, Favorites, Search, Settings)
/// - Complete tool registry (55+ tools across 12 categories)
/// - Search functionality with real-time filtering
/// - Favorites/bookmarks persistence via Hive storage
///
/// Uses GetX reactive state management for automatic UI updates.
class HomeController extends GetxController {
  // ─── Navigation State ───
  final currentTab = 0.obs;                    // Active bottom nav tab
  final searchQuery = ''.obs;                   // Current search query
  final selectedCategory = 'all'.obs;           // Active category filter
  final searchController = TextEditingController(); // Search input controller

  // ─── Tool Registry ───
  final allTools = <Map<String, dynamic>>[].obs;      // All available tools
  final favoriteTools = <Map<String, dynamic>>[].obs;  // User's bookmarked tools
  final searchResults = <Map<String, dynamic>>[].obs;   // Filtered search results
  final filteredTools = <Map<String, dynamic>>[].obs;   // Category-filtered tools

  @override
  void onInit() {
    super.onInit();
    _initTools();           // Populate tool registry
    _loadFavorites();       // Load saved favorites from Hive
    ever(searchQuery, (_) => _filterTools()); // React to search changes
    ever(selectedCategory, (_) => _filterTools()); // React to category changes
    _filterTools(); // Initial filter
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Switch between bottom navigation tabs
  void changeTab(int index) {
    currentTab.value = index;
  }

  /// Initialize the complete tool registry.
  ///
  /// Each tool entry contains:
  /// - 'title': Persian display name
  /// - 'icon': Material icon for the tool
  /// - 'color': Accent color for the tool category
  /// - 'route': GetX route path for navigation
  /// - 'category': Category key for filtering
  void _initTools() {
    allTools.value = [
      // ─── Calculator & Conversion Tools ───
      {'title': 'ماشین حساب', 'icon': Icons.calculate, 'color': AppColors.calcToolsColor, 'route': AppRoutes.calculator, 'category': 'calc'},
      {'title': 'تبدیل واحد', 'icon': Icons.straighten, 'color': AppColors.calcToolsColor, 'route': AppRoutes.unitConverter, 'category': 'calc'},
      {'title': 'تبدیل ارز', 'icon': Icons.currency_exchange, 'color': AppColors.calcToolsColor, 'route': AppRoutes.currencyConverter, 'category': 'calc'},
      {'title': 'کد QR', 'icon': Icons.qr_code, 'color': AppColors.persianBlue, 'route': AppRoutes.qrCode, 'category': 'calc'},
      {'title': 'رمزعبور', 'icon': Icons.password, 'color': AppColors.rose, 'route': AppRoutes.passwordGenerator, 'category': 'calc'},

      // ─── Text Tools ───
      {'title': 'ویرایشگر متن', 'icon': Icons.edit_note, 'color': AppColors.textToolsColor, 'route': AppRoutes.textEditor, 'category': 'text'},
      {'title': 'شمارش کلمات', 'icon': Icons.format_list_numbered, 'color': AppColors.textToolsColor, 'route': AppRoutes.wordCounter, 'category': 'text'},

      // ─── Daily Utility Tools ───
      {'title': 'انتخاب رنگ', 'icon': Icons.color_lens, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.colorPicker, 'category': 'daily'},
      {'title': 'کرنومتر', 'icon': Icons.timer, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.stopwatch, 'category': 'daily'},
      {'title': 'تایمر', 'icon': Icons.hourglass_top, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.timer, 'category': 'daily'},
      {'title': 'ساعت جهانی', 'icon': Icons.language, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.worldClock, 'category': 'daily'},
      {'title': 'ساعت جهانی+', 'icon': Icons.access_time_filled, 'color': AppColors.sky, 'route': AppRoutes.enhancedWorldClock, 'category': 'daily'},
      {'title': 'چراغ قوه', 'icon': Icons.flashlight_on, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.flashlight, 'category': 'daily'},
      {'title': 'قطب‌نما', 'icon': Icons.explore, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.compass, 'category': 'daily'},

      // ─── Health Tools ───
      {'title': 'BMI', 'icon': Icons.monitor_weight, 'color': AppColors.healthToolsColor, 'route': AppRoutes.bmiCalculator, 'category': 'health'},
      {'title': 'محاسبه سن', 'icon': Icons.cake, 'color': AppColors.healthToolsColor, 'route': AppRoutes.ageCalculator, 'category': 'health'},
      {'title': 'تخفیف', 'icon': Icons.discount, 'color': AppColors.healthToolsColor, 'route': AppRoutes.discountCalculator, 'category': 'health'},
      {'title': 'انعام', 'icon': Icons.receipt_long, 'color': AppColors.healthToolsColor, 'route': AppRoutes.tipCalculator, 'category': 'health'},

      // ─── Sensor Tools ───
      {'title': 'شتاب‌سنج', 'icon': Icons.speed, 'color': AppColors.mint, 'route': AppRoutes.accelerometer, 'category': 'sensor'},
      {'title': 'ژیروسکوپ', 'icon': Icons.screen_rotation, 'color': AppColors.sky, 'route': AppRoutes.gyroscope, 'category': 'sensor'},
      {'title': 'فشارسنج', 'icon': Icons.thermostat, 'color': AppColors.coral, 'route': AppRoutes.barometer, 'category': 'sensor'},

      // ─── Productivity Tools ───
      {'title': 'پومودورو', 'icon': Icons.play_circle, 'color': AppColors.rose, 'route': AppRoutes.pomodoro, 'category': 'productivity'},
      {'title': 'لیست کارها', 'icon': Icons.checklist, 'color': AppColors.turquoise, 'route': AppRoutes.todoList, 'category': 'productivity'},
      {'title': 'یادداشت‌ها', 'icon': Icons.note, 'color': AppColors.saffron, 'route': AppRoutes.notes, 'category': 'productivity'},
      {'title': 'ردیاب عادت', 'icon': Icons.repeat, 'color': AppColors.mint, 'route': AppRoutes.habitTracker, 'category': 'productivity'},
      {'title': 'برنامه روزانه', 'icon': Icons.calendar_today, 'color': AppColors.persianBlue, 'route': AppRoutes.dailyPlanner, 'category': 'productivity'},
      {'title': 'نقشه ذهنی', 'icon': Icons.device_hub, 'color': AppColors.lavender, 'route': AppRoutes.mindMap, 'category': 'productivity'},

      // ─── Creative Tools ───
      {'title': 'تخته نقاشی', 'icon': Icons.brush, 'color': AppColors.coral, 'route': AppRoutes.drawingBoard, 'category': 'creative'},
      {'title': 'پالت رنگ', 'icon': Icons.palette, 'color': AppColors.lavender, 'route': AppRoutes.colorPalette, 'category': 'creative'},

      // ─── Timer Variants ───
      {'title': 'تایمر HIIT', 'icon': Icons.fitness_center, 'color': AppColors.rose, 'route': AppRoutes.hiitTimer, 'category': 'timer'},
      {'title': 'تایمر تخم‌مرغ', 'icon': Icons.egg, 'color': AppColors.saffron, 'route': AppRoutes.eggTimer, 'category': 'timer'},
      {'title': 'تایمر خواب', 'icon': Icons.bedtime, 'color': AppColors.lapis, 'route': AppRoutes.sleepTimer, 'category': 'timer'},
      {'title': 'نویز سفید', 'icon': Icons.graphic_eq, 'color': AppColors.lavender, 'route': AppRoutes.whiteNoise, 'category': 'timer'},
      {'title': 'تایمر جلسه', 'icon': Icons.groups, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.meetingTimer, 'category': 'timer'},
      {'title': 'تایمر ارائه', 'icon': Icons.slideshow, 'color': AppColors.coral, 'route': AppRoutes.presentationTimer, 'category': 'timer'},

      // ─── Fun & Games ───
      {'title': 'تولیدکننده تصادفی', 'icon': Icons.casino, 'color': AppColors.funToolsColor, 'route': AppRoutes.randomGenerator, 'category': 'fun'},
      {'title': 'بازی‌های کوچک', 'icon': Icons.games, 'color': AppColors.turquoise, 'route': AppRoutes.miniGames, 'category': 'fun'},

      // ─── Network Tools ───
      {'title': 'ابزارهای شبکه', 'icon': Icons.wifi, 'color': AppColors.persianBlue, 'route': AppRoutes.networkTools, 'category': 'network'},

      // ─── Developer Tools ───
      {'title': 'ابزارهای توسعه', 'icon': Icons.code, 'color': AppColors.mint, 'route': AppRoutes.devTools, 'category': 'dev'},

      // ─── Health & Fitness ───
      {'title': 'سلامت و تناسب', 'icon': Icons.favorite, 'color': AppColors.rose, 'route': AppRoutes.healthDashboard, 'category': 'health'},
    ];
  }

  /// Load favorite tools from Hive storage.
  /// Matches stored route paths against the tool registry.
  void _loadFavorites() {
    final favIds = StorageService().getFavorites();
    favoriteTools.value = allTools.where((t) => favIds.contains(t['route'])).toList();
  }

  /// Toggle a tool's favorite status (add/remove from bookmarks).
  void toggleFavorite(Map<String, dynamic> tool) {
    final route = tool['route'] as String;
    if (StorageService().isFavorite(route)) {
      StorageService().removeFavorite(route);
    } else {
      StorageService().addFavorite(route);
    }
    _loadFavorites(); // Refresh the favorites list
  }

  /// Filter tools based on search query AND category.
  /// Uses case-insensitive Persian text matching.
  void _filterTools() {
    final query = searchQuery.value.toLowerCase();
    final category = selectedCategory.value;

    // Start with all tools
    var result = allTools.toList();

    // Apply category filter
    if (category != 'all') {
      result = result.where((tool) => tool['category'] == category).toList();
    }

    // Apply search filter
    if (query.isNotEmpty) {
      result = result.where((tool) {
        final title = (tool['title'] as String).toLowerCase();
        return title.contains(query);
      }).toList();
    }

    searchResults.value = result;
    filteredTools.value = result;
  }
}
