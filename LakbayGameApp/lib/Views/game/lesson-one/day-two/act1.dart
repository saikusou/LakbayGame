import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneDayTwoActTwo extends StatefulWidget {
  final UserModel user;
  const LessonOneDayTwoActTwo({super.key, required this.user});

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
    required String subLabel,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isSelected ? 105 : 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.yellow : Colors.white,
              width: isSelected ? 5 : 3,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.yellow.withOpacity(0.6)
                    : color == const Color(0xFF007ee6)
                    ? const Color(0xFF004fa3)
                    : const Color(0xFFc78200),
                blurRadius: isSelected ? 15 : 0,
                spreadRadius: isSelected ? 2 : 0,
                offset: isSelected ? const Offset(0, 2) : const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSelected ? 26 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
        ? 'assets/lesson-two-day1-act21.png'
        : 'assets/lesson-two-day1-act22.png';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Transform.scale(
                scale: 1,
                child: Image.asset(backgroundImage, fit: BoxFit.fill),
              ),
            ),

            // Back Button (Scenario 2 Only)
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

            // Home Button
            Positioned(
              top: clampDouble(size.height * 0.025, 14, 22),
              right: clampDouble(size.width * 0.04, 12, 20),
              child: circleButton(
                icon: Icons.home,
                color: Colors.orange,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Lesson1Screen(user: widget.user),
                    ),
                  );
                },
              ),
            ),

            // Bottom Interactive HUD Layout
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 80,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Styled Dynamic Selection Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            choiceButton(
                              label: '🔍 FACT',
                              subLabel: 'Siyentipikong\nPag-aaral',
                              color: const Color(0xFF007ee6),
                              isSelected: currentAnswer == 'FACT',
                              onTap: () => selectAnswer('FACT'),
                            ),
                            const SizedBox(width: 15),
                            choiceButton(
                              label: '📖 KUWENTO',
                              subLabel: 'Alamat o\nKaalamang Bayan',
                              color: const Color(0xFFffb900),
                              isSelected: currentAnswer == 'KUWENTO',
                              onTap: () => selectAnswer('KUWENTO'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Navigation Action Buttons
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
