import 'package:flutter/material.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson1.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonOneDayOneActOne extends StatefulWidget {
  final UserModel user;

  const LessonOneDayOneActOne({super.key, required this.user});

  @override
  State<LessonOneDayOneActOne> createState() => _LessonOneDayOneActOneState();
}

class _LessonOneDayOneActOneState extends State<LessonOneDayOneActOne> {
  static const int totalScenarios = 3;
  static const int pointsPerCorrectAnswer = 5;
  static const int maximumScore = totalScenarios * pointsPerCorrectAnswer;

  int currentScenario = 1;

  String? answer1;
  String? answer2;
  String? answer3;

  bool isSaving = false;
  bool scoreSaved = false;
  bool dialogShown = false;

  final List<String> correctAnswers = const ['B', 'A', 'C'];

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  String? get currentAnswer {
    switch (currentScenario) {
      case 1:
        return answer1;
      case 2:
        return answer2;
      case 3:
        return answer3;
      default:
        return null;
    }
  }

  String get backgroundImage {
    switch (currentScenario) {
      case 1:
        return 'assets/lesson-one-day1-act2a.png';
      case 2:
        return 'assets/lesson-one-day1-act2b.png';
      default:
        return 'assets/lesson-one-day1-act2c.png';
    }
  }

  String get question {
    switch (currentScenario) {
      case 1:
        return 'Paano nakarating ang mga unang tao sa Pilipinas?';
      case 2:
        return 'Anong alamat o kwento ang naaalala ninyo?';
      default:
        return 'Bakit mahalaga ang lokasyon ng Pilipinas sa pagdating ng tao noon?';
    }
  }

  void selectAnswer(String answer) {
    if (isSaving) return;

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
      }
    });
  }

  int getScore() {
    int score = 0;

    if (answer1 == correctAnswers[0]) {
      score += pointsPerCorrectAnswer;
    }

    if (answer2 == correctAnswers[1]) {
      score += pointsPerCorrectAnswer;
    }

    if (answer3 == correctAnswers[2]) {
      score += pointsPerCorrectAnswer;
    }

    return score;
  }

  Future<void> handleSavePoints({required int totalScore}) async {
    if (scoreSaved || isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      await ApiService.savePoints(
        userId: widget.user.id,
        countedPoints: totalScore,
        lesson: 'Lesson 1',
        day: 'Day 1',
        act: 'Act 1',
      );

      scoreSaved = true;
    } catch (error) {
      debugPrint('Save points error: $error');

      /*
       * The score dialog is still shown if the backend returns an error,
       * including a duplicate-score response.
       */
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> finishActivity() async {
    if (isSaving || dialogShown) return;

    final int score = getScore();

    await handleSavePoints(totalScore: score);

    if (!mounted) return;

    dialogShown = true;
    await showScoreDialog(score);

    if (mounted) {
      dialogShown = false;
    }
  }

  void returnToLessonOne() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => Lesson1Screen(user: widget.user)),
    );
  }

  Future<void> showScoreDialog(int score) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFF9A825), width: 5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9A825),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CONGRATULATIONS!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFE65100),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Natapos mo ang gawain!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFF9A825),
                        width: 3,
                      ),
                    ),
                    child: Text(
                      '$score / $maximumScore Points',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: score >= 10 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    score == maximumScore
                        ? 'Perfect! Napakahusay mo!'
                        : 'Magaling! Subukan pang pagbutihin.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: 160,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Close the score dialog first.
                        Navigator.of(dialogContext).pop();

                        if (!mounted) return;

                        // Replace this activity with Lesson1Screen.
                        returnToLessonOne();
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text(
                        'CONTINUE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9A825),
                        foregroundColor: Colors.white,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
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

  void showSelectAnswerMessage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pumili muna ng sagot bago magpatuloy.')),
    );
  }

  Future<void> handleNextButton() async {
    if (isSaving) return;

    if (currentAnswer == null) {
      showSelectAnswerMessage();
      return;
    }

    if (currentScenario < totalScenarios) {
      setState(() {
        currentScenario++;
      });
      return;
    }

    await finishActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final Size size = Size(constraints.maxWidth, constraints.maxHeight);

          final double width = size.width;
          final double height = size.height;

          final bool smallScreen = height < 700;
          final bool smallWidth = width < 360;

          final double iconTop = clampDouble(height * 0.018, 10, 22);

          final double iconSide = clampDouble(width * 0.035, 10, 22);

          final double choicesBottom = smallScreen
              ? clampDouble(height * 0.09, 60, 85)
              : clampDouble(height * 0.11, 80, 110);

          final double nextButtonBottom = clampDouble(height * 0.025, 16, 34);

          final double nextButtonWidth = smallWidth
              ? clampDouble(width * 0.34, 105, 135)
              : clampDouble(width * 0.40, 125, 175);

          final double nextButtonHeight = clampDouble(height * 0.055, 38, 52);

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
                            if (isSaving) return;

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
                          if (isSaving) return;
                          returnToLessonOne();
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
                          SizedBox(height: clampDouble(height * 0.014, 8, 15)),
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
                            onPressed: isSaving ? null : handleNextButton,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF9A825),
                              disabledBackgroundColor: Colors.orange.shade200,
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    width: 23,
                                    height: 23,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    currentScenario < totalScenarios
                                        ? 'NEXT'
                                        : 'DONE',
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
    final double width = size.width;
    final double height = size.height;

    return Container(
      width: clampDouble(width * 0.84, 245, 370),
      padding: EdgeInsets.symmetric(
        horizontal: clampDouble(width * 0.035, 10, 18),
        vertical: clampDouble(height * 0.011, 7, 13),
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
          fontSize: clampDouble(width * 0.038, 13, 17),
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
    final bool isSelected;

    if (currentScenario == 1) {
      isSelected = answer1 == value;
    } else if (currentScenario == 2) {
      isSelected = answer2 == value;
    } else {
      isSelected = answer3 == value;
    }

    final double width = size.width;
    final double height = size.height;

    final bool smallWidth = width < 360;
    final bool smallHeight = height < 700;

    return GestureDetector(
      onTap: isSaving
          ? null
          : () {
              selectAnswer(value);
            },
      child: Container(
        width: smallWidth
            ? clampDouble(width * 0.74, 210, 265)
            : clampDouble(width * 0.78, 230, 335),
        height: smallHeight
            ? clampDouble(height * 0.047, 34, 41)
            : clampDouble(height * 0.052, 38, 48),
        margin: EdgeInsets.only(
          bottom: smallHeight
              ? clampDouble(height * 0.006, 4, 7)
              : clampDouble(height * 0.008, 5, 9),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: clampDouble(width * 0.025, 8, 14),
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
                    ? clampDouble(width * 0.032, 11, 13)
                    : clampDouble(width * 0.034, 12, 15),
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
    final double width = size.width;

    final double buttonSize = width < 360
        ? clampDouble(width * 0.12, 40, 50)
        : clampDouble(width * 0.13, 46, 64);

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
          size: clampDouble(width * 0.07, 23, 34),
        ),
      ),
    );
  }
}
