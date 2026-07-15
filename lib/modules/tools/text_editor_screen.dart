import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class TextEditorScreen extends StatefulWidget {
  const TextEditorScreen({super.key});

  @override
  State<TextEditorScreen> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  final _controller = TextEditingController();
  int _characters = 0;
  int _words = 0;
  int _lines = 0;
  int _paragraphs = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ویرایشگر متن'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyText,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _controller.clear();
              _updateStats('');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('کاراکتر', _characters),
                _buildStat('کلمه', _words),
                _buildStat('خط', _lines),
                _buildStat('پاراگراف', _paragraphs),
              ],
            ),
          ),
          const Divider(height: 1),

          // Text Editor
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              onChanged: _updateStats,
              decoration: const InputDecoration(
                hintText: 'متن خود را اینجا بنویسید...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(AppDimensions.lg),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  void _updateStats(String text) {
    setState(() {
      _characters = text.length;
      _words = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
      _lines = text.isEmpty ? 0 : text.split('\n').length;
      _paragraphs = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\n\s*\n')).length;
    });
  }

  void _copyText() {
    if (_controller.text.isNotEmpty) {
      // Use clipboard package
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('متن کپی شد')),
      );
    }
  }
}
