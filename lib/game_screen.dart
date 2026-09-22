import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bonyeza/technical/game_button.dart';
import 'package:bonyeza/technical/counter.dart';
import 'package:bonyeza/logic/game_logic.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameLogic gameLogic = GameLogic();
  List<Offset> _buttonPositions = [];
  
  // Controls whether the hint is visible
  bool _showHint = true;

  // Controls whether the actual game has started
  bool _gameStarted = false;
  
  // Controls whether the game is over
  bool _gameOver = false;
  
  // Timer for button timeout
  Timer? _buttonTimer;
  
  // Timer for countdown display
  Timer? _countdownTimer;
  
  // Remaining time for display
  int _remainingTime = 0;
  
  // Store screen constraints for button positioning
  Size _screenSize = Size.zero;
  
  void _buttonPressed(int buttonIndex) {
    gameLogic.clickButton(buttonIndex);
    setState(() {});
    
    // Check if all buttons have been clicked
    if (gameLogic.allButtonsClicked()) {
      // All buttons clicked - increment score and start new round
      final buttonCount = gameLogic.getClickedCount();
      gameLogic.incrementScore(buttonCount);
      _buttonTimer?.cancel();
      _startButtonTimer();
      
      // Reposition buttons using stored screen dimensions
      if (_screenSize != Size.zero) {
        _moveAllButtons(_screenSize.width, _screenSize.height);
      }
    }
  }

  void _moveAllButtons(double maxWidth, double maxHeight) {
    setState(() {
      final buttonCount = gameLogic.getButtonCount();
      _buttonPositions = gameLogic.moveAllButtonsRandom(
        maxWidth,
        maxHeight,
        gameLogic.calculateButtonSize,
        buttonCount,
      );
    });
  }

  void _startGame() {
    setState(() {
      _showHint = false;
      _gameStarted = true;
      _gameOver = false;
      _startButtonTimer();
    });
  }

  void _restartGame() {
    setState(() {
      gameLogic.resetScore();
      _gameStarted = true;
      _gameOver = false;
      _buttonTimer?.cancel();
      _buttonPositions = [];
      _startButtonTimer();
    });
  }
  
  void _startButtonTimer() {
    _buttonTimer?.cancel();
    _countdownTimer?.cancel();
    
    _remainingTime = gameLogic.buttonDuration.inMilliseconds;
    
    _buttonTimer = Timer(gameLogic.buttonDuration, _onTimeout);
    
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _remainingTime -= 100;
        if (_remainingTime <= 0) {
          _remainingTime = 0;
          _countdownTimer?.cancel();
        }
      });
    });
  }
  
  void _onTimeout() {
    setState(() {
      _gameOver = true;
      _buttonTimer?.cancel();
    });
  }
  
  @override
  void dispose() {
    _buttonTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'bonyeza',
              style: TextStyle(
                fontFamily: 'PressStart',
                fontSize: 10,
              ),
            ),
            if (_gameStarted && !_gameOver) ...[
              const SizedBox(width: 6),
              Text(
                '${(_remainingTime / 1000).toStringAsFixed(1)}s',
                style: const TextStyle(
                  fontFamily: 'PressStart',
                  fontSize: 10,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),

        centerTitle: true,

        actions: [
          if (_gameStarted && !_gameOver && gameLogic.buttonClicked.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Center(
                child: Text(
                  '${gameLogic.getClickedCount()}/${gameLogic.buttonClicked.length}',
                  style: const TextStyle(
                    fontFamily: 'PressStart',
                    fontSize: 10,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Counter(count: gameLogic.score),
            ),
          ),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          // Store screen dimensions for button positioning
          _screenSize = Size(constraints.maxWidth, constraints.maxHeight);
          
          // Move buttons when positions are empty (game start or round complete)
          if (_gameStarted && _buttonPositions.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _moveAllButtons(constraints.maxWidth, constraints.maxHeight);
            });
          }

          return Stack(
        children: [

          if (_gameStarted && !_gameOver)
            ..._buttonPositions.asMap().entries.map((entry) {
              final index = entry.key;
              final position = entry.value;
              final isClicked = index < gameLogic.buttonClicked.length && gameLogic.buttonClicked[index];
              
              return AnimatedPositioned(
                key: ValueKey('button_$index'),
                duration: Duration(
                  milliseconds: (400 / gameLogic.calculateSpeed(
                    gameLogic.getScore(),
                  )).round(),
                ),
                curve: Curves.easeInOut,
                left: position.dx,
                top: position.dy,
                child: GameButton(
                  onPressed: isClicked ? null : () {
                    _buttonPressed(index);
                  },
                  backgroundColor: isClicked ? Colors.grey : null,
                  width: gameLogic.calculateButtonSize,
                  height: gameLogic.calculateButtonSize,
                ),
              );
            }),

          if (!_gameStarted)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Get ready...',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PressStart',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

          if (_gameStarted)
            Positioned(
              bottom: 30,
              left: 30,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: _restartGame,
                  child: const Text('↻'),
                ),
              ),
            ),

          if (_showHint)
            GestureDetector(
              behavior: HitTestBehavior.opaque,

              onTap: _startGame,

              child: Container(
                width: double.infinity,
                height: double.infinity,

                color: Colors.black.withOpacity(0.85),

                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        'HOW TO PLAY',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PressStart',
                          fontSize: 20,
                        ),
                      ),

                      SizedBox(height: 30),

                      Text(
                        'Tap ALL buttons\nto score points!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.yellow,
                          fontFamily: 'PressStart',
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        'Buttons multiply\nas you progress!\nClick them all\nbefore time runs out!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'PressStart',
                          fontSize: 12,
                        ),
                      ),

                      SizedBox(height: 40),

                      Text(
                        'Tap anywhere to start',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

          if (_gameOver)
            GestureDetector(
              behavior: HitTestBehavior.opaque,

              onTap: _restartGame,

              child: Container(
                width: double.infinity,
                height: double.infinity,

                color: Colors.black.withOpacity(0.85),

                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const Text(
                        'GAME OVER',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'PressStart',
                          fontSize: 24,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        'Score: ${gameLogic.getScore()}',
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontFamily: 'PressStart',
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        'Tap anywhere to restart',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
        ],
          );
        }
      ),
    );
  }
}