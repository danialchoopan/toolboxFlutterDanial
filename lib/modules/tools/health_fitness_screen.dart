import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_date.dart';
import '../../core/localization/persian_numbers.dart';

class HealthDashboardScreen extends StatelessWidget {
  const HealthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {'title': 'شمارش قدم', 'fa': 'شمارشگر قدم', 'icon': Icons.directions_walk, 'color': AppColors.turquoise, 'page': const StepCounterScreen()},
      {'title': 'کالری', 'fa': 'محاسبه کالری', 'icon': Icons.local_fire_department, 'color': AppColors.rose, 'page': const CalorieTrackerScreen()},
      {'title': 'آب', 'fa': 'ردیاب آب', 'icon': Icons.water_drop, 'color': AppColors.sky, 'page': const WaterTrackerScreen()},
      {'title': 'خواب', 'fa': 'ردیاب خواب', 'icon': Icons.bedtime, 'color': AppColors.lapis, 'page': const SleepTrackerScreen()},
      {'title': 'تمرین', 'fa': 'ردیاب تمرین', 'icon': Icons.fitness_center, 'color': AppColors.coral, 'page': const WorkoutTrackerScreen()},
      {'title': 'ضربان قلب', 'fa': 'ضربان قلب', 'icon': Icons.favorite, 'color': AppColors.rose, 'page': const HeartRateScreen()},
      {'title': 'فشار خون', 'fa': 'ثبت فشار خون', 'icon': Icons.bloodtype, 'color': AppColors.dailyToolsColor, 'page': const BloodPressureScreen()},
      {'title': 'قند خون', 'fa': 'ثبت قند خون', 'icon': Icons.medical_services, 'color': AppColors.saffron, 'page': const BloodSugarScreen()},
      {'title': 'دارو', 'fa': 'یادآور دارو', 'icon': Icons.medication, 'color': AppColors.mint, 'page': const MedicationScreen()},
      {'title': 'یوگا', 'fa': 'یوگا و مدیتیشن', 'icon': Icons.self_improvement, 'color': AppColors.lavender, 'page': const YogaScreen()},
      {'title': 'چرخه', 'fa': 'چرخه قاعدگی', 'icon': Icons.calendar_month, 'color': AppColors.rose, 'page': const CycleTrackerScreen()},
      {'title': 'بارداری', 'fa': 'ردیاب بارداری', 'icon': Icons.child_care, 'color': AppColors.lavender, 'page': const PregnancyTrackerScreen()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلامت و تناسب اندام'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(child: Text(PersianDate.formatDateFull(PersianDate.today()[0], PersianDate.today()[1], PersianDate.today()[2]), style: const TextStyle(fontSize: 12))),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          final color = tool['color'] as Color;
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => tool['page'] as Widget)),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 8)],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(tool['icon'] as IconData, color: color, size: 28)),
                const SizedBox(height: 8),
                Text(tool['fa'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              ]),
            ),
          );
        },
      ),
    );
  }
}

// ─── Step Counter ───
class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});
  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  int _steps = 0;
  int _goal = 10000;
  double _distance = 0;
  int _calories = 0;

  @override
  Widget build(BuildContext context) {
    final progress = (_steps / _goal).clamp(0.0, 1.0).toDouble();
    final today = PersianDate.today();

    return Scaffold(
      appBar: AppBar(title: const Text('شمارشگر قدم')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Text(PersianDate.formatDateFull(today[0], today[1], today[2]), style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 24),
          SizedBox(
            width: 200, height: 200,
            child: Stack(alignment: Alignment.center, children: [
              CircularProgressIndicator(value: 1, strokeWidth: 12, backgroundColor: Colors.grey[200]),
              CircularProgressIndicator(value: progress, strokeWidth: 12, backgroundColor: Colors.transparent, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.turquoise), strokeCap: StrokeCap.round),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text(PersianNumbers.toPersianNumber(_steps), style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: AppColors.turquoise)),
                const Text('قدم', style: TextStyle(color: Colors.grey)),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _stat('فاصله', '${_distance.toStringAsFixed(1)} km', Icons.straighten),
            _stat('کالری', '$_calories kcal', Icons.local_fire_department),
            _stat('هدف', PersianNumbers.toPersianNumber(_goal), Icons.flag),
          ]),
          const SizedBox(height: 32),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton.icon(onPressed: () => setState(() { _steps += 100; _distance = _steps * 0.000762; _calories = (_steps * 0.04).round(); }), icon: const Icon(Icons.add), label: const Text('+۱۰۰ قدم')),
            const SizedBox(width: 12),
            OutlinedButton.icon(onPressed: () => setState(() { _steps += 1000; _distance = _steps * 0.000762; _calories = (_steps * 0.04).round(); }), icon: const Icon(Icons.add), label: const Text('+۱۰۰۰ قدم')),
          ]),
          const SizedBox(height: 16),
          Slider(value: _goal.toDouble(), min: 1000, max: 30000, divisions: 29, label: PersianNumbers.toPersianNumber(_goal), onChanged: (v) => setState(() => _goal = v.round())),
          Text('هدف روزانه: ${PersianNumbers.toPersianNumber(_goal)} قدم'),
        ]),
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon) {
    return Column(children: [
      Icon(icon, color: AppColors.turquoise, size: 24),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
    ]);
  }
}

// ─── Calorie Tracker ───
class CalorieTrackerScreen extends StatefulWidget {
  const CalorieTrackerScreen({super.key});
  @override
  State<CalorieTrackerScreen> createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  int _totalCalories = 0;
  int _goalCalories = 2000;
  final List<Map<String, dynamic>> _meals = [];
  final List<Map<String, dynamic>> _foods = [
    {'name': 'برنج', 'calories': 130, 'serving': '۱۰۰g'},
    {'name': 'مرغ', 'calories': 165, 'serving': '۱۰۰g'},
    {'name': 'تخم مرغ', 'calories': 78, 'serving': '۱ عدد'},
    {'name': 'نان بربری', 'calories': 250, 'serving': '۱ عدد'},
    {'name': 'سالاد', 'calories': 50, 'serving': '۱ کاسه'},
    {'name': 'ماست', 'calories': 100, 'serving': '۱ لیوان'},
    {'name': 'میوه', 'calories': 60, 'serving': '۱ عدد'},
    {'name': 'آب', 'calories': 0, 'serving': '۱ لیوان'},
  ];

  @override
  Widget build(BuildContext context) {
    final progress = (_totalCalories / _goalCalories).clamp(0.0, 1.0).toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('محاسبه کالری')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // Calorie ring
          SizedBox(
            width: 180, height: 180,
            child: Stack(alignment: Alignment.center, children: [
              CircularProgressIndicator(value: 1, strokeWidth: 10, backgroundColor: Colors.grey[200]),
              CircularProgressIndicator(value: progress, strokeWidth: 10, valueColor: AlwaysStoppedAnimation<Color>(progress > 1 ? Colors.red : AppColors.turquoise), strokeCap: StrokeCap.round),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text(PersianNumbers.toPersianNumber(_totalCalories), style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: progress > 1 ? Colors.red : AppColors.turquoise)),
                Text('از ${PersianNumbers.toPersianNumber(_goalCalories)}', style: const TextStyle(color: Colors.grey)),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          // Foods
          const Align(alignment: Alignment.centerRight, child: Text('غذاها', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          const SizedBox(height: 8),
          ...(_foods.map((f) => Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: AppColors.turquoise.withOpacity(0.1), child: Text('${f['calories']}', style: const TextStyle(fontSize: 12, color: AppColors.turquoise))),
              title: Text(f['name']),
              subtitle: Text(f['serving']),
              trailing: IconButton(icon: const Icon(Icons.add_circle, color: AppColors.turquoise), onPressed: () {
                setState(() { _totalCalories += f['calories'] as int; _meals.add({...f, 'date': PersianDate.today().join('/')}); });
              }),
            ),
          ))),
          const SizedBox(height: 16),
          // Today's meals
          if (_meals.isNotEmpty) ...[
            const Align(alignment: Alignment.centerRight, child: Text('وعده‌های امروز', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            const SizedBox(height: 8),
            ...(_meals.map((m) => Card(child: ListTile(title: Text(m['name']), trailing: Text('${m['calories']} kcal', style: const TextStyle(color: AppColors.rose)))))),
          ],
        ]),
      ),
    );
  }
}

// ─── Water Tracker ───
class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});
  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  int _glasses = 0;
  int _goal = 8;
  final List<String> _history = [];

  @override
  Widget build(BuildContext context) {
    final progress = (_glasses / _goal).clamp(0.0, 1.0).toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('ردیاب مصرف آب')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // Water visualization
          SizedBox(
            width: 180, height: 180,
            child: Stack(alignment: Alignment.center, children: [
              CircularProgressIndicator(value: 1, strokeWidth: 12, backgroundColor: Colors.grey[200]),
              CircularProgressIndicator(value: progress, strokeWidth: 12, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.sky), strokeCap: StrokeCap.round),
              Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('💧', style: TextStyle(fontSize: 32)),
                Text(PersianNumbers.toPersianNumber(_glasses), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.sky)),
                Text('از ${PersianNumbers.toPersianNumber(_goal)} لیوان', style: const TextStyle(color: Colors.grey)),
              ]),
            ]),
          ),
          const SizedBox(height: 32),
          // Water glasses grid
          Wrap(
            spacing: 8, runSpacing: 8,
            children: List.generate(_goal, (i) => GestureDetector(
              onTap: () => setState(() { _glasses = i + 1; _history.add('${PersianNumbers.toPersianNumber(i + 1)} لیوان - ${PersianDate.formatDate(PersianDate.today()[0], PersianDate.today()[1], PersianDate.today()[2])}'); }),
              child: Container(
                width: 60, height: 70,
                decoration: BoxDecoration(
                  color: i < _glasses ? AppColors.sky : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('💧', style: TextStyle(fontSize: 28))),
              ),
            )),
          ),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton.icon(onPressed: _glasses > 0 ? () => setState(() => _glasses--) : null, icon: const Icon(Icons.remove), label: const Text('کم کردن')),
            const SizedBox(width: 16),
            ElevatedButton.icon(onPressed: _glasses < _goal ? () => setState(() { _glasses++; _history.add('یک لیوان'); }) : null, icon: const Icon(Icons.add), label: const Text('افزودن')),
          ]),
          const SizedBox(height: 24),
          Slider(value: _goal.toDouble(), min: 4, max: 16, divisions: 12, label: PersianNumbers.toPersianNumber(_goal), onChanged: (v) => setState(() => _goal = v.round())),
          Text('هدف: ${PersianNumbers.toPersianNumber(_goal)} لیوان'),
          if (_history.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Align(alignment: Alignment.centerRight, child: Text('تاریخچه', style: TextStyle(fontWeight: FontWeight.bold))),
            ...(_history.reversed.take(5).map((h) => Card(child: ListTile(leading: const Icon(Icons.water_drop, color: AppColors.sky), title: Text(h))))),
          ],
        ]),
      ),
    );
  }
}

// ─── Sleep Tracker ───
class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({super.key});
  @override
  State<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  final List<Map<String, dynamic>> _sleepLog = [];
  String _quality = 'خوب';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ردیاب خواب')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Sleep quality
          const Text('کیفیت خواب امشب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _qualityBtn('عالی', '🌟'),
            _qualityBtn('خوب', '😊'),
            _qualityBtn('متوسط', '😐'),
            _qualityBtn('بد', '😴'),
          ]),
          const SizedBox(height: 24),
          // Log sleep
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('ثبت خواب', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(children: [
                const Icon(Icons.bedtime, color: AppColors.lapis),
                const SizedBox(width: 8),
                const Text('ساعت خواب: '),
                Text('۲۳:۰۰', style: TextStyle(color: AppColors.lapis, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.alarm, color: AppColors.mint),
                const SizedBox(width: 8),
                const Text('ساعت بیداری: '),
                Text('۰۷:۰۰', style: TextStyle(color: AppColors.mint, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () {
                setState(() => _sleepLog.add({
                  'date': PersianDate.formatDate(PersianDate.today()[0], PersianDate.today()[1], PersianDate.today()[2]),
                  'hours': 8,
                  'quality': _quality,
                }));
              }, child: const Text('ثبت')),
            ]),
          )),
          const SizedBox(height: 24),
          // Sleep history
          if (_sleepLog.isNotEmpty) ...[
            const Text('تاریخچه خواب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...(_sleepLog.reversed.map((log) => Card(
              child: ListTile(
                leading: const Icon(Icons.bedtime, color: AppColors.lapis),
                title: Text('${log['date']} - ${PersianNumbers.toPersianNumber(log['hours'])} ساعت'),
                subtitle: Text('کیفیت: ${log['quality']}'),
              ),
            ))),
          ],
        ]),
      ),
    );
  }

  Widget _qualityBtn(String label, String emoji) {
    final isSelected = _quality == label;
    return GestureDetector(
      onTap: () => setState(() => _quality = label),
      child: Column(children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(color: isSelected ? AppColors.lapis.withOpacity(0.1) : Colors.grey[100], borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? AppColors.lapis : Colors.transparent, width: 2)),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ]),
    );
  }
}

// ─── Workout Tracker ───
class WorkoutTrackerScreen extends StatefulWidget {
  const WorkoutTrackerScreen({super.key});
  @override
  State<WorkoutTrackerScreen> createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  final List<Map<String, dynamic>> _exercises = [
    {'name': 'شنا', 'icon': '💪', 'sets': 0},
    {'name': 'اسکات', 'icon': '🦵', 'sets': 0},
    {'name': 'ددلیفت', 'icon': '🏋️', 'sets': 0},
    {'name': 'بارفیکس', 'icon': '💪', 'sets': 0},
    {'name': 'پلانک', 'icon': '🧘', 'sets': 0},
    {'name': 'پوش‌آپ', 'icon': '💪', 'sets': 0},
  ];
  final List<Map<String, dynamic>> _log = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ردیاب تمرین')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(PersianDate.formatDateFull(PersianDate.today()[0], PersianDate.today()[1], PersianDate.today()[2]), style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ...(_exercises.map((e) => Card(
            child: ListTile(
              leading: Text(e['icon'], style: const TextStyle(fontSize: 28)),
              title: Text(e['name']),
              subtitle: Text('${PersianNumbers.toPersianNumber(e['sets'])} ست'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: e['sets'] > 0 ? () => setState(() => e['sets']--) : null),
                IconButton(icon: const Icon(Icons.add_circle, color: AppColors.coral), onPressed: () => setState(() => e['sets']++)),
              ]),
            ),
          ))),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(
            onPressed: () {
              final total = _exercises.fold(0, (sum, e) => sum + (e['sets'] as int));
              if (total > 0) setState(() => _log.add({
                'date': PersianDate.formatDate(PersianDate.today()[0], PersianDate.today()[1], PersianDate.today()[2]),
                'exercises': total,
                'details': _exercises.where((e) => e['sets'] > 0).map((e) => '${e['name']}: ${e['sets']}').join(', '),
              }));
            },
            icon: const Icon(Icons.save), label: const Text('ذخیره تمرین'),
          )),
          if (_log.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text('تاریخچه', style: TextStyle(fontWeight: FontWeight.bold)),
            ...(_log.reversed.map((l) => Card(child: ListTile(
              leading: const Icon(Icons.fitness_center, color: AppColors.coral),
              title: Text('${l['date']} - ${PersianNumbers.toPersianNumber(l['exercises'])} تمرین'),
              subtitle: Text(l['details']),
            )))),
          ],
        ]),
      ),
    );
  }
}

// ─── Heart Rate ───
class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});
  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  int _bpm = 0;
  bool _isMeasuring = false;
  final List<int> _history = [];

  void _measure() {
    setState(() { _isMeasuring = true; _bpm = 0; });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _bpm = 60 + Random().nextInt(40);
        _isMeasuring = false;
        _history.add(_bpm);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ضربان قلب')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(
              onTap: _measure,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isMeasuring ? AppColors.rose : AppColors.rose.withOpacity(0.1),
                  boxShadow: _isMeasuring ? [BoxShadow(color: AppColors.rose.withOpacity(0.5), blurRadius: 30, spreadRadius: 10)] : null,
                ),
                child: Center(child: _isMeasuring
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 4)
                    : Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.favorite, color: _isMeasuring ? Colors.white : AppColors.rose, size: 48),
                        if (_bpm > 0) Text('$_bpm', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.rose)),
                      ])),
              ),
            ),
            const SizedBox(height: 16),
            Text(_isMeasuring ? 'در حال اندازه‌گیری...' : 'برای اندازه‌گیری ضربه بزنید', style: const TextStyle(color: Colors.grey)),
            if (_bpm > 0) ...[
              const SizedBox(height: 16),
              Text('$_bpm ضربه در دقیقه', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.rose)),
              Text(_bpm < 60 ? 'آرام' : _bpm < 100 ? 'نرمال' : 'بالا', style: TextStyle(color: _bpm < 100 ? Colors.green : Colors.orange)),
            ],
            if (_history.isNotEmpty) ...[
              const SizedBox(height: 32),
              const Align(alignment: Alignment.centerRight, child: Text('تاریخچه', style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: _history.reversed.take(10).map((h) => Chip(label: Text('$h bpm'))).toList()),
            ],
          ]),
        ),
      ),
    );
  }
}

// ─── Blood Pressure ───
class BloodPressureScreen extends StatefulWidget {
  const BloodPressureScreen({super.key});
  @override
  State<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final List<Map<String, dynamic>> _log = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ثبت فشار خون')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: TextField(controller: _systolicController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'سیستولیک (بالا)'))),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _diastolicController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'دیاستولیک (پایین)'))),
          ]),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {
            final sys = int.tryParse(_systolicController.text) ?? 0;
            final dia = int.tryParse(_diastolicController.text) ?? 0;
            if (sys > 0 && dia > 0) setState(() => _log.add({
              'date': PersianDate.formatDate(PersianDate.today()[0], PersianDate.today()[1], PersianDate.today()[2]),
              'systolic': sys, 'diastolic': dia,
              'status': sys < 120 && dia < 80 ? 'نرمال' : sys < 140 || dia < 90 ? 'مرزی' : 'بالا',
            }));
          }, child: const Text('ثبت'))),
          const SizedBox(height: 24),
          ...(_log.reversed.map((l) => Card(child: ListTile(
            leading: Icon(Icons.bloodtype, color: l['status'] == 'نرمال' ? Colors.green : l['status'] == 'مرزی' ? Colors.orange : Colors.red),
            title: Text('${l['systolic']}/${l['diastolic']} mmHg'),
            subtitle: Text('${l['date']} - ${l['status']}'),
          )))),
        ]),
      ),
    );
  }
}

// ─── Blood Sugar ───
class BloodSugarScreen extends StatefulWidget {
  const BloodSugarScreen({super.key});
  @override
  State<BloodSugarScreen> createState() => _BloodSugarScreenState();
}

class _BloodSugarScreenState extends State<BloodSugarScreen> {
  final _controller = TextEditingController();
  final List<Map<String, dynamic>> _log = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ثبت قند خون')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(controller: _controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'قند خون (mg/dL)')),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {
            final val = int.tryParse(_controller.text) ?? 0;
            if (val > 0) setState(() => _log.add({
              'date': PersianDate.formatDate(PersianDate.today()[0], PersianDate.today()[1], PersianDate.today()[2]),
              'value': val,
              'status': val < 100 ? 'نرمال' : val < 126 ? 'پیش‌دیابتی' : 'بالا',
            }));
          }, child: const Text('ثبت'))),
          const SizedBox(height: 24),
          ...(_log.reversed.map((l) => Card(child: ListTile(
            leading: Icon(Icons.medical_services, color: l['status'] == 'نرمال' ? Colors.green : Colors.red),
            title: Text('${PersianNumbers.toPersianNumber(l['value'])} mg/dL'),
            subtitle: Text('${l['date']} - ${l['status']}'),
          )))),
        ]),
      ),
    );
  }
}

// ─── Medication ───
class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});
  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final List<Map<String, dynamic>> _medications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('یادآور دارو')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final nameController = TextEditingController();
          showModalBottomSheet(context: context, isScrollControlled: true, builder: (c) => Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(c).viewInsets.bottom + 24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'نام دارو')),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () {
                setState(() => _medications.add({'name': nameController.text, 'taken': false, 'date': PersianDate.formatDate(PersianDate.today()[0], PersianDate.today()[1], PersianDate.today()[2])}));
                Navigator.pop(c);
              }, child: const Text('افزودن')),
            ]),
          ));
        },
        child: const Icon(Icons.add),
      ),
      body: _medications.isEmpty
          ? const Center(child: Text('دارویی اضافه نشده'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _medications.length,
              itemBuilder: (context, i) {
                final med = _medications[i];
                return Card(child: ListTile(
                  leading: Icon(Icons.medication, color: med['taken'] ? Colors.green : AppColors.mint),
                  title: Text(med['name'], style: TextStyle(decoration: med['taken'] ? TextDecoration.lineThrough : null)),
                  subtitle: Text(med['date']),
                  trailing: Checkbox(value: med['taken'], onChanged: (v) => setState(() => med['taken'] = v), activeColor: Colors.green),
                ));
              },
            ),
    );
  }
}

// ─── Yoga/Meditation ───
class YogaScreen extends StatelessWidget {
  const YogaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final poses = [
      {'name': 'کودک', 'duration': '۵ دقیقه', 'description': 'زانو زده و پیشانی روی زمین'},
      {'name': 'سگ', 'duration': '۳ دقیقه', 'description': 'دست‌ها و پاها روی زمین، باسن بالا'},
      {'name': 'جنگجو', 'duration': '۳ دقیقه', 'description': 'زانو خم، دست‌ها بالا'},
      {'name': 'درخت', 'duration': '۳ دقیقه', 'description': 'یک پا روی ران پای دیگر'},
      {'name': 'هلال', 'duration': '۵ دقیقه', 'description': 'نیم خیز با دست‌ها بالا'},
      {'name': 'مرد نشسته', 'duration': '۱۰ دقیقه', 'description': 'نشسته با پاهای ضربدری'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('یوگا و مدیتیشن')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: poses.length,
        itemBuilder: (context, i) {
          final pose = poses[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: AppColors.lavender.withOpacity(0.1), child: Text('${i + 1}', style: const TextStyle(color: AppColors.lavender))),
              title: Text(pose['name']!),
              subtitle: Text('${pose['description']} - ${pose['duration']}'),
            ),
          );
        },
      ),
    );
  }
}

// ─── Cycle Tracker ───
class CycleTrackerScreen extends StatefulWidget {
  const CycleTrackerScreen({super.key});
  @override
  State<CycleTrackerScreen> createState() => _CycleTrackerScreenState();
}

class _CycleTrackerScreenState extends State<CycleTrackerScreen> {
  DateTime? _lastPeriod;
  int _cycleLength = 28;

  @override
  Widget build(BuildContext context) {
    final today = PersianDate.today();
    String nextPeriod = '';
    if (_lastPeriod != null) {
      final next = _lastPeriod!.add(Duration(days: _cycleLength));
      final jalali = PersianDate.gregorianToJalali(next.year, next.month, next.day);
      nextPeriod = PersianDate.formatDate(jalali[0], jalali[1], jalali[2]);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('چرخه قاعدگی')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('تاریخ آخرین عادت ماهانه', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: AppColors.rose),
                title: Text(_lastPeriod != null ? PersianDate.formatDate(_lastPeriod!.year, _lastPeriod!.month, _lastPeriod!.day) : 'انتخاب کنید'),
                trailing: const Icon(Icons.chevron_left),
                onTap: () async {
                  final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
                  if (picked != null) setState(() => _lastPeriod = picked);
                },
              ),
            ]),
          )),
          const SizedBox(height: 16),
          Row(children: [
            const Text('طول چرخه: '),
            for (var l in [24, 26, 28, 30, 32]) Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(label: Text('$l'), selected: _cycleLength == l, onSelected: (_) => setState(() => _cycleLength = l)),
            ),
          ]),
          if (nextPeriod.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.rose.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                const Text('تاریخ تخمینی عادت بعدی', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(nextPeriod, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.rose)),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}

// ─── Pregnancy Tracker ───
class PregnancyTrackerScreen extends StatefulWidget {
  const PregnancyTrackerScreen({super.key});
  @override
  State<PregnancyTrackerScreen> createState() => _PregnancyTrackerScreenState();
}

class _PregnancyTrackerScreenState extends State<PregnancyTrackerScreen> {
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    String weeksPregnant = '';
    if (_dueDate != null) {
      final diff = _dueDate!.difference(DateTime.now()).inDays;
      final weeks = ((280 - diff) / 7).floor();
      weeksPregnant = PersianNumbers.toPersianNumber(weeks.clamp(0, 42));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ردیاب بارداری')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Card(child: ListTile(
            leading: const Icon(Icons.calendar_today, color: AppColors.lavender),
            title: Text(_dueDate != null ? 'تاریخ زایمان: ${PersianDate.formatDate(_dueDate!.year, _dueDate!.month, _dueDate!.day)}' : 'تاریخ زایمان را انتخاب کنید'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () async {
              final picked = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 200)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 300)));
              if (picked != null) setState(() => _dueDate = picked);
            },
          )),
          if (weeksPregnant.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.lavender.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                const Text('هفته', style: TextStyle(color: Colors.grey)),
                Text(weeksPregnant, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.lavender)),
                const Text('هفته بارداری', style: TextStyle(color: Colors.grey)),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}
