import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonThreeActFour extends StatefulWidget {
  final UserModel user;

  const LessonThreeActFour({super.key, required this.user});

  @override
  State<LessonThreeActFour> createState() => _LessonThreeActFourState();
}

class _LessonThreeActFourState extends State<LessonThreeActFour> {
  int currentScenario = 1;

  String? answer1;
  String? answer2;

  final String correctAnswer1 = 'TAMA';
  final String correctAnswer2 = 'MALI';

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  int getScore() {
    int score = 0;

    if (answer1 == correctAnswer1) score += 5;
    if (answer2 == correctAnswer2) score += 5;

    return score;
  }

  void selectAnswer(String answer) {
    setState(() {
      if (currentScenario == 1) {
        answer1 = answer;
      } else {
        answer2 = answer;
      }
    });

    final String popupImage = currentScenario == 1
        ? 'assets/tm.png'
        : 'assets/ml.png';

    showAnswerPopup(popupImage);
  }

  void showAnswerPopup(String imagePath) {
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(18),
          child: Container(
            width: clampDouble(size.width * 0.88, 280, 430),
            height: clampDouble(size.height * 0.55, 300, 460),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.fill,
              ),
              border: Border.all(color: Colors.orange, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showResultPopup() {
    final size = MediaQuery.of(context).size;
    final int score = getScore();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: clampDouble(size.width * 0.85, 280, 400),
            padding: EdgeInsets.symmetric(
              horizontal: clampDouble(size.width * 0.06, 18, 28),
              vertical: clampDouble(size.height * 0.04, 24, 35),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3C4),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.orange, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CONGRATULATIONS!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.07, 24, 34),
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),

                SizedBox(height: clampDouble(size.height * 0.025, 14, 24)),

                Text(
                  '$score / 10 POINTS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.08, 28, 42),
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                SizedBox(height: clampDouble(size.height * 0.035, 20, 30)),

                SizedBox(
                  width: clampDouble(size.width * 0.42, 130, 180),
                  height: clampDouble(size.height * 0.06, 42, 55),
                  child: Button(
                    label: 'OK',
                    press: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Lesson3Screen(user: widget.user),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget circleButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      ),
    );
  }

  Widget choiceButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final buttonWidth = clampDouble(width * 0.42, 105, 145);
        final buttonHeight = clampDouble(width * 0.24, 58, 80);
        final iconSize = clampDouble(width * 0.10, 24, 35);
        final fontSize = clampDouble(width * 0.055, 15, 20);

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: buttonWidth,
            height: buttonHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected ? Colors.yellow : Colors.white,
                width: selected ? 5 : 3,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: iconSize),
                SizedBox(height: clampDouble(width * 0.015, 2, 5)),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bool isSmallHeight = size.height < 650;

    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-three-act4-one.png'
        : 'assets/lesson-three-act4-two.png';

    final double topPadding = MediaQuery.of(context).padding.top;
    final double sidePadding = clampDouble(size.width * 0.04, 12, 22);
    final double topButtonSize = clampDouble(size.width * 0.13, 45, 65);

    final double bottomPosition = isSmallHeight
        ? clampDouble(size.height * 0.03, 16, 28)
        : clampDouble(size.height * 0.05, 28, 50);

    final String? currentAnswer = currentScenario == 1 ? answer1 : answer2;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(backgroundImage, fit: BoxFit.fill),
          ),

          if (currentScenario == 2)
            Positioned(
              top: topPadding + 8,
              left: sidePadding,
              child: circleButton(
                icon: Icons.arrow_back,
                color: Colors.blue,
                size: topButtonSize,
                onTap: () {
                  setState(() {
                    currentScenario = 1;
                  });
                },
              ),
            ),

          Positioned(
            top: topPadding + 8,
            right: sidePadding,
            child: circleButton(
              icon: Icons.home,
              color: Colors.orange,
              size: topButtonSize,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Lesson3Screen(user: widget.user),
                  ),
                );
              },
            ),
          ),

          Positioned(
            left: sidePadding,
            right: sidePadding,
            bottom: bottomPosition,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      choiceButton(
                        label: 'TAMA',
                        icon: Icons.check,
                        color: Colors.green,
                        selected: currentAnswer == 'TAMA',
                        onTap: () {
                          selectAnswer('TAMA');
                        },
                      ),
                      choiceButton(
                        label: 'MALI',
                        icon: Icons.close,
                        color: Colors.red,
                        selected: currentAnswer == 'MALI',
                        onTap: () {
                          selectAnswer('MALI');
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: clampDouble(size.height * 0.018, 8, 18)),

                  SizedBox(
                    width: clampDouble(size.width * 0.45, 130, 190),
                    height: clampDouble(size.height * 0.06, 42, 55),
                    child: Button(
                      label: currentScenario == 1 ? 'NEXT' : 'SUBMIT',
                      press: () {
                        if (currentScenario == 1) {
                          setState(() {
                            currentScenario = 2;
                          });
                        } else {
                          showResultPopup();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
