import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class PlannerEvent {
  String id;
  String title;
  int hour;
  int duration; // in minutes
  String category;
  Color color;

  PlannerEvent({
    required this.id,
    required this.title,
    required this.hour,
    this.duration = 60,
    this.category = 'عمومی',
    this.color = AppColors.turquoise,
  });
}

class DailyPlannerScreen extends StatefulWidget {
  const DailyPlannerScreen({super.key});

  @override
  State<DailyPlannerScreen> createState() => _DailyPlannerScreenState();
}

class _DailyPlannerScreenState extends State<DailyPlannerScreen> {
  final List<PlannerEvent> _events = [];
  final ScrollController _scrollController = ScrollController();
  int _selectedHour = DateTime.now().hour;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_selectedHour * 80.0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('برنامه روزانه'),
      ),
      body: Row(
        children: [
          // Time column
          Container(
            width: 60,
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 24,
              itemBuilder: (context, hour) {
                final isNow = hour == _selectedHour;
                return Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: isNow ? AppColors.turquoise.withOpacity(0.1) : null,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${PersianNumbers.toPersianNumber(hour.toString().padLeft(2, '0'))}:۰۰',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                      color: isNow ? AppColors.turquoise : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),

          // Events column
          Expanded(
            child: ListView.builder(
              itemCount: 24,
              itemBuilder: (context, hour) {
                final hourEvents = _events.where((e) => e.hour == hour).toList();
                return GestureDetector(
                  onTap: () => _addEvent(hour),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                        left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                      ),
                    ),
                    child: hourEvents.isEmpty
                        ? null
                        : Stack(
                            children: hourEvents.map((event) => Positioned(
                              left: 4,
                              right: 4,
                              top: 4,
                              bottom: 4,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: event.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: event.color.withOpacity(0.5)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      event.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: event.color,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${event.duration} دقیقه',
                                      style: TextStyle(fontSize: 10, color: event.color.withOpacity(0.7)),
                                    ),
                                  ],
                                ),
                              ),
                            )).toList(),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEvent(_selectedHour),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addEvent(int hour) {
    final titleController = TextEditingController();
    final durationController = TextEditingController(text: '60');
    final colors = [AppColors.turquoise, AppColors.persianBlue, AppColors.rose, AppColors.coral, AppColors.dailyToolsColor];
    int selectedColorIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('رویداد ساعت ${PersianNumbers.toPersianNumber(hour)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'عنوان'),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'مدت (دقیقه)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const Text('رنگ'),
              const SizedBox(height: 8),
              Row(
                children: colors.asMap().entries.map((entry) => GestureDetector(
                  onTap: () => setModalState(() => selectedColorIndex = entry.key),
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: entry.value,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColorIndex == entry.key ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: selectedColorIndex == entry.key
                          ? [BoxShadow(color: entry.value.withOpacity(0.5), blurRadius: 8)]
                          : null,
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    setState(() {
                      _events.add(PlannerEvent(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        hour: hour,
                        duration: int.tryParse(durationController.text) ?? 60,
                        color: colors[selectedColorIndex],
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
      ),
    );
  }
}
