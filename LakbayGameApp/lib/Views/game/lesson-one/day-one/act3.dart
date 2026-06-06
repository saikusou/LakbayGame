import 'package:flutter/material.dart';

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
          fontSize: boxSize * 0.55,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
        textCapitalization: TextCapitalization.characters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double boxSize = clampDouble(size.width * 0.065, 30, 48);
    final double spacing = clampDouble(size.width * 0.012, 4, 8);

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

          /// 14 INPUT BOXES
          Positioned(
            left: size.width * 0.06,
            right: size.width * 0.06,
            bottom: size.height * 0.085,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: spacing,
              runSpacing: spacing,
              children: List.generate(14, (index) => inputBox(index, boxSize)),
            ),
          ),
        ],
      ),
    );
  }
}
