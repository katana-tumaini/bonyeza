import 'package:flutter/material.dart';
import 'game_button.dart';
import 'counter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text('bonyeza',
        style: TextStyle(
          fontFamily: 'PressStart',
          fontSize: 14,
        ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: Counter()),
          ),
        ],
      ),
      body: Center(
        child: GameButton(
          text: 'Tap the button',
          onPressed: () {},
        ),
      ),
    );
  }
}  