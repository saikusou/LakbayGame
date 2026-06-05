import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';

class LessonThreeDayFourActTwo extends StatefulWidget {
  const LessonThreeDayFourActTwo({super.key});

  @override
  State<LessonThreeDayFourActTwo> createState() =>
      _LessonThreeDayFourActTwoState();
}

class _LessonThreeDayFourActTwoState extends State<LessonThreeDayFourActTwo> {
  final List<TextEditingController> answers = List.generate(
    5,
    (_) => TextEditingController(),
  );

  final List<String> questions = [
    'Ang Ilaya ay matatagpuan malapit sa dagat.',
    'Ang pangunahing hanapbuhay sa Ilawud ay pangingisda.',
    'Ang Ilaya ay pamayanang nasa bundok o looban.',
    'Ang Ilawud ay walang kaugnayan sa kalakalan.',
    'Ang mga tao sa Ilaya ay nagsasaka at nangangaso.',
  ];

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  void dispose() {
    for (final controller in answers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget answerBox(int index) {
    return Container(
      width: 85,
      height: 38,
      margin: const EdgeInsets.only(left: 8),
      child: TextField(
        controller: answers[index],
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: 'T/M',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
        ),
      ),
    );
  }

  Widget questionItem(int index, double fontSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: clampDouble(fontSize * 1.2, 18, 28)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}.',
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              questions[index],
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          answerBox(index),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final questionTop = clampDouble(size.height * 0.34, 250, 330);
    final horizontalPadding = clampDouble(size.width * 0.09, 28, 55);
    final fontSize = clampDouble(size.width * 0.038, 14, 18);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/lesson-three-day4-act2.png',
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
            top: questionTop,
            left: horizontalPadding,
            right: horizontalPadding,
            bottom: 80,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  questions.length,
                  (index) => questionItem(index, fontSize),
                ),
              ),
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
    );
  }
}
