import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';

class LessonThreeGameTwo extends StatefulWidget {
  const LessonThreeGameTwo({super.key});

  @override
  State<LessonThreeGameTwo> createState() => _LessonThreeGameTwoState();
}

class _LessonThreeGameTwoState extends State<LessonThreeGameTwo> {
  final TextEditingController answer = TextEditingController();

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  void dispose() {
    answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SizedBox.expand(
        child: Stack(
          children: [
            /// RESPONSIVE FULL BACKGROUND
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Image.asset('assets/lesson-three-game2.png'),
                ),
              ),
            ),

            /// HOME BUTTON TOP RIGHT
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

            /// CONTENT
          ],
        ),
      ),
    );
  }
}
