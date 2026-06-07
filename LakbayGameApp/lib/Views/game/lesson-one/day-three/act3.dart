import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';

class LessonOneDayThreeActThree extends StatelessWidget {
  const LessonOneDayThreeActThree({super.key});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/lesson-two-day3-act3.png',
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
            top: clampDouble(size.height * 0.025, 14, 22),
            right: clampDouble(size.width * 0.04, 12, 20),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Lesson1Screen()),
                );
              },
              child: Container(
                width: clampDouble(size.width * 0.14, 50, 70),
                height: clampDouble(size.width * 0.14, 50, 70),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: clampDouble(size.width * 0.08, 28, 40),
                ),
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.50,
            right: 45,
            child: missionButton(
              context,
              onTap: () {
                print('Mission 1');
              },
            ),
          ),

          Positioned(
            top: size.height * 0.61,
            right: 45,
            child: missionButton(
              context,
              onTap: () {
                print('Mission 2');
              },
            ),
          ),

          Positioned(
            top: size.height * 0.72,
            right: 45,
            child: missionButton(
              context,
              onTap: () {
                print('Mission 3');
              },
            ),
          ),

          Positioned(
            top: size.height * 0.82,
            right: 45,
            child: missionButton(
              context,
              onTap: () {
                print('Mission 4');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget missionButton(BuildContext context, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFFB7F300), Color(0xFF5EAE00)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: Color(0xFF3D7500), width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Color(0xFF5EAE00),
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'BUKSAN\nANG MISYON',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  height: 1,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
