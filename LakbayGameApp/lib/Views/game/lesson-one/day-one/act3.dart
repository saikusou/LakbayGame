import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';

class LessonOneDayOneActThree extends StatefulWidget {
  const LessonOneDayOneActThree({super.key});

  @override
  State<LessonOneDayOneActThree> createState() =>
      _LessonOneDayOneActThreeState();
}

class _LessonOneDayOneActThreeState extends State<LessonOneDayOneActThree> {
  final List<TextEditingController> controllers = List.generate(
    14,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  Widget inputBox(int index, double boxSize) {
    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: TextField(
        controller: controllers[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: boxSize * 0.85,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.blue, width: 3),
          ),
        ),
        textCapitalization: TextCapitalization.characters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double boxSize = clampDouble(size.width * 0.055, 24, 38);
    final double spacing = clampDouble(size.width * 0.006, 2, 5);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/lesson-one-day1-act3.png',
              fit: BoxFit.fill,
            ),
          ),

          /// 14 INPUT BOXES HORIZONTAL
          Positioned(
            left: size.width * 0.03,
            right: size.width * 0.03,
            bottom: size.height * 0.085,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                14,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing),
                  child: inputBox(index, boxSize),
                ),
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
        ],
      ),
    );
  }
}
