import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Components/textfield.dart';
import 'package:lakbay_game/Views/lesson3.dart';

class LessonThreeGameOne extends StatefulWidget {
  const LessonThreeGameOne({super.key});

  @override
  State<LessonThreeGameOne> createState() => _LessonThreeGameOneState();
}

class _LessonThreeGameOneState extends State<LessonThreeGameOne> {
  final TextEditingController answer1 = TextEditingController();
  final TextEditingController answer2 = TextEditingController();

  int currentScenario = 1;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  void dispose() {
    answer1.dispose();
    answer2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-three-game1.png'
        : 'assets/lesson-three-game2.png'; // CHANGE THIS

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            /// BACKGROUND
            Positioned.fill(
              child: Transform.scale(
                scale: 1.08,
                child: Image.asset(backgroundImage, fit: BoxFit.fill),
              ),
            ),

            /// BACK BUTTON (ONLY SHOW IN SCENARIO 2)
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

            /// CONTENT
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 390),

                      /// SCENARIO 1
                      if (currentScenario == 1) ...[
                        InputField(
                          hint: 'Answer for Picture 1',
                          icon: Icons.edit,
                          controller: answer1,
                          passwordInvisible: false,
                        ),

                        const SizedBox(height: 16),

                        Button(
                          label: 'NEXT',
                          press: () {
                            setState(() {
                              currentScenario = 2;
                            });
                          },
                        ),
                      ],

                      /// SCENARIO 2
                      if (currentScenario == 2) ...[
                        InputField(
                          hint: 'Answer for Picture 2',
                          icon: Icons.edit,
                          controller: answer2,
                          passwordInvisible: false,
                        ),

                        const SizedBox(height: 16),

                        Button(
                          label: 'SUBMIT',
                          press: () {
                            debugPrint('Picture 1 Answer: ${answer1.text}');

                            debugPrint('Picture 2 Answer: ${answer2.text}');

                            // ADD RESULT PAGE HERE
                          },
                        ),
                      ],
                    ],
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
