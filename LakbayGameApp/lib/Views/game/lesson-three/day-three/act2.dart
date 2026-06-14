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
  String? answer4;
  String? answer5;

  final int totalScenarios = 5;

  final List<String> correctAnswers = [
    'ILAYA',
    'ILAYA',
    'ILAYA',
    'ILAWUD',
    'ILAWUD',
  ];

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  String? get currentAnswer {
    switch (currentScenario) {
      case 1:
        return answer1;
      case 2:
        return answer2;
      case 3:
        return answer3;
      case 4:
        return answer4;
      case 5:
        return answer5;
      default:
        return null;
    }
  }

  List<String?> get userAnswers => [
    answer1,
    answer2,
    answer3,
    answer4,
    answer5,
  ];

  int getScore() {
    int score = 0;

    for (int i = 0; i < correctAnswers.length; i++) {
      if (userAnswers[i] == correctAnswers[i]) {
        score += 2;
      }
    }

    return score;
  }

  void selectAnswer(String answer) {
    setState(() {
      switch (currentScenario) {
        case 1:
          answer1 = answer;
          break;
        case 2:
          answer2 = answer;
          break;
        case 3:
          answer3 = answer;
          break;
        case 4:
          answer4 = answer;
          break;
        case 5:
          answer5 = answer;
          break;
      }
    });
  }

  String get backgroundImage {
    switch (currentScenario) {
      case 1:
        return 'assets/lesson-three-day3-act2-c1.png';
      case 2:
        return 'assets/lesson-three-day3-act2-c2.png';
      case 3:
        return 'assets/lesson-three-day3-act2-c3.png';
      case 4:
        return 'assets/lesson-three-day3-act2-c4.png';
      case 5:
        return 'assets/lesson-three-day3-act2-c5.png';
      default:
        return 'assets/lesson-three-day3-act2-c1.png';
    }
  }

  void nextScenario() {
    if (currentScenario < totalScenarios) {
      setState(() => currentScenario++);
    }
  }

  void previousScenario() {
    if (currentScenario > 1) {
      setState(() => currentScenario--);
    }
  }

  void submitAnswers() {
    showScorePopup();
  }

  void showScorePopup() {
    final int score = getScore();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final size = MediaQuery.of(context).size;

        final double popupWidth = clampDouble(size.width * 0.85, 280, 380);
        final double titleFont = clampDouble(size.width * 0.055, 20, 28);
        final double textFont = clampDouble(size.width * 0.04, 14, 18);

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: popupWidth,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6D8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.brown, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  score == 10 ? 'CONGRATULATIONS!' : 'GOOD JOB!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFont,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Your Score: $score / 10',
                  style: TextStyle(
                    fontSize: textFont + 2,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'The correct answers are:',
                  style: TextStyle(
                    fontSize: textFont,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '1. Ilaya\n'
                  '2. Ilaya\n'
                  '3. Ilaya\n'
                  '4. Ilawud\n'
                  '5. Ilawud',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: textFont,
                    height: 1.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 22),

                Transform.scale(
                  scale: 0.75,
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
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(
            color: isSelected ? Colors.yellowAccent : Colors.white,
            width: isSelected ? 4 : 3,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: label == 'ILAYA'
                    ? Colors.yellowAccent
                    : Colors.pinkAccent,
                size: iconSize,
              ),
              SizedBox(width: width * 0.04),
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
          border: Border.all(color: Colors.white, width: size * 0.07),
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

    final bool smallPhone = size.width < 380 || size.height < 700;
    final bool verySmallPhone = size.height < 620;

    final double sidePadding = clampDouble(size.width * 0.045, 10, 24);
    final double topPadding =
        safe.top + clampDouble(size.height * 0.012, 6, 16);

    final double topButtonSize = clampDouble(size.width * 0.115, 38, 58);

    final double choiceWidth = clampDouble(
      size.width * (smallPhone ? 0.34 : 0.32),
      105,
      145,
    );

    final double choiceHeight = clampDouble(
      size.height * (smallPhone ? 0.052 : 0.058),
      36,
      52,
    );

    final double choiceFont = clampDouble(size.width * 0.034, 11, 16);
    final double choiceIcon = clampDouble(size.width * 0.045, 15, 23);

    final double choicesBottom =
        safe.bottom +
        clampDouble(size.height * (verySmallPhone ? 0.085 : 0.095), 58, 92);

    final double buttonBottom =
        safe.bottom +
        clampDouble(size.height * (verySmallPhone ? 0.012 : 0.018), 8, 20);

    final double buttonScale = verySmallPhone
        ? 0.55
        : smallPhone
        ? 0.62
        : 0.72;

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
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: clampDouble(size.width * 0.06, 18, 35),
              runSpacing: 10,
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
            bottom: buttonBottom,
            child: Center(
              child: Transform.scale(
                scale: buttonScale,
                child: currentScenario < totalScenarios
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
