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
import '../../modules/tools/accelerometer_screen.dart';
import '../../modules/tools/gyroscope_screen.dart';
import '../../modules/tools/barometer_screen.dart';
import '../../modules/tools/pomodoro_screen.dart';
import '../../modules/tools/todo_list_screen.dart';
import '../../modules/tools/notes_screen.dart';
import '../../modules/tools/habit_tracker_screen.dart';
import '../../modules/tools/daily_planner_screen.dart';
import '../../modules/tools/white_noise_screen.dart';
import '../../modules/tools/meeting_timer_screen.dart';
import '../../modules/tools/presentation_timer_screen.dart';
import '../../modules/tools/mind_map_screen.dart';
import '../../modules/tools/drawing_board_screen.dart';
import '../../modules/tools/random_generator_screen.dart';
import '../../modules/tools/mini_games_screen.dart';
import '../../modules/tools/network_tools_screen.dart';
import '../../modules/tools/enhanced_world_clock_screen.dart';
import '../../modules/tools/hiit_timer_screen.dart';
import '../../modules/tools/color_palette_screen.dart';
import '../../modules/tools/egg_timer_screen.dart';
import '../../modules/tools/sleep_timer_screen.dart';
import '../../modules/tools/dev_tools_screen.dart';
import '../../modules/tools/health_fitness_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/home';
  static const String settings = '/settings';
  static const String calculator = '/calculator';
  static const String unitConverter = '/unit-converter';
  static const String currencyConverter = '/currency-converter';
  static const String qrCode = '/qr-code';
  static const String passwordGenerator = '/password-generator';
  static const String textEditor = '/text-editor';
  static const String wordCounter = '/word-counter';
  static const String colorPicker = '/color-picker';
  static const String stopwatch = '/stopwatch';
  static const String timer = '/timer';
  static const String worldClock = '/world-clock';
  static const String bmiCalculator = '/bmi-calculator';
  static const String ageCalculator = '/age-calculator';
  static const String discountCalculator = '/discount-calculator';
  static const String tipCalculator = '/tip-calculator';
  static const String randomNumber = '/random-number';
  static const String flashlight = '/flashlight';
  static const String compass = '/compass';
  static const String accelerometer = '/accelerometer';
  static const String gyroscope = '/gyroscope';
  static const String barometer = '/barometer';
  static const String pomodoro = '/pomodoro';
  static const String todoList = '/todo-list';
  static const String notes = '/notes';
  static const String habitTracker = '/habit-tracker';
  static const String dailyPlanner = '/daily-planner';
  static const String whiteNoise = '/white-noise';
  static const String meetingTimer = '/meeting-timer';
  static const String presentationTimer = '/presentation-timer';
  static const String mindMap = '/mind-map';
  static const String drawingBoard = '/drawing-board';
  static const String randomGenerator = '/random-generator';
  static const String miniGames = '/mini-games';
  static const String networkTools = '/network-tools';
  static const String enhancedWorldClock = '/enhanced-world-clock';
  static const String hiitTimer = '/hiit-timer';
  static const String colorPalette = '/color-palette';
  static const String eggTimer = '/egg-timer';
  static const String sleepTimer = '/sleep-timer';
  static const String devTools = '/dev-tools';
  static const String healthDashboard = '/health-dashboard';

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
    GetPage(name: accelerometer, page: () => const AccelerometerScreen()),
    GetPage(name: gyroscope, page: () => const GyroscopeScreen()),
    GetPage(name: barometer, page: () => const BarometerScreen()),
    GetPage(name: pomodoro, page: () => const PomodoroScreen()),
    GetPage(name: todoList, page: () => const TodoListScreen()),
    GetPage(name: notes, page: () => const NotesScreen()),
    GetPage(name: habitTracker, page: () => const HabitTrackerScreen()),
    GetPage(name: dailyPlanner, page: () => const DailyPlannerScreen()),
    GetPage(name: whiteNoise, page: () => const WhiteNoiseScreen()),
    GetPage(name: meetingTimer, page: () => const MeetingTimerScreen()),
    GetPage(name: presentationTimer, page: () => const PresentationTimerScreen()),
    GetPage(name: mindMap, page: () => const MindMapScreen()),
    GetPage(name: drawingBoard, page: () => const DrawingBoardScreen()),
    GetPage(name: randomGenerator, page: () => const RandomGeneratorScreen()),
    GetPage(name: miniGames, page: () => const MiniGamesScreen()),
    GetPage(name: networkTools, page: () => const NetworkToolsScreen()),
    GetPage(name: enhancedWorldClock, page: () => const EnhancedWorldClockScreen()),
    GetPage(name: hiitTimer, page: () => const HiitTimerScreen()),
    GetPage(name: colorPalette, page: () => const ColorPaletteScreen()),
    GetPage(name: eggTimer, page: () => const EggTimerScreen()),
    GetPage(name: sleepTimer, page: () => const SleepTimerScreen()),
    GetPage(name: devTools, page: () => const DevToolsScreen()),
    GetPage(name: healthDashboard, page: () => const HealthDashboardScreen()),
  ];
}
