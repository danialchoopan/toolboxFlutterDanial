import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find<ThemeController>();

  final _isDark = false.obs;
  bool get isDark => _isDark.value;
  ThemeMode get themeMode => _isDark.value ? ThemeMode.dark : ThemeMode.light;

  static const String _themeKey = 'is_dark_theme';

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark.value = prefs.getBool(_themeKey) ?? false;
  }

  Future<void> toggleTheme() async {
    _isDark.value = !_isDark.value;
    Get.changeThemeMode(themeMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDark.value);
  }
}
