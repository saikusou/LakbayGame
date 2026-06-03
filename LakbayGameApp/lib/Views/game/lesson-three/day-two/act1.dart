import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';

class LessonThreeDayTwoActThree extends StatefulWidget {
  const LessonThreeDayTwoActThree({super.key});

  @override
  State<LessonThreeDayTwoActThree> createState() =>
      _LessonThreeDayTwoActThreeState();
}

class _LessonThreeDayTwoActThreeState extends State<LessonThreeDayTwoActThree> {
  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            /// BACKGROUND
            Positioned.fill(
              child: Transform.scale(
                scale: 1.08,
                child: Image.asset(
                  'assets/lesson-three-act4-one.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),

            /// HOME BUTTON
            Positioned(
              top: clampDouble(size.height * 0.025, 14, 22),
              right: clampDouble(size.width * 0.04, 12, 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Lesson3Screen()),
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
          ],
        ),
      ),
    );
  }
}
