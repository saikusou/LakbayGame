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
    final w = size.width;
    final h = size.height;

    final double homeSize = clampDouble(w * 0.14, 48, 72);
    final double buttonWidth = clampDouble(w * 0.34, 115, 155);
    final double buttonHeight = clampDouble(h * 0.065, 45, 58);
    final double rightPosition = clampDouble(w * 0.11, 25, 50);

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/lesson-two-day3-act3.png',
                fit: BoxFit.fill,
              ),
            ),

            Positioned(
              top: clampDouble(h * 0.025, 14, 24),
              right: clampDouble(w * 0.04, 12, 22),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Lesson1Screen()),
                  );
                },
                child: Container(
                  width: homeSize,
                  height: homeSize,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: clampDouble(w * 0.01, 3, 5),
                    ),
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
                    size: clampDouble(homeSize * 0.55, 26, 40),
                  ),
                ),
              ),
            ),

            Positioned(
              top: h * 0.50,
              right: rightPosition,
              child: missionButton(
                width: buttonWidth,
                height: buttonHeight,
                onTap: () {
                  debugPrint('Mission 1');
                },
              ),
            ),

            Positioned(
              top: h * 0.61,
              right: rightPosition,
              child: missionButton(
                width: buttonWidth,
                height: buttonHeight,
                onTap: () {
                  debugPrint('Mission 2');
                },
              ),
            ),

            Positioned(
              top: h * 0.72,
              right: rightPosition,
              child: missionButton(
                width: buttonWidth,
                height: buttonHeight,
                onTap: () {
                  debugPrint('Mission 3');
                },
              ),
            ),

            Positioned(
              top: h * 0.82,
              right: rightPosition,
              child: missionButton(
                width: buttonWidth,
                height: buttonHeight,
                onTap: () {
                  debugPrint('Mission 4');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget missionButton({
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    final double iconSize = clampDouble(height * 0.58, 24, 34);
    final double playSize = clampDouble(height * 0.40, 18, 24);
    final double fontSize = clampDouble(height * 0.25, 11, 14);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: clampDouble(width * 0.07, 6, 10),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            clampDouble(width * 0.09, 10, 15),
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFFB7F300), Color(0xFF5EAE00)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(
            color: const Color(0xFF3D7500),
            width: clampDouble(width * 0.02, 2, 3),
          ),
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
              width: iconSize,
              height: iconSize,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: const Color(0xFF5EAE00),
                size: playSize,
              ),
            ),
            SizedBox(width: clampDouble(width * 0.05, 5, 8)),
            Flexible(
              child: Text(
                'BUKSAN\nANG MISYON',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: fontSize,
                  height: 1,
                  shadows: const [
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
