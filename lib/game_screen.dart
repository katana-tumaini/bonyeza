import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bonyeza/technical/game_button.dart';
import 'package:bonyeza/technical/counter.dart';
import 'package:bonyeza/logic/game_logic.dart';
import 'package:bonyeza/technical/audio_manager.dart';
import 'package:bonyeza/technical/particle_effect.dart';
import 'package:bonyeza/technical/high_score_manager.dart';
import 'package:bonyeza/technical/settings_manager.dart';
import 'package:bonyeza/technical/background_music.dart';
import 'package:bonyeza/settings_screen.dart';
import 'package:bonyeza/technical/background_music.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameLogic gameLogic = GameLogic();
  final AudioManager _audioManager = AudioManager();
  final BackgroundMusic _backgroundMusic = BackgroundMusic();

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _loadSettings();
  }

  Future<void> _loadHighScore() async {
    final highScore = await HighScoreManager.getHighScore();
    setState(() {
      _highScore = highScore;
    });
  }

  Future<void> _loadSettings() async {
    final audioEnabled = await SettingsManager.getAudioEnabled();
    final hapticsEnabled = await SettingsManager.getHapticsEnabled();
    setState(() {
      _audioEnabled = audioEnabled;
      _hapticsEnabled = hapticsEnabled;
    });
    // Reload audio manager settings
    await _audioManager.reloadSettings();

    // Initialize background music using the saved setting
    await _backgroundMusic.initialize();
  }
  
  List<Offset> _buttonPositions = [];
  
  // Controls whether the hint is visible
  bool _showHint = true;

  // Controls whether the actual game has started
  bool _gameStarted = false;
  
  // Controls whether the game is over
  bool _gameOver = false;

  // Controls whether the game is paused
  bool _isPaused = false;
  
  // Timer for button timeout
  Timer? _buttonTimer;
  
  // Timer for countdown display
  Timer? _countdownTimer;
  
  // Remaining time for display
  int _remainingTime = 0;
  
  // Store screen constraints for button positioning
  Size _screenSize = Size.zero;

  // Track active particle effects with unique keys
  final Map<int, Widget> _particleEffects = {};
  int _particleEffectCounter = 0;
  
  // Background color state
  Color _backgroundColor = Colors.blue[50]!;

  // High score
  int _highScore = 0;

  // Settings
  bool _audioEnabled = true;
  bool _hapticsEnabled = true;
  bool _showSettings = false;
  
  // List of background colors to cycle through on game over
  final List<Color> _gameOverColors = [
    Colors.red[50]!,
    Colors.orange[50]!,
    Colors.yellow[50]!,
    Colors.green[50]!,
    Colors.teal[50]!,
    Colors.purple[50]!,
    Colors.pink[50]!,
    Colors.grey[200]!,
  ];
  
  // Current color index for game over
  int _colorIndex = 0;
  
  void _buttonPressed(int buttonIndex) {
    if (_isPaused) return; // Prevent button presses when paused

    _audioManager.playTapSound();

    // Haptic feedback
    if (_hapticsEnabled) {
      HapticFeedback.lightImpact();
    }

    gameLogic.clickButton(buttonIndex);

    // Add particle effect at button position
    if (buttonIndex < _buttonPositions.length) {
      final position = _buttonPositions[buttonIndex];
      final buttonSize = gameLogic.calculateButtonSize;
      final centerX = position.dx + buttonSize / 2;
      final centerY = position.dy + buttonSize / 2;

      final effectKey = _particleEffectCounter++;
      setState(() {
        _particleEffects[effectKey] = ParticleEffect(
          key: ValueKey('particle_$effectKey'),
          x: centerX,
          y: centerY,
          color: const Color(0xFF4ECDC4),
          onComplete: () {
            setState(() {
              _particleEffects.remove(effectKey);
            });
          },
        );
      });
    }

    setState(() {});

    // Check if all buttons have been clicked
    if (gameLogic.allButtonsClicked()) {
      // All buttons clicked - increment score and start new round
      final buttonCount = gameLogic.getClickedCount();
      gameLogic.incrementScore(buttonCount);
      _buttonTimer?.cancel();

      // End morph state after the morphed round is complete
      if (gameLogic.isMorphed) {
        gameLogic.endMorph();
      } else {
        // Check if game should morph back to one big button
        if (gameLogic.shouldMorphToBigButton()) {
          gameLogic.morphToBigButton();
        }
      }

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
      if (gameLogic.score == 0) {
        _backgroundColor = Colors.blue[50]!;
      }
      _startButtonTimer();
    });
  }

  void _restartGame() {
    setState(() {
      gameLogic.resetScore();
      _gameStarted = true;
      _gameOver = false;
      _isPaused = false;
      _buttonTimer?.cancel();
      _buttonPositions = [];
      _startButtonTimer();
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _buttonTimer?.cancel();
        _countdownTimer?.cancel();
      } else {
        // Resume timer with remaining time
        _buttonTimer = Timer(Duration(milliseconds: _remainingTime), _onTimeout);
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
    _audioManager.playGameOverSound();

    // Save high score
    HighScoreManager.saveHighScore(gameLogic.score).then((_) {
      _loadHighScore();
    });

    setState(() {
      _gameOver = true;
      _buttonTimer?.cancel();
      // Change background color on game over (will be applied when they restart)
      _backgroundColor = _gameOverColors[_colorIndex];
      _colorIndex = (_colorIndex + 1) % _gameOverColors.length;
    });
  }
  
  @override
  void dispose() {
    _buttonTimer?.cancel();
    _countdownTimer?.cancel();
    _audioManager.dispose();
    _backgroundMusic.dispose();
    super.dispose();
  }
  
  String _getColorName(Color color) {
    if (color == Colors.red[50]) return 'Red';
    if (color == Colors.orange[50]) return 'Orange';
    if (color == Colors.yellow[50]) return 'Yellow';
    if (color == Colors.green[50]) return 'Green';
    if (color == Colors.teal[50]) return 'Teal';
    if (color == Colors.purple[50]) return 'Purple';
    if (color == Colors.pink[50]) return 'Pink';
    if (color == Colors.grey[200]) return 'Grey';
    return 'Blue';
  }

  @override
  Widget build(BuildContext context) {
    // Show settings screen if requested
    if (_showSettings) {
      return SettingsScreen(
        onBack: () {
          setState(() {
            _showSettings = false;
          });
          _loadSettings(); // Reload settings after returning
        },
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'bonyeza',
              style: TextStyle(
                fontFamily: 'PressStart',
                fontSize: 10,
              ),
            ),
            if (_gameStarted && !_gameOver && !_isPaused)
              Text(
                '${(_remainingTime / 1000).toStringAsFixed(1)}s',
                style: const TextStyle(
                  fontFamily: 'PressStart',
                  fontSize: 10,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              const SizedBox.shrink(),
            Row(
              children: [
                if (_gameStarted && !_gameOver && !_isPaused && gameLogic.buttonClicked.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      '${gameLogic.getClickedCount()}/${gameLogic.buttonClicked.length}',
                      style: const TextStyle(
                        fontFamily: 'PressStart',
                        fontSize: 10,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Counter(count: gameLogic.score),
                if (_gameStarted && !_gameOver)
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: IconButton(
                      icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                      onPressed: _togglePause,
                      color: Colors.black,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      setState(() {
                        _showSettings = true;
                      });
                    },
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),

        centerTitle: false,
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
          // Particle effects layer
          ..._particleEffects.values,

          if (_gameStarted && !_gameOver && !_isPaused)
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

                color: Colors.black.withOpacity(0.7),

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

                      const SizedBox(height: 15),

                      Text(
                        'High Score: $_highScore',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontFamily: 'PressStart',
                          fontSize: 14,
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

          if (_isPaused)
            GestureDetector(
              behavior: HitTestBehavior.opaque,

              onTap: _togglePause,

              child: Container(
                width: double.infinity,
                height: double.infinity,

                color: Colors.black.withOpacity(0.5),

                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        'PAUSED',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PressStart',
                          fontSize: 24,
                        ),
                      ),

                      SizedBox(height: 40),

                      Text(
                        'Tap to resume',
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