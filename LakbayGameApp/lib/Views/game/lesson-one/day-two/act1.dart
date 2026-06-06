import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Views/lesson1.dart';

class LessonOneDayTwoActTwo extends StatefulWidget {
  const LessonOneDayTwoActTwo({super.key});

  @override
  State<LessonOneDayTwoActTwo> createState() => _LessonOneDayTwoActTwoState();
}

class _LessonOneDayTwoActTwoState extends State<LessonOneDayTwoActTwo> {
  int currentScenario = 1;

  String? answer1;
  String? answer2;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  String? get currentAnswer {
    return currentScenario == 1 ? answer1 : answer2;
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
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 145 : 130,
        height: isSelected ? 90 : 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.white,
            width: isSelected ? 6 : 4,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.yellow.withOpacity(0.8)
                  : Colors.black26,
              blurRadius: isSelected ? 20 : 8,
              spreadRadius: isSelected ? 4 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: isSelected ? 40 : 35),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSelected ? 22 : 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: clampDouble(size.width * 0.14, 50, 70),
        height: clampDouble(size.width * 0.14, 50, 70),
        decoration: BoxDecoration(
          color: color,
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
          icon,
          color: Colors.white,
          size: clampDouble(size.width * 0.08, 28, 40),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-one-day1-act4a.png'
        : 'assets/lesson-one-day1-act4b.png';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.scale(
                scale: 1.08,
                child: Image.asset(backgroundImage, fit: BoxFit.fill),
              ),
            ),

            if (currentScenario == 2)
              Positioned(
                top: clampDouble(size.height * 0.025, 14, 22),
                left: clampDouble(size.width * 0.04, 12, 20),
                child: circleButton(
                  icon: Icons.arrow_back,
                  color: Colors.blue,
                  onTap: () {
                    setState(() {
                      currentScenario = 1;
                    });
                  },
                ),
              ),

            Positioned(
              top: clampDouble(size.height * 0.025, 14, 22),
              right: clampDouble(size.width * 0.04, 12, 20),
              child: circleButton(
                icon: Icons.home,
                color: Colors.orange,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Lesson1Screen()),
                  );
                },
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        height: clampDouble(size.height * 0.70, 470, 610),
                      ),

                      // NEW STYLED BUTTONS (Replaced the old Row)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            // FACT BUTTON (Blue)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  selectAnswer('FACT');
                                },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF007ee6),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    // Optional: You can dynamically change border color if selected
                                    // border: Border.all(
                                    //   color: currentAnswer == 'FACT' ? Colors.black : Colors.white,
                                    //   width: 3,
                                    // ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xFF004fa3),
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '🔍 FACT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Siyentipikong\nPag-aaral',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),

                            // KUWENTO BUTTON (Yellow/Orange)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  selectAnswer('KUWENTO');
                                },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFffb900),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    // Optional: You can dynamically change border color if selected
                                    // border: Border.all(
                                    //   color: currentAnswer == 'KUWENTO' ? Colors.black : Colors.white,
                                    //   width: 3,
                                    // ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xFFc78200),
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '📖 KUWENTO',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Alamat o\nKaalamang Bayan',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

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
          ],
        ),
      ),
    );
  }
}
