import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

class TodoItem {
  String id;
  String title;
  String? description;
  String category;
  int priority; // 0: low, 1: medium, 2: high
  DateTime? dueDate;
  bool isCompleted;
  List<TodoItem> subtasks;
  List<String> tags;
  bool isRecurring;
  String? recurringPattern;

  TodoItem({
    required this.id,
    required this.title,
    this.description,
    this.category = 'عمومی',
    this.priority = 1,
    this.dueDate,
    this.isCompleted = false,
    this.subtasks = const [],
    this.tags = const [],
    this.isRecurring = false,
    this.recurringPattern,
  });
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [];
  String _filterCategory = 'همه';
  String _filterPriority = 'همه';
  bool _showCompleted = true;
  String _searchQuery = '';

  final List<String> _categories = ['عمومی', 'کار', 'شخصی', 'خرید', 'تحصیلی'];
  final Map<int, String> _priorities = {0: 'کم', 1: 'متوسط', 2: 'زیاد'};
  final Map<int, Color> _priorityColors = {0: Colors.green, 1: Colors.orange, 2: Colors.red};

  List<TodoItem> get _filteredTodos {
    return _todos.where((todo) {
      if (!_showCompleted && todo.isCompleted) return false;
      if (_filterCategory != 'همه' && todo.category != _filterCategory) return false;
      if (_filterPriority != 'همه' && todo.priority != int.tryParse(_filterPriority)) return false;
      if (_searchQuery.isNotEmpty && !todo.title.toLowerCase().contains(_searchQuery.toLowerCase())) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست کارها'),
        actions: [
          IconButton(
            icon: Icon(_showCompleted ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _showCompleted = !_showCompleted),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'جستجو...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _filterCategory,
                        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                        items: ['همه', ..._categories].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _filterCategory = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _filterPriority,
                        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                        items: ['همه', '0', '1', '2'].map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p == 'همه' ? 'همه' : _priorities[int.parse(p)]!),
                        )).toList(),
                        onChanged: (v) => setState(() => _filterPriority = v!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Stats
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('کل', _todos.length),
                _buildStat('انجام شده', _todos.where((t) => t.isCompleted).length),
                _buildStat('باقی‌مانده', _todos.where((t) => !t.isCompleted).length),
              ],
            ),
          ),

          // Todo List
          Expanded(
            child: _filteredTodos.isEmpty
                ? Center(child: Text('کاری اضافه نشده'))
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredTodos.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = _filteredTodos.removeAt(oldIndex);
                        _filteredTodos.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      final todo = _filteredTodos[index];
                      return _buildTodoCard(todo);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoCard(TodoItem todo) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      key: ValueKey(todo.id),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (v) => setState(() => todo.isCompleted = v!),
          activeColor: AppColors.turquoise,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _priorityColors[todo.priority]!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _priorities[todo.priority]!,
                style: TextStyle(fontSize: 10, color: _priorityColors[todo.priority]),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.persianBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(todo.category, style: const TextStyle(fontSize: 10, color: AppColors.persianBlue)),
            ),
            if (todo.dueDate != null) ...[
              const SizedBox(width: 8),
              Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
            ],
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('ویرایش')),
            const PopupMenuItem(value: 'delete', child: Text('حذف')),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              setState(() => _todos.remove(todo));
            }
          },
        ),
        children: [
          if (todo.description != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(56, 0, 16, 8),
              child: Text(todo.description!, style: TextStyle(color: Colors.grey[600])),
            ),
          if (todo.subtasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(56, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('زیرمجموعه‌ها:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                  ...todo.subtasks.map((sub) => Row(
                    children: [
                      Checkbox(
                        value: sub.isCompleted,
                        onChanged: (v) => setState(() => sub.isCompleted = v!),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text(sub.title, style: TextStyle(fontSize: 12, decoration: sub.isCompleted ? TextDecoration.lineThrough : null)),
                    ],
                  )),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.turquoise)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }

  void _addTodo() {
    final titleController = TextEditingController();
    String category = 'عمومی';
    int priority = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('افزودن کار جدید', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'عنوان'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(labelText: 'دسته‌بندی'),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => category = v!,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: priority,
              decoration: const InputDecoration(labelText: 'اولویت'),
              items: [0, 1, 2].map((p) => DropdownMenuItem(
                value: p,
                child: Text(_priorities[p]!),
              )).toList(),
              onChanged: (v) => priority = v!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _todos.insert(0, TodoItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      category: category,
                      priority: priority,
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
}
