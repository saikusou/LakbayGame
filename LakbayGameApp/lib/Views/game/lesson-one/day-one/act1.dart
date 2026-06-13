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
  String? answer3;

  final List<String> correctAnswers = ['C', 'B', 'C'];

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

  int getScore() {
    int score = 0;

    if (answer1 == correctAnswers[0]) score++;
    if (answer2 == correctAnswers[1]) score++;
    if (answer3 == correctAnswers[2]) score++;

    return score;
  }

  void showScoreDialog() {
    final int score = getScore();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Resulta',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Nakakuha ka ng $score sa 3 tamang sagot!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String get backgroundImage {
    if (currentScenario == 1) {
      return 'assets/lesson-one-day1-act2a.png';
    } else if (currentScenario == 2) {
      return 'assets/lesson-one-day1-act2b.png';
    } else {
      return 'assets/lesson-one-day1-act2c.png';
    }
  }

  String get question {
    if (currentScenario == 1) {
      return 'Paano nakarating ang mga unang tao sa Pilipinas?';
    } else if (currentScenario == 2) {
      return 'Anong alamat o kwento ang naaalala ninyo?';
    } else {
      return 'Bakit mahalaga ang lokasyon ng Pilipinas sa pagdating ng tao noon?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          final w = size.width;
          final h = size.height;

          final bool smallScreen = h < 700;
          final bool smallWidth = w < 360;

          final double iconTop = clampDouble(h * 0.018, 10, 22);
          final double iconSide = clampDouble(w * 0.035, 10, 22);

          final double choicesBottom = smallScreen
              ? clampDouble(h * 0.09, 60, 85)
              : clampDouble(h * 0.11, 80, 110);

          final double nextButtonBottom = clampDouble(h * 0.025, 16, 34);

          final double nextButtonWidth = smallWidth
              ? clampDouble(w * 0.34, 105, 135)
              : clampDouble(w * 0.40, 125, 175);

          final double nextButtonHeight = clampDouble(h * 0.055, 38, 52);

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(backgroundImage, fit: BoxFit.fill),
              ),

              SafeArea(
                child: Stack(
                  children: [
                    if (currentScenario > 1)
                      Positioned(
                        top: iconTop,
                        left: iconSide,
                        child: circleIconButton(
                          size: size,
                          color: Colors.blue,
                          icon: Icons.arrow_back,
                          onTap: () {
                            setState(() {
                              currentScenario--;
                            });
                          },
                        ),
                      ),

                    Positioned(
                      top: iconTop,
                      right: iconSide,
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

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: choicesBottom,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          questionText(size),
                          SizedBox(height: clampDouble(h * 0.014, 8, 15)),
                          ...answerChoices(size),
                        ],
                      ),
                    ),

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: nextButtonBottom,
                      child: Center(
                        child: SizedBox(
                          width: nextButtonWidth,
                          height: nextButtonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (currentAnswer == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Pumili muna ng sagot bago magpatuloy.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (currentScenario < 3) {
                                setState(() {
                                  currentScenario++;
                                });
                              } else {
                                showScoreDialog();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF9A825),
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              currentScenario < 3 ? 'NEXT' : 'SUBMIT',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget questionText(Size size) {
    final w = size.width;
    final h = size.height;

    return Container(
      width: clampDouble(w * 0.84, 245, 370),
      padding: EdgeInsets.symmetric(
        horizontal: clampDouble(w * 0.035, 10, 18),
        vertical: clampDouble(h * 0.011, 7, 13),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Text(
        question,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: clampDouble(w * 0.038, 13, 17),
        ),
      ),
    );
  }

  List<Widget> answerChoices(Size size) {
    if (currentScenario == 1) {
      return [
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
          color: Colors.blue,
        ),
        choiceButton(
          size: size,
          value: 'C',
          label: 'C. Naglakbay mula sa ibang lugar',
          color: Colors.blue,
        ),
      ];
    }

    if (currentScenario == 2) {
      return [
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
          color: Colors.blue,
        ),
        choiceButton(
          size: size,
          value: 'C',
          label: 'C. Isang uri ng pamumuhay',
          color: Colors.blue,
        ),
      ];
    }

    return [
      choiceButton(
        size: size,
        value: 'A',
        label: 'A. Pangingisda',
        color: Colors.blue,
      ),
      choiceButton(
        size: size,
        value: 'B',
        label: 'B. Pagsasaka',
        color: Colors.blue,
      ),
      choiceButton(
        size: size,
        value: 'C',
        label: 'C. Pakikipagkalakalan',
        color: Colors.blue,
      ),
    ];
  }

  Widget choiceButton({
    required Size size,
    required String value,
    required String label,
    required Color color,
  }) {
    final bool isSelected = currentScenario == 1
        ? answer1 == value
        : currentScenario == 2
        ? answer2 == value
        : answer3 == value;

    final w = size.width;
    final h = size.height;

    final bool smallWidth = w < 360;
    final bool smallHeight = h < 700;

    return GestureDetector(
      onTap: () => selectAnswer(value),
      child: Container(
        width: smallWidth
            ? clampDouble(w * 0.74, 210, 265)
            : clampDouble(w * 0.78, 230, 335),
        height: smallHeight
            ? clampDouble(h * 0.047, 34, 41)
            : clampDouble(h * 0.052, 38, 48),
        margin: EdgeInsets.only(
          bottom: smallHeight
              ? clampDouble(h * 0.006, 4, 7)
              : clampDouble(h * 0.008, 5, 9),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: clampDouble(w * 0.025, 8, 14),
        ),
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
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: smallWidth
                    ? clampDouble(w * 0.032, 11, 13)
                    : clampDouble(w * 0.034, 12, 15),
              ),
            ),
          ),
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
    final w = size.width;

    final double buttonSize = w < 360
        ? clampDouble(w * 0.12, 40, 50)
        : clampDouble(w * 0.13, 46, 64);

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
          size: clampDouble(w * 0.07, 23, 34),
        ),
      ),
    );
  }
}
