import 'dart:math';
import 'package:flutter/material.dart';

class GameLogic {
  int score = 0;
   
  void incrementScore() {
    score++;
  }
  
  void resetScore() {
    score = 0;
  }
  
  int getScore() {
    return score;
  }

  Offset moveButtonRandom(double width, double height, double buttonSize) {
    final random = Random();
    
    // Calculate max position to keep button fully visible
    final maxX = (width - buttonSize).clamp(0.0, double.infinity);
    final maxY = (height - buttonSize).clamp(0.0, double.infinity);
    
    return Offset(
      random.nextDouble() * maxX,
      random.nextDouble() * maxY,
    );
  }

  // Movement speed increases every 5 points
  double calculateSpeed(int score) {
    return 1.0 + (score ~/ 5) * 0.2;
  }

  // Button gets smaller every 5 points
  double get calculateButtonSize {
    return (100.0 - ((score ~/ 5) * 10)).clamp(50.0, 100.0);
  }

  // Button stays visible for less time every 5 points
  Duration get buttonDuration {
    final milliseconds = 2000 - ((score ~/ 5) * 200);

    return Duration(
      milliseconds: milliseconds.clamp(600, 2000),
    );
  }
}
