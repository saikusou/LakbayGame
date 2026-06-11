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
  String? answer3;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  String? get currentAnswer {
    if (currentScenario == 1) return answer1;
    if (currentScenario == 2) return answer2;
    return answer3;
  }

  void selectAnswer(String answer) {
    setState(() {
      if (currentScenario == 1) {
        answer1 = answer;
      } else if (currentScenario == 2) {
        answer2 = answer;
      } else {
        answer3 = answer;
      }
    });
  }

  String get backgroundImage {
    if (currentScenario == 1) {
      return 'assets/lesson-three-day3-act2-c1.png';
    } else if (currentScenario == 2) {
      return 'assets/lesson-three-day3-act2-c2.png';
    } else {
      return 'assets/lesson-three-day3-act2-c3.png';
    }
  }

  void nextScenario() {
    if (currentScenario < 3) {
      setState(() => currentScenario++);
    }
  }

  void previousScenario() {
    if (currentScenario > 1) {
      setState(() => currentScenario--);
    }
  }

  void submitAnswers() {
    debugPrint('Picture 1 Answer: $answer1');
    debugPrint('Picture 2 Answer: $answer2');
    debugPrint('Picture 3 Answer: $answer3');
  }

  Widget choiceButton({
    required String label,
    required IconData icon,
    required Color color,
    required double width,
    required double height,
    required double fontSize,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    final bool isSelected = currentAnswer == label;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height / 2),
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
              size: iconSize,
            ),
            SizedBox(width: width * 0.05),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
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
          border: Border.all(color: Colors.white, width: 4),
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final safe = MediaQuery.of(context).padding;

    final bool isSmallScreen = size.height < 700;

    final double sidePadding = clampDouble(size.width * 0.045, 12, 24);
    final double topPadding = safe.top + clampDouble(size.height * 0.01, 6, 14);

    final double topButtonSize = clampDouble(size.width * 0.12, 42, 62);

    final double choiceWidth = clampDouble(size.width * 0.38, 120, 165);
    final double choiceHeight = clampDouble(size.height * 0.075, 46, 66);
    final double choiceFont = clampDouble(size.width * 0.043, 14, 21);
    final double choiceIcon = clampDouble(size.width * 0.062, 21, 31);

    final double choicesBottom = clampDouble(size.height * 0.105, 64, 105);
    final double buttonBottom = clampDouble(size.height * 0.015, 8, 18);

    final double buttonScale = isSmallScreen ? 0.78 : 0.92;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(backgroundImage, fit: BoxFit.fill),
          ),

          Positioned(
            left: sidePadding,
            right: sidePadding,
            bottom: choicesBottom,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                choiceButton(
                  label: 'ILAYA',
                  icon: Icons.star,
                  color: Colors.blue,
                  width: choiceWidth,
                  height: choiceHeight,
                  fontSize: choiceFont,
                  iconSize: choiceIcon,
                  onTap: () => selectAnswer('ILAYA'),
                ),
                choiceButton(
                  label: 'ILAWUD',
                  icon: Icons.favorite,
                  color: Colors.red,
                  width: choiceWidth,
                  height: choiceHeight,
                  fontSize: choiceFont,
                  iconSize: choiceIcon,
                  onTap: () => selectAnswer('ILAWUD'),
                ),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: safe.bottom + buttonBottom,
            child: Center(
              child: Transform.scale(
                scale: buttonScale,
                child: currentScenario < 3
                    ? Button(label: 'NEXT', press: nextScenario)
                    : Button(label: 'SUBMIT', press: submitAnswers),
              ),
            ),
          ),

          if (currentScenario > 1)
            Positioned(
              top: topPadding,
              left: sidePadding,
              child: circleButton(
                icon: Icons.arrow_back,
                color: Colors.blue,
                size: topButtonSize,
                onTap: previousScenario,
              ),
            ),

          Positioned(
            top: topPadding,
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
        ],
      ),
    );
  }
}
