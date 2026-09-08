import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

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