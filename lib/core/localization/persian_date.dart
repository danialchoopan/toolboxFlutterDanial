class PersianDate {
  PersianDate._();

  static const List<String> monthNames = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  static const List<String> weekdayNames = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه‌شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه',
  ];

  static const List<int> monthDays = [
    31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29,
  ];

  static const List<String> monthDaysName = [
    'یکم',
    'دوم',
    'سوم',
    'چهارم',
    'پنجم',
    'ششم',
    'هفتم',
    'هشتم',
    'نهم',
    'دهم',
    'یازدهم',
    'دوازدهم',
    'سیزدهم',
    'چهاردهم',
    'پانزدهم',
    'شانزدهم',
    'هفدهم',
    'هجدهم',
    'نوزدهم',
    'بیستم',
    'بیست و یکم',
    'بیست و دوم',
    'بیست و سوم',
    'بیست و چهارم',
    'بیست و پنجم',
    'بیست و ششم',
    'بیست و هفتم',
    'بیست و هشتم',
    'بیست و نهم',
    'سی ام',
    'سی و یکم',
  ];

  /// Convert Gregorian to Jalali
  static List<int> gregorianToJalali(int year, int month, int day) {
    final gy = year;
    final gm = month;
    final gd = day;

    final g_d_m = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    var gy2 = (gm > 2) ? (gy + 1) : gy;
    var days =
        355666 + (365 * gy) + ((gy2 + 3) ~/ 4) - ((gy2 + 99) ~/ 100) +
        ((gy2 + 399) ~/ 400) + gd + g_d_m[gm - 1];
    var jy = -1595 + (33 * (days ~/ 12053));
    days %= 12053;
    jy += 4 * (days ~/ 1461);
    days %= 1461;
    if (days > 365) {
      jy += ((days - 1) ~/ 365);
      days = (days - 1) % 365;
    }
    int jm, jd;
    if (days < 186) {
      jm = 1 + (days ~/ 31);
      jd = 1 + (days % 31);
    } else {
      jm = 7 + ((days - 186) ~/ 30);
      jd = 1 + ((days - 186) % 30);
    }
    return [jy, jm, jd];
  }

  /// Convert Jalali to Gregorian
  static List<int> jalaliToGregorian(int jy, int jm, int jd) {
    final jy1 = jy - 979;
    final jm1 = jm - 1;
    final jd1 = jd - 1;

    final jDayNo =
        (365 * jy1) + ((jy1 + 3) ~/ 4) - ((jy1 + 99) ~/ 100) +
        ((jy1 + 399) ~/ 400) + (31 * jm1) + (jm1 < 7 ? (30 * jm1) : ((30 * jm1) + 6)) + jd1;

    final gDayNo = jDayNo + 79;

    var gy = 1600 + (400 * (gDayNo ~/ 146097));
    var remaining = gDayNo % 146097;

    if (remaining >= 36524) {
      gy += 100 * ((remaining - 1) ~/ 36524);
      remaining = (remaining - 1) % 36524;
      if (remaining >= 365) {
        remaining++;
      }
    }

    gy += 4 * (remaining ~/ 1461);
    remaining %= 1461;

    if (remaining >= 366) {
      gy += ((remaining - 1) ~/ 365);
      remaining = (remaining - 1) % 365;
    }

    final gd = remaining + 1;

    final febDays = (gy % 4 == 0 && gy % 100 != 0 || gy % 400 == 0) ? 29 : 28;
    final List<int> salA = [0, 31, febDays, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    var gm = 1;
    while (gm < 13 && gd > salA[gm]) {
      gm++;
    }

    int sum = 0;
    for (int i = 0; i < gm; i++) {
      sum += salA[i];
    }
    return [gy, gm, gd - sum];
  }

  /// Get today's Jalali date
  static List<int> today() {
    final now = DateTime.now();
    return gregorianToJalali(now.year, now.month, now.day);
  }

  /// Format: ۱۴۰۲/۰۴/۱۵
  static String formatDate(int year, int month, int day) {
    return '${_pad(year)}/${_pad(month)}/${_pad(day)}';
  }

  /// Format: شنبه ۱۵ تیر ۱۴۰۲
  static String formatDateFull(int year, int month, int day) {
    final wd = _getWeekday(year, month, day);
    return '$wd ${day} ${monthNames[month - 1]} $year';
  }

  static String _pad(int n) {
    return n.toString().padLeft(2, '0');
  }

  static int _getWeekday(int year, int month, int day) {
    final g = jalaliToGregorian(year, month, day);
    return DateTime(g[0], g[1], g[2]).weekday % 7;
  }

  static String getMonthName(int month) {
    return monthNames[month - 1];
  }

  static String getWeekdayName(int weekday) {
    return weekdayNames[weekday % 7];
  }

  static int getMonthDays(int year, int month) {
    if (month == 12 && !_isLeapYear(year)) return 29;
    return monthDays[month - 1];
  }

  static bool _isLeapYear(int year) {
    final rem = year % 33;
    const leaps = [1, 5, 9, 13, 17, 22, 26, 30];
    return leaps.contains(rem);
  }

  static bool isLeapYear(int year) => _isLeapYear(year);
}
