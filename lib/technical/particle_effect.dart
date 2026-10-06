import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double velocityX;
  final double velocityY;
  final double life;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.velocityX,
    required this.velocityY,
    required this.life,
  });

  Particle copyWith({
    double? x,
    double? y,
    double? size,
    Color? color,
    double? velocityX,
    double? velocityY,
    double? life,
  }) {
    return Particle(
      x: x ?? this.x,
      y: y ?? this.y,
      size: size ?? this.size,
      color: color ?? this.color,
      velocityX: velocityX ?? this.velocityX,
      velocityY: velocityY ?? this.velocityY,
      life: life ?? this.life,
    );
  }
}

class ParticleEffect extends StatefulWidget {
  final double x;
  final double y;
  final Color color;
  final VoidCallback? onComplete;

  const ParticleEffect({
    super.key,
    required this.x,
    required this.y,
    required this.color,
    this.onComplete,
  });

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create particles
    for (int i = 0; i < 12; i++) {
      final angle = _random.nextDouble() * 2 * 3.14159;
      final speed = 2.0 + _random.nextDouble() * 3.0;
      _particles.add(Particle(
        x: widget.x,
        y: widget.y,
        size: 4.0 + _random.nextDouble() * 6.0,
        color: widget.color,
        velocityX: cos(angle) * speed,
        velocityY: sin(angle) * speed,
        life: 1.0,
      ));
    }

    _controller.forward();
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          // Update particle positions and life
          for (int i = 0; i < _particles.length; i++) {
            final particle = _particles[i];
            _particles[i] = particle.copyWith(
              x: particle.x + particle.velocityX,
              y: particle.y + particle.velocityY,
              life: 1.0 - _controller.value,
            );
          }
        });
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isCompleted = true;
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: _particles.map((particle) {
        return Positioned(
          left: particle.x - particle.size / 2,
          top: particle.y - particle.size / 2,
          child: Opacity(
            opacity: particle.life.clamp(0.0, 1.0),
            child: Container(
              width: particle.size,
              height: particle.size,
              decoration: BoxDecoration(
                color: particle.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
