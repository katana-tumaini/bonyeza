import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final int count;

  const Counter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Score: $count',
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'PressStart',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}