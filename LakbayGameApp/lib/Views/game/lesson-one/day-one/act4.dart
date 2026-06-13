import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneActFour extends StatefulWidget {
  final UserModel user;

  const LessonOneActFour({super.key, required this.user});

  @override
  State<LessonOneActFour> createState() => _LessonOneActFourState();
}

class _LessonOneActFourState extends State<LessonOneActFour> {
  int currentScenario = 1;

  String? answer1;
  String? answer2;

  final List<String> correctAnswers = ['MALI', 'TAMA'];

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  String? get currentAnswer => currentScenario == 1 ? answer1 : answer2;

  int getScore() {
    int score = 0;

    if (answer1 == correctAnswers[0]) score += 5;
    if (answer2 == correctAnswers[1]) score += 5;

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

    showAnswerPopup();
  }

  void goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
    );
  }

  Widget smallButton({
    required String label,
    required VoidCallback onTap,
    required double width,
    required double height,
    required double fontSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFC857), Color(0xFFFFA500)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }

  void showAnswerPopup() {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final String popupImage = currentScenario == 1
        ? 'assets/lesson-one-day1-act4m.png'
        : 'assets/lesson-one-day1-act4t.png';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: clampDouble(w * 0.04, 10, 22),
            vertical: clampDouble(h * 0.025, 10, 24),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 520, maxHeight: h * 0.78),
            child: AspectRatio(
              aspectRatio: 1.05,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(popupImage, fit: BoxFit.fill),
                    ),
                  ),
                  Positioned(
                    bottom: clampDouble(h * 0.025, 12, 28),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: smallButton(
                        label: 'OK',
                        width: clampDouble(w * 0.23, 75, 115),
                        height: clampDouble(h * 0.052, 35, 48),
                        fontSize: clampDouble(w * 0.04, 13, 18),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showScorePopup() {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final score = getScore();
    final correctCount = score ~/ 5;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: clampDouble(w * 0.82, 280, 420),
            padding: EdgeInsets.all(clampDouble(w * 0.06, 18, 28)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4D8),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.orange, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
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
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: clampDouble(w * 0.065, 22, 34),
                  ),
                ),

                SizedBox(height: clampDouble(h * 0.018, 10, 18)),

                Text(
                  'Your Score',
                  style: TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                    fontSize: clampDouble(w * 0.05, 18, 26),
                  ),
                ),

                SizedBox(height: clampDouble(h * 0.012, 8, 14)),

                Text(
                  '$score / 10',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: clampDouble(w * 0.09, 34, 50),
                  ),
                ),

                SizedBox(height: clampDouble(h * 0.01, 6, 12)),

                Text(
                  '$correctCount out of 2 correct answers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: clampDouble(w * 0.04, 14, 20),
                  ),
                ),

                SizedBox(height: clampDouble(h * 0.025, 16, 26)),

                smallButton(
                  label: 'OK',
                  width: clampDouble(w * 0.32, 110, 150),
                  height: clampDouble(h * 0.055, 40, 52),
                  fontSize: clampDouble(w * 0.04, 14, 18),
                  onTap: () {
                    Navigator.pop(context);
                    goHome();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void submitAnswers() {
    showScorePopup();
  }

  Widget circleButton({
    required Size size,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final shortest = size.shortestSide;

    final double buttonSize = clampDouble(shortest * 0.12, 38, 58);
    final double iconSize = clampDouble(shortest * 0.065, 20, 32);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: iconSize),
        ),
      ),
    );
  }

  Widget choiceButton({
    required Size size,
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final bool verySmall = size.height < 620;
    final bool small = size.height < 700;

    final double width = clampDouble(size.width * 0.32, 96, 145);
    final double height = clampDouble(
      size.height *
          (verySmall
              ? 0.062
              : small
              ? 0.072
              : 0.085),
      45,
      80,
    );

    final double fontSize = clampDouble(size.shortestSide * 0.045, 14, 22);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: isSelected ? width + 4 : width,
        height: isSelected ? height + 3 : height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.white,
            width: isSelected ? 4 : 3,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.yellow.withValues(alpha: 0.7)
                  : Colors.black26,
              blurRadius: isSelected ? 12 : 6,
              spreadRadius: isSelected ? 1.5 : 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-one-day1-act4a.png'
        : 'assets/lesson-one-day1-act4b.png';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          final w = size.width;
          final h = size.height;

          final bool verySmall = h < 620;
          final bool small = h < 700;

          final double bottomButtonWidth = clampDouble(w * 0.28, 90, 135);
          final double bottomButtonHeight = clampDouble(h * 0.052, 36, 50);
          final double bottomButtonFont = clampDouble(w * 0.038, 13, 18);

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(backgroundImage, fit: BoxFit.fill),
              ),

              SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    Positioned(
                      top: clampDouble(h * 0.005, 4, 14),
                      right: clampDouble(w * 0.03, 8, 18),
                      child: circleButton(
                        icon: Icons.home,
                        color: Colors.orange,
                        size: size,
                        onTap: goHome,
                      ),
                    ),

                    if (currentScenario == 2)
                      Positioned(
                        top: clampDouble(h * 0.005, 4, 14),
                        left: clampDouble(w * 0.03, 8, 18),
                        child: circleButton(
                          size: size,
                          icon: Icons.arrow_back,
                          color: Colors.blue,
                          onTap: () {
                            setState(() {
                              currentScenario = 1;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  top: false,
                  minimum: EdgeInsets.only(
                    left: clampDouble(w * 0.03, 8, 20),
                    right: clampDouble(w * 0.03, 8, 20),
                    bottom: clampDouble(h * 0.008, 5, 14),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              choiceButton(
                                size: size,
                                label: 'TAMA',
                                color: Colors.green,
                                isSelected: currentAnswer == 'TAMA',
                                onTap: () => selectAnswer('TAMA'),
                              ),

                              SizedBox(width: clampDouble(w * 0.06, 14, 32)),

                              choiceButton(
                                size: size,
                                label: 'MALI',
                                color: Colors.red,
                                isSelected: currentAnswer == 'MALI',
                                onTap: () => selectAnswer('MALI'),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: verySmall
                              ? 5
                              : small
                              ? 8
                              : 13,
                        ),

                        smallButton(
                          label: currentScenario == 1 ? 'NEXT' : 'DONE',
                          width: bottomButtonWidth,
                          height: bottomButtonHeight,
                          fontSize: bottomButtonFont,
                          onTap: () {
                            if (currentScenario == 1) {
                              setState(() {
                                currentScenario = 2;
                              });
                            } else {
                              submitAnswers();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
