import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MiniGamesScreen extends StatelessWidget {
  const MiniGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {'title': 'tic tac toe', 'fa': 'دوز', 'icon': Icons.grid_3x3, 'color': AppColors.turquoise},
      {'title': 'memory', 'fa': 'حافظه', 'icon': Icons.memory, 'color': AppColors.persianBlue},
      {'title': 'sudoku', 'fa': 'سودوکو', 'icon': Icons.grid_on, 'color': AppColors.coral},
      {'title': '2048', 'fa': '۲۰۴۸', 'icon': Icons.numbers, 'color': AppColors.dailyToolsColor},
      {'title': 'hangman', 'fa': 'مرد آویزان', 'icon': Icons.accessibility_new, 'color': AppColors.rose},
      {'title': 'puzzle', 'fa': 'پازل لغزشی', 'icon': Icons.extension, 'color': AppColors.mint},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('بازی‌های کوچک')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          final color = game['color'] as Color;
          return GestureDetector(
            onTap: () {
              if (game['title'] == 'tic tac toe') Navigator.push(context, MaterialPageRoute(builder: (_) => const TicTacToeGame()));
              else if (game['title'] == 'memory') Navigator.push(context, MaterialPageRoute(builder: (_) => const MemoryGame()));
              else if (game['title'] == '2048') Navigator.push(context, MaterialPageRoute(builder: (_) => const Game2048()));
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(game['icon'] as IconData, color: Colors.white, size: 40),
                const SizedBox(height: 12),
                Text(game['fa'] as String, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ]),
            ),
          );
        },
      ),
    );
  }
}

// ─── Tic Tac Toe ───
class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});
  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> _board = List.filled(9, '');
  bool _isXTurn = true;
  String _winner = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دوز')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(_winner.isEmpty ? (_isXTurn ? 'نوبت X' : 'نوبت O') : (_winner == 'draw' ? 'مساوی!' : '$_winner برنده شد!'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(
            width: 300, height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemCount: 9,
              itemBuilder: (context, i) => GestureDetector(
                onTap: () {
                  if (_board[i].isEmpty && _winner.isEmpty) {
                    setState(() {
                      _board[i] = _isXTurn ? 'X' : 'O';
                      _isXTurn = !_isXTurn;
                      _checkWinner();
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _board[i] == 'X' ? AppColors.turquoise.withOpacity(0.2) : _board[i] == 'O' ? AppColors.rose.withOpacity(0.2) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(_board[i], style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _board[i] == 'X' ? AppColors.turquoise : AppColors.rose))),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () => setState(() { _board = List.filled(9, ''); _isXTurn = true; _winner = ''; }), child: const Text('بازی جدید')),
        ]),
      ),
    );
  }

  void _checkWinner() {
    const wins = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]];
    for (final w in wins) {
      if (_board[w[0]].isNotEmpty && _board[w[0]] == _board[w[1]] && _board[w[1]] == _board[w[2]]) {
        setState(() => _winner = _board[w[0]]);
        return;
      }
    }
    if (!_board.contains('')) setState(() => _winner = 'draw');
  }
}

// ─── Memory Game ───
class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});
  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  final List<String> _emojis = ['🍎', '🍊', '🍋', '🍇', '🍉', '🍓', '🫐', '🥝'];
  late List<String> _cards;
  int? _firstIndex;
  int _moves = 0;
  int _matches = 0;

  @override
  void initState() {
    super.initState();
    _cards = [..._emojis, ..._emojis]..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بازی حافظه'), actions: [Padding(padding: const EdgeInsets.all(16), child: Text('حرکات: $_moves', style: const TextStyle(fontSize: 16)))]),
      body: Column(children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
            itemCount: _cards.length,
            itemBuilder: (context, i) {
              final isFlipped = _firstIndex == i || _matches > 0 && _cards[i] == '';
              return GestureDetector(
                onTap: () => _flipCard(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isFlipped && _cards[i].isNotEmpty ? Colors.white : AppColors.turquoise,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                  ),
                  child: Center(
                    child: Text(
                      isFlipped ? _cards[i] : '?',
                      style: TextStyle(fontSize: 32, color: isFlipped ? null : Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_matches == 8)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(onPressed: _reset, child: const Text('بازی جدید')),
          ),
      ]),
    );
  }

  void _flipCard(int i) {
    if (_firstIndex == null) {
      setState(() => _firstIndex = i);
    } else {
      setState(() => _moves++);
      if (_cards[_firstIndex!] == _cards[i]) {
        setState(() { _cards[_firstIndex!] = ''; _cards[i] = ''; _matches++; _firstIndex = null; });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () => setState(() => _firstIndex = null));
      }
    }
  }

  void _reset() {
    setState(() { _cards = [..._emojis, ..._emojis]..shuffle(); _firstIndex = null; _moves = 0; _matches = 0; });
  }
}

// ─── 2048 Game ───
class Game2048 extends StatefulWidget {
  const Game2048({super.key});
  @override
  State<Game2048> createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  List<List<int>> _grid = List.generate(4, (_) => List.filled(4, 0));
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _addRandom();
    _addRandom();
  }

  void _addRandom() {
    final empty = <Offset>[];
    for (var r = 0; r < 4; r++) {
      for (var c = 0; c < 4; c++) {
        if (_grid[r][c] == 0) empty.add(Offset(r.toDouble(), c.toDouble()));
      }
    }
    if (empty.isNotEmpty) {
      final pos = empty[Random().nextInt(empty.length)];
      _grid[pos.dx.toInt()][pos.dy.toInt()] = Random().nextBool() ? 2 : 4;
    }
  }

  void _slide(List<int> row) {
    final filtered = row.where((v) => v != 0).toList();
    for (var i = 0; i < filtered.length - 1; i++) {
      if (filtered[i] == filtered[i + 1]) { filtered[i] *= 2; _score += filtered[i]; filtered.removeAt(i + 1); }
    }
    while (filtered.length < 4) filtered.add(0);
    for (var i = 0; i < 4; i++) row[i] = filtered[i];
  }

  void _moveLeft() { for (var r = 0; r < 4; r++) _slide(_grid[r]); }
  void _moveRight() { for (var r = 0; r < 4; r++) { _grid[r] = _grid[r].reversed.toList(); _slide(_grid[r]); _grid[r] = _grid[r].reversed.toList(); } }
  void _moveUp() { for (var c = 0; c < 4; c++) { final col = [_grid[0][c], _grid[1][c], _grid[2][c], _grid[3][c]]; _slide(col); for (var r = 0; r < 4; r++) _grid[r][c] = col[r]; } }
  void _moveDown() { for (var c = 0; c < 4; c++) { final col = [_grid[3][c], _grid[2][c], _grid[1][c], _grid[0][c]]; _slide(col); for (var r = 0; r < 4; r++) _grid[r][c] = col[3 - r]; } }

  Color _tileColor(int value) {
    switch (value) { case 2: return Colors.amber[100]!; case 4: return Colors.amber[200]!; case 8: return Colors.orange[300]!; case 16: return Colors.orange[400]!; case 32: return Colors.deepOrange[400]!; case 64: return Colors.red[400]!; case 128: return Colors.yellow[700]!; case 256: return Colors.yellow[800]!; case 512: return Colors.amber[800]!; case 1024: return Colors.orange[900]!; case 2048: return Colors.deepOrange[900]!; default: return Colors.grey[300]!; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('۲۰۴۸'), actions: [Center(child: Padding(padding: const EdgeInsets.all(16), child: Text('امتیاز: $_score', style: const TextStyle(fontSize: 18))))]),
      body: Column(children: [
        Expanded(
          child: GestureDetector(
            onHorizontalDragEnd: (d) { if (d.primaryVelocity! > 0) _moveRight(); else _moveLeft(); setState(() { _addRandom(); }); },
            onVerticalDragEnd: (d) { if (d.primaryVelocity! > 0) _moveDown(); else _moveUp(); setState(() { _addRandom(); }); },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemCount: 16,
                itemBuilder: (context, i) {
                  final r = i ~/ 4, c = i % 4;
                  final val = _grid[r][c];
                  return Container(
                    decoration: BoxDecoration(color: _tileColor(val), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(val > 0 ? '$val' : '', style: TextStyle(fontSize: val >= 100 ? 24 : 32, fontWeight: FontWeight.bold, color: val >= 8 ? Colors.white : Colors.black87))),
                  );
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
