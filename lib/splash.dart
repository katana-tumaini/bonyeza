import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/step_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/emergency-stopp.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 40),
              const Text(
                'bonyeza',
                style: TextStyle(
                  fontFamily: 'PressStart',
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 120),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'start!',
                    speed: const Duration(milliseconds: 500),
                    textStyle: const TextStyle(
                      fontFamily: 'PressStart',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
                repeatForever: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}