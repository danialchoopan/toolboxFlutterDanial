import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class Note {
  String id;
  String title;
  String content;
  List<String> tags;
  bool isLocked;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.tags = const [],
    this.isLocked = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Note> _notes = [];
  String _searchQuery = '';
  String _selectedTag = 'همه';

  List<Note> get _filteredNotes {
    return _notes.where((note) {
      if (_searchQuery.isNotEmpty &&
          !note.title.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !note.content.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_selectedTag != 'همه' && !note.tags.contains(_selectedTag)) return false;
      return true;
    }).toList();
  }

  List<String> get _allTags {
    final tags = <String>{};
    for (final note in _notes) {
      tags.addAll(note.tags);
    }
    return ['همه', ...tags];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('یادداشت‌ها'),
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'جستجوی یادداشت...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // Tags
          if (_allTags.length > 1)
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _allTags.length,
                itemBuilder: (context, index) {
                  final tag = _allTags[index];
                  final isSelected = tag == _selectedTag;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedTag = tag),
                      selectedColor: AppColors.turquoise,
                    ),
                  );
                },
              ),
            ),

          // Notes Grid
          Expanded(
            child: _filteredNotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_add_outlined, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('یادداشتی اضافه نشده', style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _filteredNotes.length,
                    itemBuilder: (context, index) => _buildNoteCard(_filteredNotes[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    final colors = [AppColors.turquoise, AppColors.persianBlue, AppColors.rose, AppColors.dailyToolsColor, AppColors.coral];
    final color = colors[note.id.hashCode.abs() % colors.length];

    return GestureDetector(
      onTap: () => _editNote(note),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (note.isLocked) Icon(Icons.lock, size: 16, color: color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    note.title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                note.content,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (note.tags.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: note.tags.take(3).map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(tag, style: TextStyle(fontSize: 8, color: color)),
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _addNote() {
    _editNote(Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      content: '',
    ));
  }

  void _editNote(Note note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);
    final tagsController = TextEditingController(text: note.tags.join(', '));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('یادداشت', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(note.isLocked ? Icons.lock : Icons.lock_open),
                        onPressed: () => setState(() => note.isLocked = !note.isLocked),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() => _notes.remove(note));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'عنوان'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'محتوا',
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'برچسب‌ها (با کاما جدا کنید)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    note.title = titleController.text;
                    note.content = contentController.text;
                    note.tags = tagsController.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
                    note.updatedAt = DateTime.now();
                    if (!_notes.contains(note)) {
                      _notes.insert(0, note);
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('ذخیره'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
