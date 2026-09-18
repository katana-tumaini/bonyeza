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
  Offset _buttonPosition = Offset(100, 100);
  
  // Controls whether the hint is visible
  bool _showHint = true;

  // Controls whether the actual game has started
  bool _gameStarted = false;
  
  void _buttonPressed() {
    setState (() {
    gameLogic.incrementScore();
    });
  }

  void _moveButton(double maxWidth, double maxHeight) {
    setState(() {
      _buttonPosition = gameLogic.moveButtonRandom(
        maxWidth,
        maxHeight,
        gameLogic.calculateButtonSize,
      );
    });
  }

  void _startGame() {
    setState(() {
      _showHint = false;
      _gameStarted = true;
    });
  }

  void _restartGame() {
    setState(() {
      gameLogic.resetScore();
      _gameStarted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],

        title: const Text(
          'bonyeza',
          style: TextStyle(
            fontFamily: 'PressStart',
            fontSize: 14,
          ),
        ),

        actions: [
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
          // Move button to random position within available space when game starts
          if (_gameStarted && _buttonPosition == const Offset(100, 100)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _moveButton(constraints.maxWidth, constraints.maxHeight);
            });
          }

          return Stack(
        children: [

          if (_gameStarted)
            AnimatedPositioned(
              duration: Duration(
                milliseconds: (400 / gameLogic.calculateSpeed(
                  gameLogic.getScore(),
                )).round(),
              ),
              curve: Curves.easeInOut,
              left: _buttonPosition.dx,
              top: _buttonPosition.dy,
              child: GameButton(
                onPressed: () {
                  _buttonPressed();
                  _moveButton(constraints.maxWidth, constraints.maxHeight);
                },
                width: gameLogic.calculateButtonSize,
                height: gameLogic.calculateButtonSize,
              ),
            ),

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
                        'Tap the button\nto score points!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.yellow,
                          fontFamily: 'PressStart',
                          fontSize: 14,
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
        ],
          );
        }
      ),
    );
  }
}