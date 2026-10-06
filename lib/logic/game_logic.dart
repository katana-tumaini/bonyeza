import 'dart:math';
import 'package:flutter/material.dart';

class GameLogic {
  int score = 0;
  List<Offset> buttonPositions = [];
  List<bool> buttonClicked = []; // Track which buttons have been clicked
  final Random _random = Random();
  bool _isMorphed = false; // Track if currently in morphed state
   
  void incrementScore(int points) {
    score += points;
  }
  
  void resetScore() {
    score = 0;
    buttonPositions = [];
    buttonClicked = [];
    _isMorphed = false;
  }
  
  int getScore() {
    return score;
  }
  
  // Mark a button as clicked
  void clickButton(int index) {
    if (index >= 0 && index < buttonClicked.length) {
      buttonClicked[index] = true;
    }
  }
  
  // Check if all buttons have been clicked
  bool allButtonsClicked() {
    return buttonClicked.every((clicked) => clicked);
  }
  
  // Get count of clicked buttons
  int getClickedCount() {
    return buttonClicked.where((clicked) => clicked).length;
  }
  
  // Reset clicked status for new round
  void resetClickedStatus(int count) {
    buttonClicked = List.filled(count, false);
  }

  // Calculate how many buttons should be displayed
  // Increases with score but randomly varies for unpredictability
  int getButtonCount() {
    if (_isMorphed) return 1; // Always 1 button when morphed
    
    if (score < 5) return 1; // Always 1 button for beginners

    // Base button count increases every 10 points
    int baseCount = 1 + (score ~/ 10);

    // Random variation: sometimes add extra buttons, sometimes reduce
    int variation = _random.nextInt(3) - 1; // -1, 0, or +1

    // 30% chance to suddenly drop to 1 button (surprise factor)
    if (_random.nextDouble() < 0.3 && score > 10) {
      return 1;
    }

    // Calculate final count with variation
    int finalCount = (baseCount + variation).clamp(1, 5);

    return finalCount;
  }

  // Move all buttons to random positions without overlapping
  List<Offset> moveAllButtonsRandom(double width, double height, double buttonSize, int count) {
    List<Offset> positions = [];
    final minDistance = buttonSize * 1.5; // Minimum distance between buttons
    
    for (int i = 0; i < count; i++) {
      Offset newPosition;
      int attempts = 0;
      bool validPosition = false;
      
      // Try to find a non-overlapping position
      while (!validPosition && attempts < 50) {
        newPosition = moveButtonRandom(width, height, buttonSize);
        
        // Check if this position overlaps with existing buttons
        bool overlaps = false;
        for (var existingPos in positions) {
          final distance = (newPosition - existingPos).distance;
          if (distance < minDistance) {
            overlaps = true;
            break;
          }
        }
        
        if (!overlaps) {
          validPosition = true;
          positions.add(newPosition);
        }
        
        attempts++;
      }
      
      // If we couldn't find a non-overlapping position, just add it anyway
      if (!validPosition) {
        positions.add(moveButtonRandom(width, height, buttonSize));
      }
    }
    
    buttonPositions = positions;
    resetClickedStatus(count);
    return positions;
  }

  Offset moveButtonRandom(double width, double height, double buttonSize) {
    // Calculate max position to keep button fully visible
    final maxX = (width - buttonSize).clamp(0.0, double.infinity);
    final maxY = (height - buttonSize).clamp(0.0, double.infinity);
    
    return Offset(
      _random.nextDouble() * maxX,
      _random.nextDouble() * maxY,
    );
  }

  // Movement speed increases every 5 points
  double calculateSpeed(int score) {
    return 1.0 + (score ~/ 5) * 0.2;
  }

  // Button gets smaller every 5 points
  double get calculateButtonSize {
    if (_isMorphed) {
      return 100.0; // Big button when morphed
    }
    return (100.0 - ((score ~/ 5) * 10)).clamp(50.0, 100.0);
  }

  // Button stays visible for less time every 5 points
  Duration get buttonDuration {
    if (_isMorphed) {
      return const Duration(milliseconds: 3000); // Longer duration when morphed
    }
    final milliseconds = 4000 - ((score ~/ 10) * 200);

    return Duration(
      milliseconds: milliseconds.clamp(600, 2000),
    );
  }

  // Check if game should morph back to one big button (random when extreme)
  bool shouldMorphToBigButton() {
    // Only check if game has progressed enough to be "extreme"
    if (score < 20) return false;

    // Check if we're at extreme conditions (minimum size or duration)
    bool isExtremeSize = calculateButtonSize <= 55.0; // Near minimum size
    bool isExtremeDuration = buttonDuration.inMilliseconds <= 700; // Near minimum duration

    // If extreme, 25% chance to morph back to one big button
    if (isExtremeSize || isExtremeDuration) {
      return _random.nextDouble() < 0.25;
    }

    return false;
  }

  // Morph back to one big button state
  void morphToBigButton() {
    // Set morphed state to give player a breather
    _isMorphed = true;
    buttonPositions = [];
    buttonClicked = [];
  }

  // Check if currently in morphed state
  bool get isMorphed => _isMorphed;

  // Call this after a morphed round to return to normal progression
  void endMorph() {
    _isMorphed = false;
  }
}
