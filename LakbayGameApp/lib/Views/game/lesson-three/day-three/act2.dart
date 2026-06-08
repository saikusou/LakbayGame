import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonThreeDayOneActTwo extends StatefulWidget {
  final UserModel user;

  const LessonThreeDayOneActTwo({super.key, required this.user});

  @override
  State<LessonThreeDayOneActTwo> createState() =>
      _LessonThreeDayOneActTwoState();
}

class _LessonThreeDayOneActTwoState extends State<LessonThreeDayOneActTwo> {
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
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final bool isSelected = currentScenario == 1
        ? answer1 == label
        : answer2 == label;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: isSelected ? Colors.yellowAccent : Colors.white,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: label == 'ILAYA' ? Colors.yellowAccent : Colors.pinkAccent,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-three-day3-act2-c1.png'
        : 'assets/lesson-three-day3-act2-c2.png';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            /// 1. BACKGROUND (Bottom layer)
            Positioned.fill(
              child: Transform.scale(
                scale: 1,
                child: Image.asset(backgroundImage, fit: BoxFit.fill),
              ),
            ),

            /// 2. CONTENT BUTTONS (Middle layer)
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        height: clampDouble(size.height * 0.70, 470, 610),
                      ),
                      const SizedBox(height: 55),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          choiceButton(
                            label: 'ILAYA',
                            icon: Icons.star,
                            color: Colors.blue,
                            onTap: () {
                              selectAnswer('ILAYA');
                            },
                          ),
                          choiceButton(
                            label: 'ILAWUD',
                            icon: Icons.favorite,
                            color: Colors.red,
                            onTap: () {
                              selectAnswer('ILAWUD');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                            // ADD RESULT PAGE HERE
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),

            /// 3. INTERACTIVE NAVIGATION BUTTONS (Top Layer)
            /// Placed at the end of the Stack so they sit on top of everything else and register clicks correctly.
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
                      builder: (_) => Lesson3Screen(user: widget.user),
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
    );
  }
}
