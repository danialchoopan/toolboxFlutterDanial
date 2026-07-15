class PersianNumbers {
  PersianNumbers._();

  static const Map<String, String> _englishToPersian = {
    '0': '۰',
    '1': '۱',
    '2': '۲',
    '3': '۳',
    '4': '۴',
    '5': '۵',
    '6': '۶',
    '7': '۷',
    '8': '۸',
    '9': '۹',
  };

  static const Map<String, String> _persianToEnglish = {
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
  };

  static String toPersian(String input) {
    var result = input;
    for (final entry in _englishToPersian.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  static String toEnglish(String input) {
    var result = input;
    for (final entry in _persianToEnglish.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  static String toPersianNumber(dynamic number) {
    return toPersian(number.toString());
  }

  static String formatWithCommas(String number) {
    final english = toEnglish(number);
    final parts = english.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';

    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(_englishToPersian[intPart[i]]);
    }
    return buffer.toString() + decPart;
  }

  static String formatCurrency(double amount, {bool isToman = true}) {
    final formatted = formatWithCommas(amount.toStringAsFixed(0));
    final unit = isToman ? 'تومان' : 'ریال';
    return '$formatted $unit';
  }
}
