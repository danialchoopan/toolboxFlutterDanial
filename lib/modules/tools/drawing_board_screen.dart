import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DrawingBoardScreen extends StatefulWidget {
  const DrawingBoardScreen({super.key});

  @override
  State<DrawingBoardScreen> createState() => _DrawingBoardScreenState();
}

class _DrawingBoardScreenState extends State<DrawingBoardScreen> {
  final List<DrawnPath> _paths = [];
  final List<DrawnPath> _redoStack = [];
  Color _selectedColor = Colors.black;
  double _strokeWidth = 3;
  DrawingTool _currentTool = DrawingTool.brush;
  bool _isEraser = false;

  final List<Color> _palette = [
    Colors.black, Colors.white, Colors.red, Colors.pink, Colors.purple,
    Colors.deepPurple, Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
    Colors.teal, Colors.green, Colors.lightGreen, Colors.lime, Colors.yellow,
    Colors.amber, Colors.orange, Colors.deepOrange, Colors.brown, Colors.grey,
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تخته نقاشی'),
        actions: [
          IconButton(icon: const Icon(Icons.undo), onPressed: _paths.isNotEmpty ? _undo : null),
          IconButton(icon: const Icon(Icons.redo), onPressed: _redoStack.isNotEmpty ? _redo : null),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: _clear),
        ],
      ),
      body: isDesktop ? Row(children: [_buildCanvas(context), _buildToolbar(context)]) : Column(children: [Expanded(child: _buildCanvas(context)), _buildToolbar(context)]),
    );
  }

  Widget _buildCanvas(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: CustomPaint(
          painter: _DrawingPainter(paths: _paths, currentPath: _currentPath),
          size: Size.infinite,
          child: Container(color: Colors.white),
        ),
      ),
    );
  }

  DrawnPath? _currentPath;

  void _onPanStart(DragStartDetails details) {
    _currentPath = DrawnPath(
      points: [details.localPosition],
      color: _isEraser ? Colors.white : _selectedColor,
      strokeWidth: _isEraser ? _strokeWidth * 3 : _strokeWidth,
      tool: _currentTool,
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentPath?.points.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentPath != null) {
      setState(() {
        _paths.add(_currentPath!);
        _currentPath = null;
        _redoStack.clear();
      });
    }
  }

  Widget _buildToolbar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Container(
      width: isDesktop ? 220 : double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF21262D) : Colors.grey[100],
        border: isDesktop ? Border(left: BorderSide(color: Colors.grey[300]!)) : Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: isDesktop
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: _buildToolOptions())
          : SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: _buildToolOptions().map((w) => Padding(padding: const EdgeInsets.only(right: 8), child: w)).toList())),
    );
  }

  List<Widget> _buildToolOptions() {
    return [
      const Text('ابزار', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: [
        _toolBtn(Icons.brush, 'قلم‌مو', DrawingTool.brush),
        _toolBtn(Icons.line_style, 'خط', DrawingTool.line),
        _toolBtn(Icons.rectangle_outlined, 'مستطیل', DrawingTool.rectangle),
        _toolBtn(Icons.circle_outlined, 'دایره', DrawingTool.circle),
      ]),
      const SizedBox(height: 12),
      const Text('پاک‌کن', style: TextStyle(fontWeight: FontWeight.bold)),
      Switch(value: _isEraser, onChanged: (v) => setState(() => _isEraser = v), activeColor: Colors.orange),
      const SizedBox(height: 12),
      const Text('ضخامت', style: TextStyle(fontWeight: FontWeight.bold)),
      Slider(value: _strokeWidth, min: 1, max: 20, onChanged: (v) => setState(() => _strokeWidth = v)),
      const SizedBox(height: 12),
      const Text('رنگ', style: TextStyle(fontWeight: FontWeight.bold)),
      Wrap(spacing: 4, runSpacing: 4, children: _palette.map((c) => GestureDetector(
        onTap: () => setState(() { _selectedColor = c; _isEraser = false; }),
        child: Container(width: 28, height: 28, decoration: BoxDecoration(
          color: c, shape: BoxShape.circle,
          border: Border.all(color: _selectedColor == c ? Colors.blue : Colors.grey[300]!, width: _selectedColor == c ? 3 : 1),
        )),
      )).toList()),
    ];
  }

  Widget _toolBtn(IconData icon, String label, DrawingTool tool) {
    final isSelected = _currentTool == tool && !_isEraser;
    return GestureDetector(
      onTap: () => setState(() { _currentTool = tool; _isEraser = false; }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: isSelected ? Colors.blue : Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black), const SizedBox(width: 4), Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black))]),
      ),
    );
  }

  void _undo() { setState(() { if (_paths.isNotEmpty) { _redoStack.add(_paths.removeLast()); } }); }
  void _redo() { setState(() { if (_redoStack.isNotEmpty) { _paths.add(_redoStack.removeLast()); } }); }
  void _clear() { setState(() { _paths.clear(); _redoStack.clear(); }); }
}

enum DrawingTool { brush, line, rectangle, circle }

class DrawnPath {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final DrawingTool tool;

  DrawnPath({required this.points, required this.color, required this.strokeWidth, required this.tool});
}

class _DrawingPainter extends CustomPainter {
  final List<DrawnPath> paths;
  final DrawnPath? currentPath;

  _DrawingPainter({required this.paths, this.currentPath});

  @override
  void paint(Canvas canvas, Size size) {
    for (final path in paths) {
      _drawPath(canvas, path);
    }
    if (currentPath != null) {
      _drawPath(canvas, currentPath!);
    }
  }

  void _drawPath(Canvas canvas, DrawnPath path) {
    if (path.points.isEmpty) return;
    final paint = Paint()
      ..color = path.color
      ..strokeWidth = path.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (path.tool == DrawingTool.line && path.points.length >= 2) {
      canvas.drawLine(path.points.first, path.points.last, paint);
    } else if (path.tool == DrawingTool.rectangle && path.points.length >= 2) {
      final rect = Rect.fromPoints(path.points.first, path.points.last);
      canvas.drawRect(rect, paint);
    } else if (path.tool == DrawingTool.circle && path.points.length >= 2) {
      final center = Offset((path.points.first.dx + path.points.last.dx) / 2, (path.points.first.dy + path.points.last.dy) / 2);
      final radius = (path.points.first - path.points.last).distance / 2;
      canvas.drawCircle(center, radius, paint);
    } else {
      final uiPath = ui.Path()..moveTo(path.points.first.dx, path.points.first.dy);
      for (var i = 1; i < path.points.length; i++) {
        uiPath.lineTo(path.points[i].dx, path.points[i].dy);
      }
      canvas.drawPath(uiPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
