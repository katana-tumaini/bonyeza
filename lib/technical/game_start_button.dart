import 'package:flutter/material.dart';

class GameStartButton extends StatefulWidget {
  final VoidCallback onPressed;

  const GameStartButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<GameStartButton> createState() => _GameStartButtonState();
}

class _GameStartButtonState extends State<GameStartButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });

        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 220,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(0, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'START!',
              style: TextStyle(
                fontFamily: 'PressStart',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}