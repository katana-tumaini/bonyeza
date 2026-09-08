import 'package:flutter/material.dart';
import 'game_button.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GameButton(
          text: 'Start Game',
          onPressed: () {},
        ),
      ),
    );
  }
}  