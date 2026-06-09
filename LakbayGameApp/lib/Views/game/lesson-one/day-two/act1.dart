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
    required double width,
    required double height,
    required double titleSize,
    required double subtitleSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: isSelected ? height + 6 : height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
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
            FittedBox(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSelected ? titleSize + 2 : titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: subtitleSize,
                fontWeight: FontWeight.w600,
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
    final buttonSize = clampDouble(size.width * 0.14, 48, 66);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
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
        child: Icon(icon, color: Colors.white, size: buttonSize * 0.55),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-two-day1-act21.png'
        : 'assets/lesson-two-day1-act22.png';

    final double horizontalPadding = clampDouble(w * 0.06, 16, 28);
    final double choiceWidth = clampDouble(w * 0.38, 130, 190);
    final double choiceHeight = clampDouble(h * 0.115, 82, 105);
    final double titleSize = clampDouble(w * 0.055, 18, 24);
    final double subtitleSize = clampDouble(w * 0.032, 10, 13);
    final double bottomPadding = clampDouble(h * 0.08, 35, 75);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(backgroundImage, fit: BoxFit.fill),
            ),

            if (currentScenario == 2)
              Positioned(
                top: clampDouble(h * 0.025, 14, 24),
                left: clampDouble(w * 0.04, 12, 22),
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
              top: clampDouble(h * 0.025, 14, 24),
              right: clampDouble(w * 0.04, 12, 22),
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

            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: bottomPadding,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: clampDouble(w * 0.04, 10, 18),
                        runSpacing: 12,
                        children: [
                          choiceButton(
                            label: '🔍 FACT',
                            subLabel: 'Siyentipikong\nPag-aaral',
                            color: const Color(0xFF007ee6),
                            isSelected: currentAnswer == 'FACT',
                            onTap: () => selectAnswer('FACT'),
                            width: choiceWidth,
                            height: choiceHeight,
                            titleSize: titleSize,
                            subtitleSize: subtitleSize,
                          ),
                          choiceButton(
                            label: '📖 KUWENTO',
                            subLabel: 'Alamat o\nKaalamang Bayan',
                            color: const Color(0xFFffb900),
                            isSelected: currentAnswer == 'KUWENTO',
                            onTap: () => selectAnswer('KUWENTO'),
                            width: choiceWidth,
                            height: choiceHeight,
                            titleSize: titleSize,
                            subtitleSize: subtitleSize,
                          ),
                        ],
                      ),

                      SizedBox(height: clampDouble(h * 0.025, 12, 22)),

                      SizedBox(
                        width: clampDouble(w * 0.45, 150, 220),
                        child: Button(
                          label: currentScenario == 1 ? 'NEXT' : 'SUBMIT',
                          press: () {
                            if (currentScenario == 1) {
                              setState(() {
                                currentScenario = 2;
                              });
                            } else {
                              debugPrint('Picture 1 Answer: $answer1');
                              debugPrint('Picture 2 Answer: $answer2');
                            }
                          },
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
    );
  }
}
