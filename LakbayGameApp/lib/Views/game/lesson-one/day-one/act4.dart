import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
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

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  String? get currentAnswer => currentScenario == 1 ? answer1 : answer2;

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
                      child: SizedBox(
                        width: clampDouble(w * 0.34, 105, 160),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: clampDouble(w * 0.34, 105, 160),
                            child: Button(
                              label: 'OK',
                              press: () => Navigator.pop(context),
                            ),
                          ),
                        ),
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

  void goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
      (route) => false,
    );
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
    required IconData icon,
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

    final double iconSize = clampDouble(size.shortestSide * 0.06, 18, 32);
    final double fontSize = clampDouble(size.shortestSide * 0.04, 12, 20);

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
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: iconSize),
                SizedBox(height: verySmall ? 1 : 3),
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
        ),
      ),
    );
  }

  void submitAnswers() {
    debugPrint('Picture 1 Answer: $answer1');
    debugPrint('Picture 2 Answer: $answer2');
    goHome();
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

          final double bottomButtonWidth = clampDouble(w * 0.38, 115, 190);

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
                                icon: Icons.check,
                                color: Colors.green,
                                isSelected: currentAnswer == 'TAMA',
                                onTap: () => selectAnswer('TAMA'),
                              ),
                              SizedBox(width: clampDouble(w * 0.06, 14, 32)),
                              choiceButton(
                                size: size,
                                label: 'MALI',
                                icon: Icons.close,
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

                        SizedBox(
                          width: bottomButtonWidth,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: SizedBox(
                              width: bottomButtonWidth,
                              child: Button(
                                label: currentScenario == 1 ? 'NEXT' : 'DONE',
                                press: () {
                                  if (currentScenario == 1) {
                                    setState(() {
                                      currentScenario = 2;
                                    });
                                  } else {
                                    submitAnswers();
                                  }
                                },
                              ),
                            ),
                          ),
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
