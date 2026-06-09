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
    final double buttonSize = clampDouble(size.width * 0.13, 45, 65);
    final double iconSize = clampDouble(size.width * 0.075, 25, 36);

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
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
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
    final double width = clampDouble(size.width * 0.34, 115, 150);
    final double height = clampDouble(size.height * 0.095, 68, 88);
    final double iconSize = clampDouble(size.width * 0.075, 28, 38);
    final double fontSize = clampDouble(size.width * 0.05, 16, 22);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? width + 10 : width,
        height: isSelected ? height + 8 : height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.white,
            width: isSelected ? 5 : 4,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.yellow.withValues(alpha: 0.8)
                  : Colors.black26,
              blurRadius: isSelected ? 18 : 8,
              spreadRadius: isSelected ? 3 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: iconSize),
            const SizedBox(height: 4),
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
  }

  void submitAnswers() {
    debugPrint('Picture 1 Answer: $answer1');
    debugPrint('Picture 2 Answer: $answer2');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-one-day1-act4a.png'
        : 'assets/lesson-one-day1-act4b.png';

    final double topButton = clampDouble(h * 0.02, 10, 22);
    final double sideButton = clampDouble(w * 0.04, 12, 22);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: SizedBox.expand(
              child: Image.asset(backgroundImage, fit: BoxFit.fill),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: clampDouble(h * 0.035, 20, 35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: clampDouble(w * 0.05, 16, 28),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      choiceButton(
                        size: size,
                        label: 'TAMA',
                        icon: Icons.check,
                        color: Colors.green,
                        isSelected: currentAnswer == 'TAMA',
                        onTap: () => selectAnswer('TAMA'),
                      ),
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

                SizedBox(height: clampDouble(h * 0.02, 12, 20)),

                SizedBox(
                  width: clampDouble(w * 0.45, 140, 210),
                  child: Button(
                    label: currentScenario == 1 ? 'NEXT' : 'SUBMIT',
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
              ],
            ),
          ),

          Positioned(
            top: clampDouble(h * 0.025, 14, 24),
            right: clampDouble(w * 0.04, 12, 22),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Lesson1Screen(user: widget.user),
                  ),
                );
              },
              child: Container(
                width: clampDouble(w * 0.13, 48, 68),
                height: clampDouble(w * 0.13, 48, 68),
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
                  size: clampDouble(w * 0.075, 26, 38),
                ),
              ),
            ),
          ),

          if (currentScenario == 2)
            Positioned(
              top: topButton,
              left: sideButton,
              child: SafeArea(
                bottom: false,
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
            ),
        ],
      ),
    );
  }
}
