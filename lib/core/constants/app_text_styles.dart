import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Vazirmatn';

  static TextStyle _baseStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double height = 1.5,
  }) {
    return GoogleFonts.vazirmatn(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle h1({Color? color}) =>
      _baseStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color);

  static TextStyle h2({Color? color}) =>
      _baseStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color);

  static TextStyle h3({Color? color}) =>
      _baseStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color);

  static TextStyle h4({Color? color}) =>
      _baseStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color);

  static TextStyle bodyLarge({Color? color}) =>
      _baseStyle(fontSize: 16, fontWeight: FontWeight.normal, color: color);

  static TextStyle body({Color? color}) =>
      _baseStyle(fontSize: 14, fontWeight: FontWeight.normal, color: color);

  static TextStyle bodySmall({Color? color}) =>
      _baseStyle(fontSize: 12, fontWeight: FontWeight.normal, color: color);

  static TextStyle caption({Color? color}) =>
      _baseStyle(fontSize: 10, fontWeight: FontWeight.normal, color: color);

  static TextStyle button({Color? color}) =>
      _baseStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color);

  static TextStyle label({Color? color}) =>
      _baseStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color);

  static TextStyle title({Color? color}) =>
      _baseStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color);

  static TextStyle subtitle({Color? color}) =>
      _baseStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color);
}
