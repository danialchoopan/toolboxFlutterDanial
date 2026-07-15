import 'package:get/get.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../modules/tools/calculator_screen.dart';
import '../../modules/tools/unit_converter_screen.dart';
import '../../modules/tools/currency_converter_screen.dart';
import '../../modules/tools/qr_code_screen.dart';
import '../../modules/tools/password_generator_screen.dart';
import '../../modules/tools/text_editor_screen.dart';
import '../../modules/tools/word_counter_screen.dart';
import '../../modules/tools/color_picker_screen.dart';
import '../../modules/tools/stopwatch_screen.dart';
import '../../modules/tools/timer_screen.dart';
import '../../modules/tools/world_clock_screen.dart';
import '../../modules/tools/bmi_calculator_screen.dart';
import '../../modules/tools/age_calculator_screen.dart';
import '../../modules/tools/discount_calculator_screen.dart';
import '../../modules/tools/tip_calculator_screen.dart';
import '../../modules/tools/random_number_screen.dart';
import '../../modules/tools/flashlight_screen.dart';
import '../../modules/tools/compass_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/home';
  static const String settings = '/settings';

  // Calculator & Conversion
  static const String calculator = '/calculator';
  static const String unitConverter = '/unit-converter';
  static const String currencyConverter = '/currency-converter';
  static const String qrCode = '/qr-code';
  static const String passwordGenerator = '/password-generator';

  // Text Tools
  static const String textEditor = '/text-editor';
  static const String wordCounter = '/word-counter';

  // Daily Tools
  static const String colorPicker = '/color-picker';
  static const String stopwatch = '/stopwatch';
  static const String timer = '/timer';
  static const String worldClock = '/world-clock';

  // Health Tools
  static const String bmiCalculator = '/bmi-calculator';
  static const String ageCalculator = '/age-calculator';
  static const String discountCalculator = '/discount-calculator';
  static const String tipCalculator = '/tip-calculator';

  // Fun Tools
  static const String randomNumber = '/random-number';
  static const String flashlight = '/flashlight';
  static const String compass = '/compass';

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
    GetPage(name: calculator, page: () => const CalculatorScreen()),
    GetPage(name: unitConverter, page: () => const UnitConverterScreen()),
    GetPage(name: currencyConverter, page: () => const CurrencyConverterScreen()),
    GetPage(name: qrCode, page: () => const QrCodeScreen()),
    GetPage(name: passwordGenerator, page: () => const PasswordGeneratorScreen()),
    GetPage(name: textEditor, page: () => const TextEditorScreen()),
    GetPage(name: wordCounter, page: () => const WordCounterScreen()),
    GetPage(name: colorPicker, page: () => const ColorPickerScreen()),
    GetPage(name: stopwatch, page: () => const StopwatchScreen()),
    GetPage(name: timer, page: () => const TimerScreen()),
    GetPage(name: worldClock, page: () => const WorldClockScreen()),
    GetPage(name: bmiCalculator, page: () => const BmiCalculatorScreen()),
    GetPage(name: ageCalculator, page: () => const AgeCalculatorScreen()),
    GetPage(name: discountCalculator, page: () => const DiscountCalculatorScreen()),
    GetPage(name: tipCalculator, page: () => const TipCalculatorScreen()),
    GetPage(name: randomNumber, page: () => const RandomNumberScreen()),
    GetPage(name: flashlight, page: () => const FlashlightScreen()),
    GetPage(name: compass, page: () => const CompassScreen()),
  ];
}
