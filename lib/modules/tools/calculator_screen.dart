import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/persian_numbers.dart';

/// Scientific calculator with Persian digit support and expression parsing.
///
/// Features:
/// - Responsive layout (desktop: side-by-side, mobile: stacked)
/// - Expression history with recall
/// - Basic operations: +, -, ×, ÷, %, ±
/// - Persian number display (۰-۹)
/// - Recursive descent parser for order of operations
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';   // Current expression being built
  String _result = '';       // Last calculated result
  final List<String> _history = []; // Calculation history

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ماشین حساب'),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: _showHistory),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => setState(() { _expression = ''; _result = ''; }),
          ),
        ],
      ),
      // Responsive: desktop gets side-by-side layout, mobile gets stacked
      body: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
    );
  }

  /// Desktop layout: history panel on left, calculator on right
  Widget _buildDesktopLayout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        // Left panel: calculation history
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تاریخچه', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                const SizedBox(height: 16),
                Expanded(
                  child: _history.isEmpty
                      ? Center(child: Text('تاریخچه خالی', style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          itemCount: _history.length,
                          itemBuilder: (context, index) => Card(
                            child: ListTile(
                              title: Text(PersianNumbers.toPersian(_history[index]), textDirection: TextDirection.ltr),
                              dense: true,
                              onTap: () => setState(() => _result = _history[index].split(' = ')[1]),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        Container(width: 1, color: Colors.grey[300]),
        // Right panel: calculator buttons and display
        Expanded(flex: 3, child: _buildCalculatorBody(context)),
      ],
    );
  }

  /// Mobile layout: full-screen calculator
  Widget _buildMobileLayout(BuildContext context) => _buildCalculatorBody(context);

  /// Core calculator UI with display and button grid
  Widget _buildCalculatorBody(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // ─── Expression Display ───
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightSurface),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Current expression (shrinks font for long expressions)
                Text(
                  PersianNumbers.toPersian(_expression.isEmpty ? '۰' : _expression),
                  style: TextStyle(
                    fontSize: _expression.length > 15 ? 24 : 32,
                    fontWeight: FontWeight.w300,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 8),
                // Result (shown after pressing =)
                if (_result.isNotEmpty)
                  Text(
                    '= ${PersianNumbers.toPersian(_result)}',
                    style: TextStyle(
                      fontSize: _result.length > 15 ? 32 : 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.turquoise,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
              ],
            ),
          ),
        ),
        // ─── Button Grid ───
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            child: Column(
              children: [
                _buildButtonRow(['C', '⌫', '%', '÷']),
                _buildButtonRow(['7', '8', '9', '×']),
                _buildButtonRow(['4', '5', '6', '-']),
                _buildButtonRow(['1', '2', '3', '+']),
                _buildButtonRow(['±', '0', '.', '=']),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Creates a row of calculator buttons
  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((btn) => Expanded(child: _buildButton(btn))).toList(),
      ),
    );
  }

  /// Individual calculator button with appropriate styling
  Widget _buildButton(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOperator = ['+', '-', '×', '÷', '='].contains(text);
    final isSpecial = ['C', '⌫', '%', '±'].contains(text);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        // Operators get turquoise, special buttons get grey, numbers get white/dark
        color: isOperator
            ? AppColors.turquoise
            : isSpecial
                ? (isDark ? Colors.grey[800] : Colors.grey[300])
                : (isDark ? AppColors.darkCard : Colors.white),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _onButtonPressed(text),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: isOperator ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles button press events and updates expression/result
  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        // Clear everything
        _expression = '';
        _result = '';
      } else if (text == '⌫') {
        // Backspace: remove last character
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (text == '=') {
        // Evaluate the expression
        _calculate();
      } else if (text == '±') {
        // Toggle positive/negative
        _expression = _expression.startsWith('-') ? _expression.substring(1) : '-$_expression';
      } else if (text == '%') {
        // Convert percentage to division by 100
        _expression += '/100';
      } else {
        // Append digit or operator to expression
        _expression += text;
      }
    });
  }

  /// Evaluates the expression using recursive descent parser
  void _calculate() {
    try {
      // Convert display operators to math operators
      var expr = _expression.replaceAll('×', '*').replaceAll('÷', '/');
      final result = _evaluate(expr);
      // Format: no decimals for whole numbers, 6 decimal places otherwise
      _result = result.toStringAsFixed(result == result.roundToDouble() ? 0 : 6);
      // Add to history
      _history.insert(0, '$_expression = $_result');
      if (_history.length > 20) _history.removeLast();
    } catch (e) {
      _result = 'خطا'; // Error state
    }
  }

  /// Tokenizes and evaluates a math expression string.
  ///
  /// Uses recursive descent parsing to handle operator precedence:
  /// 1. Addition/Subtraction (lowest precedence)
  /// 2. Multiplication/Division
  /// 3. Unary minus/plus and numbers (highest precedence)
  double _evaluate(String expression) {
    final tokens = _tokenize(expression);
    return _parseExpression(tokens, 0).$1;
  }

  /// Breaks expression string into tokens (numbers and operators)
  List<String> _tokenize(String expr) {
    final tokens = <String>[];
    var current = '';
    for (var i = 0; i < expr.length; i++) {
      final c = expr[i];
      if (c == '+' || c == '-' || c == '*' || c == '/') {
        if (current.isNotEmpty) tokens.add(current);
        tokens.add(c);
        current = '';
      } else {
        current += c;
      }
    }
    if (current.isNotEmpty) tokens.add(current);
    return tokens;
  }

  /// Parses addition and subtraction (lowest precedence)
  (double, int) _parseExpression(List<String> tokens, int startPos) {
    var result = _parseTerm(tokens, startPos);
    var left = result.$1;
    var pos = result.$2;
    while (pos < tokens.length && (tokens[pos] == '+' || tokens[pos] == '-')) {
      final op = tokens[pos];
      final rightResult = _parseTerm(tokens, pos + 1);
      left = op == '+' ? left + rightResult.$1 : left - rightResult.$1;
      pos = rightResult.$2;
    }
    return (left, pos);
  }

  /// Parses multiplication and division (higher precedence)
  (double, int) _parseTerm(List<String> tokens, int startPos) {
    var result = _parseFactor(tokens, startPos);
    var left = result.$1;
    var pos = result.$2;
    while (pos < tokens.length && (tokens[pos] == '*' || tokens[pos] == '/')) {
      final op = tokens[pos];
      final rightResult = _parseFactor(tokens, pos + 1);
      left = op == '*' ? left * rightResult.$1 : left / rightResult.$1;
      pos = rightResult.$2;
    }
    return (left, pos);
  }

  /// Parses numbers and unary operators (highest precedence)
  (double, int) _parseFactor(List<String> tokens, int pos) {
    if (pos < tokens.length && tokens[pos] == '-') {
      final (val, newPos) = _parseFactor(tokens, pos + 1);
      return (-val, newPos);
    }
    if (pos < tokens.length && tokens[pos] == '+') {
      return _parseFactor(tokens, pos + 1);
    }
    if (pos < tokens.length) {
      return (double.parse(tokens[pos]), pos + 1);
    }
    return (0, pos);
  }

  /// Shows calculation history in a bottom sheet
  void _showHistory() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تاریخچه', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: _history.isEmpty
                  ? const Center(child: Text('تاریخچه خالی است'))
                  : ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(PersianNumbers.toPersian(_history[index]), textDirection: TextDirection.ltr),
                        onTap: () {
                          setState(() => _result = _history[index].split(' = ')[1]);
                          Navigator.pop(context);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
