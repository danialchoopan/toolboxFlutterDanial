import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/localization/app_translations.dart';
import 'core/services/storage_service.dart';
import 'core/router/app_routes.dart';

/// Entry point of the application.
/// Initializes services, locks orientation, and launches the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage for favorites, settings, and history
  await StorageService().init();

  // Lock orientation to portrait mode for consistent mobile UX
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make status bar transparent for edge-to-edge design
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const ToolboxApp());
}

/// Root widget of the جعبه ابزار دانیال (Danial's Toolbox) application.
///
/// Uses GetX for state management, routing, and internationalization.
/// Default locale is Persian (Farsi) with English as fallback.
class ToolboxApp extends StatelessWidget {
  const ToolboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Register theme controller globally via GetX dependency injection
    final themeController = Get.put(ThemeController());

    return GetMaterialApp(
      title: 'جعبه ابزار دانیال',
      debugShowCheckedModeBanner: false,

      // Theme system: light and dark themes with Persian art color palette
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeController.themeMode,

      // Persian translations with English fallback
      translations: AppTranslations(),
      locale: const Locale('fa', 'IR'),
      fallbackLocale: const Locale('en', 'US'),

      // Navigation: GetX named routes starting from home screen
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
    );
  }
}
