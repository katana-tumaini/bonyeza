import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const GameButton({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? 100,
        height: height ?? 100,

        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFF4ECDC4),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
          ),
        ),
      ),
    );
  }
}
