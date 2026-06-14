import 'package:flutter/material.dart';
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

  final List<String> correctAnswers = ['FACT', 'KUWENTO'];

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
  }

  int getScore() {
    int score = 0;
    if (answer1 == correctAnswers[0]) score += 5;
    if (answer2 == correctAnswers[1]) score += 5;
    return score;
  }

  void showScorePopup() {
    final int score = getScore();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.orange, width: 4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ISKOR MO',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$score / 10',
                  style: const TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  score == 10
                      ? 'Perfect! Magaling!'
                      : 'Good job! Subukan ulit para mas mataas ang score.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                plainButton(
                  label: 'OK',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Lesson1Screen(user: widget.user),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget plainButton({required String label, required VoidCallback onTap}) {
    final size = MediaQuery.of(context).size;
    final bool smallScreen = size.width < 400;

    final double buttonWidth = smallScreen ? 140 : 180;
    final double verticalPadding = smallScreen ? 10 : 14;
    final double fontSize = smallScreen ? 16 : 20;
    final double radius = smallScreen ? 14 : 18;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
    final bool smallScreen = MediaQuery.of(context).size.width < 400;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: isSelected ? height + (smallScreen ? 4 : 6) : height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(smallScreen ? 14 : 18),
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.white,
            width: isSelected ? (smallScreen ? 4 : 5) : 3,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.yellow.withOpacity(0.6)
                  : color == const Color(0xFF007ee6)
                  ? const Color(0xFF004fa3)
                  : const Color(0xFFc78200),
              blurRadius: isSelected ? (smallScreen ? 10 : 15) : 0,
              spreadRadius: isSelected ? (smallScreen ? 1 : 2) : 0,
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
                  fontSize: isSelected
                      ? titleSize + (smallScreen ? 1 : 2)
                      : titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: smallScreen ? 2 : 4),
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
    final bool smallScreen = size.width < 400;
    final buttonSize = smallScreen
        ? clampDouble(size.width * 0.12, 42, 52)
        : clampDouble(size.width * 0.14, 48, 66);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: smallScreen ? 3 : 4),
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

  void handleNextOrSubmit() {
    if (currentAnswer == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pumili muna ng sagot.')));
      return;
    }

    if (currentScenario == 1) {
      setState(() {
        currentScenario = 2;
      });
    } else {
      showScorePopup();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final bool smallScreen = w < 400;

    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-two-day1-act21.png'
        : 'assets/lesson-two-day1-act22.png';

    final double horizontalPadding = smallScreen
        ? clampDouble(w * 0.04, 10, 16)
        : clampDouble(w * 0.06, 16, 28);

    final double choiceWidth = smallScreen
        ? clampDouble(w * 0.34, 100, 140)
        : clampDouble(w * 0.38, 120, 190);

    final double choiceHeight = smallScreen
        ? clampDouble(h * 0.09, 65, 80)
        : clampDouble(h * 0.115, 75, 105);

    final double titleSize = smallScreen
        ? clampDouble(w * 0.045, 14, 18)
        : clampDouble(w * 0.055, 18, 24);

    final double subtitleSize = smallScreen
        ? clampDouble(w * 0.025, 8, 10)
        : clampDouble(w * 0.032, 10, 13);

    final double bottomPadding = smallScreen
        ? clampDouble(h * 0.045, 22, 40)
        : clampDouble(h * 0.08, 35, 75);

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
                        spacing: smallScreen
                            ? clampDouble(w * 0.025, 6, 10)
                            : clampDouble(w * 0.04, 10, 18),
                        runSpacing: smallScreen ? 8 : 12,
                        children: [
                          choiceButton(
                            label: 'FACT',
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
                            label: 'KUWENTO',
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

                      SizedBox(
                        height: smallScreen
                            ? 10
                            : clampDouble(h * 0.025, 12, 22),
                      ),

                      plainButton(
                        label: currentScenario == 1 ? 'NEXT' : 'SUBMIT',
                        onTap: handleNextOrSubmit,
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
