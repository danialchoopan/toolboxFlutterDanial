import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/persian_numbers.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';
  final List<String> _history = [];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ماشین حساب'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showHistory,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => setState(() {
              _expression = '';
              _result = '';
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          // Display
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.xl),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    PersianNumbers.toPersian(_expression.isEmpty ? '۰' : _expression),
                    style: TextStyle(
                      fontSize: _expression.length > 15 ? 24 : 32,
                      fontWeight: FontWeight.w300,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  if (_result.isNotEmpty)
                    Text(
                      '= ${PersianNumbers.toPersian(_result)}',
                      style: TextStyle(
                        fontSize: _result.length > 15 ? 32 : 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.turquoise,
                      ),
                      textAlign: TextAlign.left,
                    ),
                ],
              ),
            ),
          ),

          // Buttons
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.sm),
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
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((btn) => Expanded(
          child: _buildButton(btn),
        )).toList(),
      ),
    );
  }

  Widget _buildButton(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOperator = ['+', '-', '×', '÷', '='].contains(text);
    final isSpecial = ['C', '⌫', '%', '±'].contains(text);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
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
                color: isOperator
                    ? Colors.white
                    : isSpecial
                        ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        _expression = '';
        _result = '';
      } else if (text == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (text == '=') {
        _calculate();
      } else if (text == '±') {
        if (_expression.isNotEmpty) {
          if (_expression.startsWith('-')) {
            _expression = _expression.substring(1);
          } else {
            _expression = '-$_expression';
          }
        }
      } else if (text == '%') {
        _expression += '/100';
      } else {
        _expression += text;
      }
    });
  }

  void _calculate() {
    try {
      var expr = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/');

      // Simple expression evaluator
      final result = _evaluate(expr);
      _result = result.toStringAsFixed(result == result.roundToDouble() ? 0 : 6);
      _history.insert(0, '$_expression = $_result');
      if (_history.length > 20) _history.removeLast();
    } catch (e) {
      _result = 'خطا';
    }
  }

  double _evaluate(String expression) {
    // Simple parser for basic operations
    final tokens = _tokenize(expression);
    return _parseExpression(tokens, 0).$1;
  }

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

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تاریخچه',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.md),
            Expanded(
              child: _history.isEmpty
                  ? const Center(child: Text('تاریخچه خالی است'))
                  : ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          PersianNumbers.toPersian(_history[index]),
                          textDirection: TextDirection.ltr,
                        ),
                        onTap: () {
                          setState(() {
                            _result = _history[index].split(' = ')[1];
                          });
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
