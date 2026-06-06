import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/Views/lesson3.dart';

class LessonOneDayOneActOne extends StatefulWidget {
  const LessonOneDayOneActOne({super.key});

  @override
  State<LessonOneDayOneActOne> createState() => _LessonOneDayOneActOneState();
}

class _LessonOneDayOneActOneState extends State<LessonOneDayOneActOne> {
  int currentScenario = 1;

  String? answer1;
  String? answer2;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void selectAnswer(String answer) {
    setState(() {
      if (currentScenario == 1) {
        answer1 = answer;
      } else {
        answer2 = answer;
      }
    });
  }

  Widget choiceButton({
    required String value,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final bool isSelected = currentScenario == 1
        ? answer1 == value
        : answer2 == value;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 330,
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.white,
            width: isSelected ? 5 : 4,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> answerChoices() {
    if (currentScenario == 1) {
      return [
        const SizedBox(height: 150),
        choiceButton(
          value: 'A',
          label: 'A. Tumawid sa dagat',
          color: Colors.blue,
          onTap: () => selectAnswer('A'),
        ),
        const SizedBox(height: 1),
        choiceButton(
          value: 'B',
          label: 'B. Gumamit ng bangka',
          color: Colors.orange,
          onTap: () => selectAnswer('B'),
        ),
        const SizedBox(height: 1),
        choiceButton(
          value: 'C',
          label: 'C. Naglakbay mula sa ibang lugar',
          color: Colors.purple,
          onTap: () => selectAnswer('C'),
        ),
      ];
    }

    return [
      const SizedBox(height: 180),
      choiceButton(
        value: 'A',
        label: 'A. Malakas at Maganda',
        color: Colors.blue,
        onTap: () => selectAnswer('A'),
      ),
      const SizedBox(height: 1),
      choiceButton(
        value: 'B',
        label: 'B. Alamat ng pinagmulan ng tao',
        color: Colors.orange,
        onTap: () => selectAnswer('B'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-one-day1-act2a.png'
        : 'assets/lesson-one-day1-act2b.png';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // 1. Background Image (Bottom-most layer)
            Positioned.fill(
              child: Image.asset(backgroundImage, fit: BoxFit.fill),
            ),

            // 2. Main Content Scroll Layer
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        height: clampDouble(size.height * 0.58, 380, 500),
                      ),
                      Column(children: answerChoices()),
                      const SizedBox(height: 5),
                      if (currentScenario == 1)
                        Button(
                          label: 'NEXT',
                          press: () {
                            setState(() {
                              currentScenario = 2;
                            });
                          },
                        ),
                      if (currentScenario == 2)
                        Button(
                          label: 'SUBMIT',
                          press: () {
                            debugPrint('Picture 1 Answer: $answer1');
                            debugPrint('Picture 2 Answer: $answer2');
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Navigation UI Controls (Top-most layer, completely touchable)
            SafeArea(
              child: Stack(
                children: [
                  if (currentScenario == 2)
                    Positioned(
                      top: clampDouble(size.height * 0.025, 14, 22),
                      left: clampDouble(size.width * 0.04, 12, 20),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentScenario = 1;
                          });
                        },
                        child: Container(
                          width: clampDouble(size.width * 0.14, 50, 70),
                          height: clampDouble(size.width * 0.14, 50, 70),
                          decoration: BoxDecoration(
                            color: Colors.blue,
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
                            Icons.arrow_back,
                            color: Colors.white,
                            size: clampDouble(size.width * 0.08, 28, 40),
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
                          MaterialPageRoute(
                            builder: (_) => const Lesson1Screen(),
                          ),
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
          ],
        ),
      ),
    );
  }
}
