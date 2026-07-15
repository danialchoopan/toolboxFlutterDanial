/// Utility class for converting between English and Persian (Farsi) numerals.
///
/// Persian numerals (۰-۹) are used throughout the app for authentic RTL display.
/// This class handles:
/// - Character-by-character conversion
/// - Number formatting with thousand separators
/// - Currency formatting with Iranian units (Toman/Rial)
///
/// Example usage:
/// ```dart
/// PersianNumbers.toPersian('123')      // '۱۲۳'
/// PersianNumbers.formatWithCommas('1234567') // '۱,۲۳۴,۵۶۷'
/// PersianNumbers.formatCurrency(58000) // '۵۸,۰۰۰ تومان'
/// ```
class PersianNumbers {
  PersianNumbers._(); // Private constructor - utility class

  // ─── Character Maps ───

  /// English digits to Persian digits mapping
  static const Map<String, String> _englishToPersian = {
    '0': '۰', '1': '۱', '2': '۲', '3': '۳', '4': '۴',
    '5': '۵', '6': '۶', '7': '۷', '8': '۸', '9': '۹',
  };

  /// Persian digits to English digits mapping (reverse lookup)
  static const Map<String, String> _persianToEnglish = {
    '۰': '0', '۱': '1', '۲': '2', '۳': '3', '۴': '4',
    '۵': '5', '۶': '6', '۷': '7', '۸': '8', '۹': '9',
  };

  // ─── Conversion Methods ───

  /// Convert a string containing English digits to Persian digits.
  /// Non-digit characters are preserved as-is.
  static String toPersian(String input) {
    var result = input;
    for (final entry in _englishToPersian.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  /// Convert a string containing Persian digits to English digits.
  /// Useful for parsing user input before calculations.
  static String toEnglish(String input) {
    var result = input;
    for (final entry in _persianToEnglish.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  /// Convert any numeric type to Persian digit string.
  static String toPersianNumber(dynamic number) {
    return toPersian(number.toString());
  }

  // ─── Formatting Methods ───

  /// Format a number string with thousand separators in Persian.
  ///
  /// Example: '1234567' → '۱,۲۳۴,۵۶۷'
  /// Preserves decimal part if present.
  static String formatWithCommas(String number) {
    final english = toEnglish(number);
    final parts = english.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';

    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      // Insert comma every 3 digits from the right
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(_englishToPersian[intPart[i]]);
    }
    return buffer.toString() + decPart;
  }

  /// Format a currency amount with Persian digits and unit.
  ///
  /// [isToman] determines the currency unit:
  /// - true: تومان (default, 1 Toman = 10 Rial)
  /// - false: ریال
  ///
  /// Example: formatCurrency(58000) → '۵۸,۰۰۰ تومان'
  static String formatCurrency(double amount, {bool isToman = true}) {
    final formatted = formatWithCommas(amount.toStringAsFixed(0));
    final unit = isToman ? 'تومان' : 'ریال';
    return '$formatted $unit';
  }
}
