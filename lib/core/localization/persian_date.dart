/// Iranian Jalali (Shamsi) calendar utility.
///
/// The Jalali calendar is the official calendar of Iran and Afghanistan.
/// It's a solar calendar with 12 months:
/// - First 6 months: 31 days each
/// - Next 5 months: 30 days each
/// - Last month (Esfand): 29 days (30 in leap years)
///
/// This class provides:
/// - Gregorian ↔ Jalali date conversion
/// - Persian month/weekday names
/// - Date formatting for display
/// - Leap year detection
///
/// Algorithm based on the standard astronomical algorithm for
/// Gregorian-Jalali conversion.
class PersianDate {
  PersianDate._(); // Private constructor - utility class

  // ─── Persian Month Names (Farvardin to Esfand) ───
  static const List<String> monthNames = [
    'فروردین',    // Farvardin (1st month, ~March 21)
    'اردیبهشت',   // Ordibehesht (2nd month)
    'خرداد',      // Khordad (3rd month)
    'تیر',        // Tir (4th month)
    'مرداد',      // Mordad (5th month)
    'شهریور',     // Shahrivar (6th month)
    'مهر',        // Mehr (7th month)
    'آبان',       // Aban (8th month)
    'آذر',        // Azar (9th month)
    'دی',         // Dey (10th month)
    'بهمن',       // Bahman (11th month)
    'اسفند',      // Esfand (12th month)
  ];

  // ─── Persian Weekday Names (Saturday to Friday) ───
  // Note: Iranian week starts on Saturday
  static const List<String> weekdayNames = [
    'شنبه',       // Saturday (first day)
    'یکشنبه',     // Sunday
    'دوشنبه',     // Monday
    'سه‌شنبه',    // Tuesday
    'چهارشنبه',   // Wednesday
    'پنجشنبه',    // Thursday
    'جمعه',       // Friday (weekend)
  ];

  // ─── Days in Each Month ───
  static const List<int> monthDays = [
    31, 31, 31, 31, 31, 31,  // First 6 months: 31 days
    30, 30, 30, 30, 30,      // Next 5 months: 30 days
    29,                       // Esfand: 29 days (30 in leap year)
  ];

  // ─── Persian Ordinal Day Names ───
  static const List<String> monthDaysName = [
    'یکم', 'دوم', 'سوم', 'چهارم', 'پنجم', 'ششم', 'هفتم', 'هشتم', 'نهم',
    'دهم', 'یازدهم', 'دوازدهم', 'سیزدهم', 'چهاردهم', 'پانزدهم', 'شانزدهم',
    'هفدهم', 'هجدهم', 'نوزدهم', 'بیستم', 'بیست و یکم', 'بیست و دوم',
    'بیست و سوم', 'بیست و چهارم', 'بیست و پنجم', 'بیست و ششم',
    'بیست و هفتم', 'بیست و هشتم', 'بیست و نهم', 'سی ام', 'سی و یکم',
  ];

  // ─── Calendar Conversion ───

  /// Convert Gregorian date to Jalali (Iranian) date.
  ///
  /// Returns [year, month, day] in Jalali calendar.
  /// Algorithm uses the standard astronomical conversion.
  static List<int> gregorianToJalali(int year, int month, int day) {
    final gy = year;
    final gm = month;
    final gd = day;

    // Day-of-year offsets for each Gregorian month
    final g_d_m = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    var gy2 = (gm > 2) ? (gy + 1) : gy;

    // Calculate total days since epoch
    var days =
        355666 + (365 * gy) + ((gy2 + 3) ~/ 4) - ((gy2 + 99) ~/ 100) +
        ((gy2 + 399) ~/ 400) + gd + g_d_m[gm - 1];

    // Convert to Jalali year
    var jy = -1595 + (33 * (days ~/ 12053));
    days %= 12053;
    jy += 4 * (days ~/ 1461);
    days %= 1461;
    if (days > 365) {
      jy += ((days - 1) ~/ 365);
      days = (days - 1) % 365;
    }

    // Convert to Jalali month and day
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

  /// Convert Jalali (Iranian) date to Gregorian date.
  ///
  /// Returns [year, month, day] in Gregorian calendar.
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
      if (remaining >= 365) remaining++;
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
    while (gm < 13 && gd > salA[gm]) gm++;

    int sum = 0;
    for (int i = 0; i < gm; i++) sum += salA[i];
    return [gy, gm, gd - sum];
  }

  /// Get today's date in Jalali calendar.
  static List<int> today() {
    final now = DateTime.now();
    return gregorianToJalali(now.year, now.month, now.day);
  }

  // ─── Formatting Methods ───

  /// Format date as: ۱۴۰۲/۰۴/۱۵
  static String formatDate(int year, int month, int day) {
    return '${_pad(year)}/${_pad(month)}/${_pad(day)}';
  }

  /// Format date with weekday name: شنبه ۱۵ تیر ۱۴۰۲
  static String formatDateFull(int year, int month, int day) {
    final wd = _getWeekday(year, month, day);
    return '$wd ${day} ${monthNames[month - 1]} $year';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');

  /// Get weekday index (0=Saturday, 6=Friday)
  static int _getWeekday(int year, int month, int day) {
    final g = jalaliToGregorian(year, month, day);
    return DateTime(g[0], g[1], g[2]).weekday % 7;
  }

  static String getMonthName(int month) => monthNames[month - 1];
  static String getWeekdayName(int weekday) => weekdayNames[weekday % 7];

  /// Get number of days in a given Jalali month.
  static int getMonthDays(int year, int month) {
    if (month == 12 && !_isLeapYear(year)) return 29;
    return monthDays[month - 1];
  }

  /// Check if a Jalali year is a leap year.
  /// Leap years occur in a 33-year cycle at specific intervals.
  static bool _isLeapYear(int year) {
    final rem = year % 33;
    const leaps = [1, 5, 9, 13, 17, 22, 26, 30];
    return leaps.contains(rem);
  }

  static bool isLeapYear(int year) => _isLeapYear(year);
}
