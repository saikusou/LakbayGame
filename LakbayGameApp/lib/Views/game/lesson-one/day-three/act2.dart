import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/Views/lesson3.dart';

class LessonOneDayThreeActTwo extends StatefulWidget {
  const LessonOneDayThreeActTwo({super.key});

  @override
  State<LessonOneDayThreeActTwo> createState() =>
      _LessonOneDayThreeActTwoState();
}

class _LessonOneDayThreeActTwoState extends State<LessonOneDayThreeActTwo> {
  int currentScenario = 1;

  final TextEditingController answer1Controller = TextEditingController();
  final TextEditingController answer2Controller = TextEditingController();

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  void dispose() {
    answer1Controller.dispose();
    answer2Controller.dispose();
    super.dispose();
  }

  Widget answerInput({
    required TextEditingController controller,
    required String hintText,
    required Size size,
  }) {
    return Container(
      width: clampDouble(size.width * 0.78, 260, 360),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-two-day3-act2a.png'
        : 'assets/lesson-two-day3-act2b.png';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(backgroundImage, fit: BoxFit.fill),
            ),

            if (currentScenario == 2)
              Positioned(
                top: clampDouble(size.height * 0.025, 14, 22),
                left: clampDouble(size.width * 0.04, 12, 20),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
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

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: clampDouble(size.height * 0.70, 470, 610),
                      ),

                      IndexedStack(
                        index: currentScenario - 1,
                        children: [
                          answerInput(
                            controller: answer1Controller,
                            hintText: 'Sagot sa larawan 1',
                            size: size,
                          ),
                          answerInput(
                            controller: answer2Controller,
                            hintText: 'Sagot sa larawan 2',
                            size: size,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      if (currentScenario == 1)
                        Button(
                          label: 'NEXT',
                          press: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              currentScenario = 2;
                            });
                          },
                        ),

                      if (currentScenario == 2)
                        Button(
                          label: 'SUBMIT',
                          press: () {
                            FocusScope.of(context).unfocus();

                            debugPrint(
                              'Picture 1 Answer: ${answer1Controller.text}',
                            );
                            debugPrint(
                              'Picture 2 Answer: ${answer2Controller.text}',
                            );
                          },
                        ),
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
