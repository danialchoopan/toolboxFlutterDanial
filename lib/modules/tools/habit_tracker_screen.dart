import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class Habit {
  String id;
  String name;
  String category;
  List<bool> completions; // last 7 days
  int streak;
  List<String> reminders;

  Habit({
    required this.id,
    required this.name,
    this.category = 'عمومی',
    List<bool>? completions,
    this.streak = 0,
    this.reminders = const [],
  }) : completions = completions ?? List.filled(7, false);
}

class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({super.key});

  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  final List<Habit> _habits = [];
  final List<String> _categories = ['عمومی', 'سلامت', 'یادگیری', 'ورزش', 'عادات بد'];
  int _selectedDayIndex = DateTime.now().weekday - 1;

  final List<String> _weekdays = ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ردیاب عادت‌ها'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _showStats,
          ),
        ],
      ),
      body: Column(
        children: [
          // Week Selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                final isSelected = index == _selectedDayIndex;
                final today = DateTime.now().weekday - 1;
                final dayOffset = today - index;
                final date = DateTime.now().subtract(Duration(days: dayOffset));

                return GestureDetector(
                  onTap: () => setState(() => _selectedDayIndex = index),
                  child: Container(
                    width: 48,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.turquoise : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _weekdays[index],
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          PersianNumbers.toPersianNumber(date.day),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          // Habits List
          Expanded(
            child: _habits.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.repeat, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('عادتی اضافه نشده', style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _habits.length,
                    itemBuilder: (context, index) => _buildHabitCard(_habits[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitCard(Habit habit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = [AppColors.turquoise, AppColors.persianBlue, AppColors.rose, AppColors.coral];
    final color = colors[habit.id.hashCode.abs() % colors.length];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Completion toggle
            GestureDetector(
              onTap: () {
                setState(() {
                  habit.completions[_selectedDayIndex] = !habit.completions[_selectedDayIndex];
                  _calculateStreak(habit);
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: habit.completions[_selectedDayIndex] ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: habit.completions[_selectedDayIndex] ? color : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: habit.completions[_selectedDayIndex]
                    ? const Icon(Icons.check, color: Colors.white, size: 24)
                    : null,
              ),
            ),
            const SizedBox(width: 12),

            // Habit info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: habit.completions[_selectedDayIndex] ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(habit.category, style: TextStyle(fontSize: 10, color: color)),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                      Text(' ${PersianNumbers.toPersianNumber(habit.streak)}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            // Week dots
            Row(
              children: List.generate(7, (index) {
                final isCompleted = habit.completions[index];
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isCompleted ? color : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateStreak(Habit habit) {
    int streak = 0;
    for (int i = _selectedDayIndex; i >= 0; i--) {
      if (habit.completions[i]) {
        streak++;
      } else {
        break;
      }
    }
    habit.streak = streak;
  }

  void _addHabit() {
    final nameController = TextEditingController();
    String category = 'عمومی';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('افزودن عادت', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'نام عادت'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(labelText: 'دسته‌بندی'),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => category = v!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _habits.add(Habit(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      category: category,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('افزودن'),
            ),
          ],
        ),
      ),
    );
  }

  void _showStats() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('آمار', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._habits.map((habit) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(habit.name),
                  Text(
                    '${habit.completions.where((c) => c).length}/7',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.turquoise),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
