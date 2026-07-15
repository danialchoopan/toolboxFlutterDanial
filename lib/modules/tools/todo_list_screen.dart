import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TodoItem {
  String id;
  String title;
  String category;
  int priority;
  bool isCompleted;

  TodoItem({required this.id, required this.title, this.category = 'عمومی', this.priority = 1, this.isCompleted = false});
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [];
  String _filter = 'همه';
  String _search = '';
  final _categories = ['عمومی', 'کار', 'شخصی', 'خرید'];

  List<TodoItem> get _filtered => _todos.where((t) {
    if (_filter != 'همه' && t.category != _filter) return false;
    if (_search.isNotEmpty && !t.title.contains(_search)) return false;
    return true;
  }).toList();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('لیست کارها')),
      body: isDesktop
          ? Row(
              children: [
                Expanded(flex: 2, child: _buildList(context)),
                Container(width: 1, color: Colors.grey[300]),
                SizedBox(width: 320, child: _buildSidebar(context)),
              ],
            )
          : _buildList(context),
      floatingActionButton: FloatingActionButton(onPressed: _addTodo, child: const Icon(Icons.add)),
    );
  }

  Widget _buildList(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(child: TextField(onChanged: (v) => setState(() => _search = v), decoration: InputDecoration(hintText: 'جستجو...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
            const SizedBox(width: 12),
            DropdownButton<String>(
              value: _filter,
              items: ['همه', ..._categories].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _filter = v!),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _stat('کل', _todos.length), _stat('انجام شده', _todos.where((t) => t.isCompleted).length), _stat('باقی', _todos.where((t) => !t.isCompleted).length),
          ]),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _filtered.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.checklist, size: 60, color: Colors.grey[300]), const SizedBox(height: 12), Text('کاری اضافه نشده', style: TextStyle(color: Colors.grey[500]))]))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filtered.length,
                  itemBuilder: (context, i) => _buildCard(_filtered[i]),
                ),
        ),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('آمار', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _statCard('کل کارها', _todos.length, AppColors.persianBlue),
          const SizedBox(height: 8),
          _statCard('انجام شده', _todos.where((t) => t.isCompleted).length, AppColors.turquoise),
          const SizedBox(height: 8),
          _statCard('باقی‌مانده', _todos.where((t) => !t.isCompleted).length, AppColors.rose),
        ],
      ),
    );
  }

  Widget _statCard(String label, int value, Color color) {
    return Card(child: ListTile(leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Text('$value', style: TextStyle(color: color, fontWeight: FontWeight.bold))), title: Text(label)));
  }

  Widget _stat(String label, int value) {
    return Column(children: [
      Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.turquoise)),
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
    ]);
  }

  Widget _buildCard(TodoItem todo) {
    final priorityColors = [Colors.green, Colors.orange, Colors.red];
    final priorityLabels = ['کم', 'متوسط', 'زیاد'];
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(value: todo.isCompleted, onChanged: (v) => setState(() => todo.isCompleted = v!), activeColor: AppColors.turquoise),
        title: Text(todo.title, style: TextStyle(decoration: todo.isCompleted ? TextDecoration.lineThrough : null, color: todo.isCompleted ? Colors.grey : null)),
        subtitle: Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: priorityColors[todo.priority].withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(priorityLabels[todo.priority], style: TextStyle(fontSize: 10, color: priorityColors[todo.priority]))),
          const SizedBox(width: 8),
          Text(todo.category, style: const TextStyle(fontSize: 10, color: AppColors.persianBlue)),
        ]),
        trailing: IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: () => setState(() => _todos.remove(todo))),
      ),
    );
  }

  void _addTodo() {
    final c = TextEditingController();
    String cat = 'عمومی';
    int pri = 1;
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('کار جدید', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(controller: c, decoration: const InputDecoration(labelText: 'عنوان'), autofocus: true),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: DropdownButtonFormField<String>(value: cat, decoration: const InputDecoration(labelText: 'دسته'), items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => cat = v!)),
          const SizedBox(width: 12),
          Expanded(child: DropdownButtonFormField<int>(value: pri, decoration: const InputDecoration(labelText: 'اولویت'), items: [0, 1, 2].map((p) => DropdownMenuItem(value: p, child: Text(['کم', 'متوسط', 'زیاد'][p]))).toList(), onChanged: (v) => pri = v!)),
        ]),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () { if (c.text.isNotEmpty) { setState(() => _todos.insert(0, TodoItem(id: DateTime.now().millisecondsSinceEpoch.toString(), title: c.text, category: cat, priority: pri))); Navigator.pop(context); } },
          child: const Text('افزودن'),
        ),
      ]),
    ));
  }
}
