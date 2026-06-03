import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';

class LessonThreeDayTwoActThree extends StatefulWidget {
  const LessonThreeDayTwoActThree({super.key});

  @override
  State<LessonThreeDayTwoActThree> createState() =>
      _LessonThreeDayTwoActThreeState();
}

class _LessonThreeDayTwoActThreeState extends State<LessonThreeDayTwoActThree> {
  final List<int?> selectedAnswers = List.generate(5, (_) => null);

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  /// CHANGE THIS VALUE TO MOVE QUESTIONS UP OR DOWN
  final double questionMarginTop = 50;

  final List<String> questions = [
    'Isa itong pamayanan\nna nasa looban o bundok.',
    'Ang pamayanang\nnakikipagkalakalan sa\nmalapit na lugar lamang.',
    'Ang pamayanang ang\npangunahing hanapbuhay\nay pagtatanim at pangangaso.',
    'Ang pamayanang ang\npangunahing hanapbuhay\nay pangingisda.',
    'Ang pamayanang malapit\nsa dagat o malalaking ilog.',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final safeTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/lesson-three-day1-act2.png',
              fit: BoxFit.fill,
            ),
          ),

          /// HOME BUTTON
          Positioned(
            top: safeTop + 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Lesson3Screen()),
                );
              },
              child: Container(
                width: clampDouble(size.width * 0.12, 45, 65),
                height: clampDouble(size.width * 0.12, 45, 65),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: clampDouble(size.width * 0.07, 24, 36),
                ),
              ),
            ),
          ),

          /// QUESTIONS
          Positioned(
            top: clampDouble(size.height * 0.50, 350, 430) + questionMarginTop,
            left: clampDouble(size.width * 0.07, 22, 40),
            right: clampDouble(size.width * 0.07, 22, 40),
            child: Column(
              children: List.generate(
                questions.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// QUESTION NUMBER
                      SizedBox(
                        width: 25,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// QUESTION TEXT
                      Expanded(
                        child: Text(
                          questions[index],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                      ),

                      /// ILAYA CHECKBOX
                      Checkbox(
                        value: selectedAnswers[index] == 0,
                        onChanged: (_) {
                          setState(() {
                            selectedAnswers[index] = 0;
                          });
                        },
                      ),

                      /// ILAWUD CHECKBOX
                      Checkbox(
                        value: selectedAnswers[index] == 1,
                        onChanged: (_) {
                          setState(() {
                            selectedAnswers[index] = 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
