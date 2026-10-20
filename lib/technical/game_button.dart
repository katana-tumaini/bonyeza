import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final BoxShape? shape;
  final double? borderWidth;
  final Color? borderColor;
  final bool isRainbow;

  const GameButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.width,
    this.height,
    this.shape,
    this.borderWidth,
    this.borderColor,
    this.isRainbow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? 100,
        height: height ?? 100,

        decoration: BoxDecoration(
          color: isRainbow ? null : (backgroundColor ?? const Color(0xFF4ECDC4)),
          gradient: isRainbow
              ? const LinearGradient(
                  colors: [
                    Color(0xFFFF0000),
                    Color(0xFFFF7F00),
                    Color(0xFFFFFF00),
                    Color(0xFF00FF00),
                    Color(0xFF0000FF),
                    Color(0xFF4B0082),
                    Color(0xFF9400D3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          shape: shape ?? BoxShape.circle,
          borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(12) : null,
          border: Border.all(
            color: borderColor ?? Colors.black,
            width: borderWidth ?? 4,
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
