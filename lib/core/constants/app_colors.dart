import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Persian Art Inspired Palette
  static const Color turquoise = Color(0xFF00BFA6);
  static const Color persianBlue = Color(0xFF2979FF);
  static const Color rose = Color(0xFFFF1744);
  static const Color saffron = Color(0xFFFFD600);
  static const Color lapis = Color(0xFF304FFE);
  static const Color mint = Color(0xFF00E676);
  static const Color coral = Color(0xFFFF6E40);
  static const Color lavender = Color(0xFFE040FB);
  static const Color sky = Color(0xFF00B0FF);
  static const Color peach = Color(0xFFFFAB91);

  // Gradient Presets
  static const LinearGradient turquoiseGradient = LinearGradient(
    colors: [Color(0xFF00BFA6), Color(0xFF00897B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient roseGradient = LinearGradient(
    colors: [Color(0xFFFF1744), Color(0xFFD50000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFE040FB), Color(0xFFAA00FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF6E40), Color(0xFFFF3D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00C853)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFF4ECDC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Theme
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF6C757D);
  static const Color lightDivider = Color(0xFFE9ECEF);
  static const Color lightScaffold = Color(0xFFF5F6FA);

  // Dark Theme
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCard = Color(0xFF21262D);
  static const Color darkTextPrimary = Color(0xFFF0F6FC);
  static const Color darkTextSecondary = Color(0xFF8B949E);
  static const Color darkDivider = Color(0xFF30363D);
  static const Color darkScaffold = Color(0xFF0D1117);

  // Category Colors
  static const Color textToolsColor = Color(0xFF58A6FF);
  static const Color fileToolsColor = Color(0xFF3FB950);
  static const Color calcToolsColor = Color(0xFFF0883E);
  static const Color dailyToolsColor = Color(0xFFBC8CFF);
  static const Color healthToolsColor = Color(0xFFF85149);
  static const Color funToolsColor = Color(0xFF39D2C0);

  // Glassmorphism
  static Color glassWhite = Colors.white.withOpacity(0.15);
  static Color glassDark = Colors.black.withOpacity(0.25);
}
