import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MindMapNode {
  String id;
  String text;
  double x;
  double y;
  Color color;
  List<String> childrenIds;

  MindMapNode({
    required this.id,
    required this.text,
    this.x = 0,
    this.y = 0,
    this.color = AppColors.turquoise,
    this.childrenIds = const [],
  });
}

class MindMapScreen extends StatefulWidget {
  const MindMapScreen({super.key});

  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen> {
  final List<MindMapNode> _nodes = [];
  String? _selectedNodeId;
  String? _draggingNodeId;
  Offset _offset = Offset.zero;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    // Create default central node
    _nodes.add(MindMapNode(
      id: 'root',
      text: 'موضوع اصلی',
      x: 0,
      y: 0,
      color: AppColors.persianBlue,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نقشه ذهنی'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _addNode,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteSelectedNode,
          ),
        ],
      ),
      body: GestureDetector(
        onScaleUpdate: (details) {
          setState(() {
            _scale = details.scale;
            _offset += details.focalPointDelta;
          });
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: _MindMapPainter(
            nodes: _nodes,
            offset: _offset,
            scale: _scale,
            selectedNodeId: _selectedNodeId,
          ),
        ),
      ),
    );
  }

  void _addNode() {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('افزودن گره', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'متن'),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    final random = DateTime.now().millisecondsSinceEpoch;
                    final colors = [AppColors.turquoise, AppColors.coral, AppColors.dailyToolsColor, AppColors.mint, AppColors.rose];
                    _nodes.add(MindMapNode(
                      id: '$random',
                      text: controller.text,
                      x: 100 + (random % 200) - 100,
                      y: 100 + (random % 200) - 100,
                      color: colors[random % colors.length],
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

  void _deleteSelectedNode() {
    if (_selectedNodeId != null && _selectedNodeId != 'root') {
      setState(() {
        _nodes.removeWhere((n) => n.id == _selectedNodeId);
        _selectedNodeId = null;
      });
    }
  }
}

class _MindMapPainter extends CustomPainter {
  final List<MindMapNode> nodes;
  final Offset offset;
  final double scale;
  final String? selectedNodeId;

  _MindMapPainter({
    required this.nodes,
    required this.offset,
    required this.scale,
    this.selectedNodeId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw connections
    final linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final node in nodes) {
      final nodeCenter = center + Offset(node.x * scale, node.y * scale) + offset;
      for (final childId in node.childrenIds) {
        final child = nodes.firstWhere((n) => n.id == childId, orElse: () => node);
        final childCenter = center + Offset(child.x * scale, child.y * scale) + offset;
        canvas.drawLine(nodeCenter, childCenter, linePaint);
      }
    }

    // Draw nodes
    for (final node in nodes) {
      final nodeCenter = center + Offset(node.x * scale, node.y * scale) + offset;
      final isSelected = node.id == selectedNodeId;
      final radius = node.id == 'root' ? 50.0 : 35.0;

      // Shadow
      final shadowPaint = Paint()
        ..color = node.color.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(nodeCenter, radius, shadowPaint);

      // Node circle
      final nodePaint = Paint()
        ..color = node.color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(nodeCenter, radius, nodePaint);

      // Selection border
      if (isSelected) {
        final selectPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        canvas.drawCircle(nodeCenter, radius + 4, selectPaint);
      }

      // Text
      final textPainter = TextPainter(
        text: TextSpan(
          text: node.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: node.id == 'root' ? 14 : 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(nodeCenter.dx - textPainter.width / 2, nodeCenter.dy - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
