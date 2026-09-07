import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ],
        ),
      ),
    );
  }
}