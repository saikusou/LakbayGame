import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';

class LessonThreeDayOneActFour extends StatefulWidget {
  const LessonThreeDayOneActFour({super.key});

  @override
  State<LessonThreeDayOneActFour> createState() =>
      _LessonThreeDayOneActFourState();
}

class _LessonThreeDayOneActFourState extends State<LessonThreeDayOneActFour> {
  final TextEditingController answer1 = TextEditingController();
  final TextEditingController answer2 = TextEditingController();

  @override
  void dispose() {
    answer1.dispose();
    answer2.dispose();
    super.dispose();
  }

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  Widget answerBox({
    required TextEditingController controller,
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(14),
          hintText: 'Ilagay ang sagot dito...',
          hintStyle: TextStyle(color: Colors.black45, fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final inputWidth = clampDouble(size.width * 0.78, 250, 650);
    final inputHeight = clampDouble(size.height * 0.14, 90, 150);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/lesson-three-day3-act4.png',
                fit: BoxFit.fill,
              ),
            ),

            Positioned(
              top: size.height * 0.31,
              left: size.width * 0.12,
              right: size.width * 0.09,
              child: answerBox(
                controller: answer1,
                width: inputWidth,
                height: inputHeight,
              ),
            ),

            Positioned(
              top: size.height * 0.61,
              left: size.width * 0.12,
              right: size.width * 0.09,
              child: answerBox(
                controller: answer2,
                width: inputWidth,
                height: inputHeight,
              ),
            ),

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
