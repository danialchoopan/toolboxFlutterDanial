import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_routes.dart';
import '../../core/services/storage_service.dart';

class HomeController extends GetxController {
  final currentTab = 0.obs;
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  final allTools = <Map<String, dynamic>>[].obs;
  final favoriteTools = <Map<String, dynamic>>[].obs;
  final searchResults = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initTools();
    _loadFavorites();
    ever(searchQuery, (_) => _filterTools());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  void _initTools() {
    allTools.value = [
      // Calculator & Conversion
      {'title': 'ماشین حساب', 'icon': Icons.calculate, 'color': AppColors.calcToolsColor, 'route': AppRoutes.calculator, 'category': 'calc'},
      {'title': 'تبدیل واحد', 'icon': Icons.straighten, 'color': AppColors.calcToolsColor, 'route': AppRoutes.unitConverter, 'category': 'calc'},
      {'title': 'تبدیل ارز', 'icon': Icons.currency_exchange, 'color': AppColors.calcToolsColor, 'route': AppRoutes.currencyConverter, 'category': 'calc'},
      {'title': 'کد QR', 'icon': Icons.qr_code, 'color': AppColors.persianBlue, 'route': AppRoutes.qrCode, 'category': 'calc'},
      {'title': 'رمزعبور', 'icon': Icons.password, 'color': AppColors.rose, 'route': AppRoutes.passwordGenerator, 'category': 'calc'},

      // Text Tools
      {'title': 'ویرایشگر متن', 'icon': Icons.edit_note, 'color': AppColors.textToolsColor, 'route': AppRoutes.textEditor, 'category': 'text'},
      {'title': 'شمارش کلمات', 'icon': Icons.format_list_numbered, 'color': AppColors.textToolsColor, 'route': AppRoutes.wordCounter, 'category': 'text'},

      // Daily Tools
      {'title': 'انتخاب رنگ', 'icon': Icons.color_lens, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.colorPicker, 'category': 'daily'},
      {'title': 'کرنومتر', 'icon': Icons.timer, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.stopwatch, 'category': 'daily'},
      {'title': 'تایمر', 'icon': Icons.hourglass_top, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.timer, 'category': 'daily'},
      {'title': 'ساعت جهانی', 'icon': Icons.language, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.worldClock, 'category': 'daily'},
      {'title': 'چراغ قوه', 'icon': Icons.flashlight_on, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.flashlight, 'category': 'daily'},
      {'title': 'قطب‌نما', 'icon': Icons.explore, 'color': AppColors.dailyToolsColor, 'route': AppRoutes.compass, 'category': 'daily'},

      // Health Tools
      {'title': 'BMI', 'icon': Icons.monitor_weight, 'color': AppColors.healthToolsColor, 'route': AppRoutes.bmiCalculator, 'category': 'health'},
      {'title': 'محاسبه سن', 'icon': Icons.cake, 'color': AppColors.healthToolsColor, 'route': AppRoutes.ageCalculator, 'category': 'health'},
      {'title': 'تخفیف', 'icon': Icons.discount, 'color': AppColors.healthToolsColor, 'route': AppRoutes.discountCalculator, 'category': 'health'},
      {'title': 'انعام', 'icon': Icons.receipt_long, 'color': AppColors.healthToolsColor, 'route': AppRoutes.tipCalculator, 'category': 'health'},

      // Fun Tools
      {'title': 'عدد تصادفی', 'icon': Icons.casino, 'color': AppColors.funToolsColor, 'route': AppRoutes.randomNumber, 'category': 'fun'},
    ];
  }

  void _loadFavorites() {
    final favIds = StorageService().getFavorites();
    favoriteTools.value = allTools.where((t) => favIds.contains(t['route'])).toList();
  }

  void toggleFavorite(Map<String, dynamic> tool) {
    final route = tool['route'] as String;
    if (StorageService().isFavorite(route)) {
      StorageService().removeFavorite(route);
    } else {
      StorageService().addFavorite(route);
    }
    _loadFavorites();
  }

  void _filterTools() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      searchResults.value = allTools;
    } else {
      searchResults.value = allTools.where((tool) {
        final title = (tool['title'] as String).toLowerCase();
        return title.contains(query);
      }).toList();
    }
  }
}
