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

  Offset moveButtonRandom(double width, double height) {
    final random = Random();
    
    return Offset(
      random.nextDouble() * (width - 100),
      random.nextDouble() * (height - 100),
    );
  }
}
