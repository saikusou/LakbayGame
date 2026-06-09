import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneDayOneActOne extends StatefulWidget {
  final UserModel user;

  const LessonOneDayOneActOne({super.key, required this.user});

  @override
  State<LessonOneDayOneActOne> createState() => _LessonOneDayOneActOneState();
}

class _LessonOneDayOneActOneState extends State<LessonOneDayOneActOne> {
  int currentScenario = 1;

  String? answer1;
  String? answer2;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
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
    required Size size,
    required String value,
    required String label,
    required Color color,
  }) {
    final bool isSelected = currentScenario == 1
        ? answer1 == value
        : answer2 == value;

    return GestureDetector(
      onTap: () => selectAnswer(value),
      child: Container(
        width: clampDouble(size.width * 0.82, 255, 340),
        height: clampDouble(size.height * 0.052, 40, 48),
        margin: EdgeInsets.only(bottom: clampDouble(size.height * 0.007, 4, 7)),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.white,
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
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: clampDouble(size.width * 0.032, 12, 14),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> answerChoices(Size size) {
    final double topMargin = clampDouble(size.height * 0.60, 20, 80);
    if (currentScenario == 1) {
      return [
        SizedBox(height: topMargin),
        choiceButton(
          size: size,
          value: 'A',
          label: 'A. Tumawid sa dagat',
          color: Colors.blue,
        ),
        choiceButton(
          size: size,
          value: 'B',
          label: 'B. Gumamit ng bangka',
          color: Colors.orange,
        ),
        choiceButton(
          size: size,
          value: 'C',
          label: 'C. Naglakbay mula sa ibang lugar',
          color: Colors.purple,
        ),
      ];
    }

    return [
      SizedBox(height: topMargin),
      choiceButton(
        size: size,
        value: 'A',
        label: 'A. Malakas at Maganda',
        color: Colors.blue,
      ),
      choiceButton(
        size: size,
        value: 'B',
        label: 'B. Alamat ng pinagmulan ng tao',
        color: Colors.orange,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-one-day1-act2a.png'
        : 'assets/lesson-one-day1-act2b.png';

    final double topSpace = currentScenario == 1
        ? clampDouble(size.height * 0.63, 370, 500)
        : clampDouble(size.height * 0.66, 390, 520);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(backgroundImage, fit: BoxFit.fill),
            ),

            SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: topSpace),

                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: answerChoices(size),
                        ),
                      ),

                      SizedBox(height: clampDouble(size.height * 0.008, 4, 8)),

                      Center(
                        child: SizedBox(
                          width: clampDouble(size.width * 0.42, 135, 175),
                          height: clampDouble(size.height * 0.055, 42, 52),
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
                      ),

                      SizedBox(height: clampDouble(size.height * 0.03, 20, 35)),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Stack(
                children: [
                  if (currentScenario == 2)
                    Positioned(
                      top: clampDouble(size.height * 0.02, 12, 22),
                      left: clampDouble(size.width * 0.04, 12, 22),
                      child: circleIconButton(
                        size: size,
                        color: Colors.blue,
                        icon: Icons.arrow_back,
                        onTap: () {
                          setState(() {
                            currentScenario = 1;
                          });
                        },
                      ),
                    ),

                  Positioned(
                    top: clampDouble(size.height * 0.02, 12, 22),
                    right: clampDouble(size.width * 0.04, 12, 22),
                    child: circleIconButton(
                      size: size,
                      color: Colors.orange,
                      icon: Icons.home,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget circleIconButton({
    required Size size,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final double buttonSize = clampDouble(size.width * 0.13, 48, 68);

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
        child: Icon(
          icon,
          color: Colors.white,
          size: clampDouble(size.width * 0.075, 26, 38),
        ),
      ),
    );
  }
}
