import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class WordCounterScreen extends StatelessWidget {
  const WordCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('شمارش کلمات'),
      ),
      body: const Center(
        child: Text('شمارش کلمات و کاراکترها'),
      ),
    );
  }
}
