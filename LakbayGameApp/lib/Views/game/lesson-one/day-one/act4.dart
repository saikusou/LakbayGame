import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson1.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonOneActFour extends StatefulWidget {
  final UserModel user;

  const LessonOneActFour({super.key, required this.user});

  @override
  State<LessonOneActFour> createState() => _LessonOneActFourState();
}

class _LessonOneActFourState extends State<LessonOneActFour> {
  int currentQuestionIndex = 0;

  bool isSaving = false;

  static const int pointsPerQuestion = 5;

  final List<String> correctAnswers = ['TAMA', 'MALI', 'TAMA', 'MALI', 'TAMA'];

  final List<String?> selectedAnswers = List<String?>.filled(5, null);

  final List<String> backgroundImages = [
    'assets/lesson-one-day1-act4a.png',
    'assets/lesson-one-day1-act4b.png',
    'assets/lesson-one-day1-act4c.png',
    'assets/lesson-one-day1-act4d.png',
    'assets/lesson-one-day1-act4e.png',
  ];

  final List<String> popupImages = [
    'assets/lesson-one-day1-act4-q1-tama.png',
    'assets/lesson-one-day1-act4-q2-mali.png',
    'assets/lesson-one-day1-act4-q3-tama.png',
    'assets/lesson-one-day1-act4-q4-mali.png',
    'assets/lesson-one-day1-act4-q5-tama.png',
  ];

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  int get currentQuestionNumber => currentQuestionIndex + 1;

  String? get currentAnswer => selectedAnswers[currentQuestionIndex];

  bool get isLastQuestion {
    return currentQuestionIndex == correctAnswers.length - 1;
  }

  int getScore() {
    int score = 0;

    for (int index = 0; index < correctAnswers.length; index++) {
      if (selectedAnswers[index] == correctAnswers[index]) {
        score += pointsPerQuestion;
      }
    }

    return score;
  }

  int getCorrectCount() {
    int correctCount = 0;

    for (int index = 0; index < correctAnswers.length; index++) {
      if (selectedAnswers[index] == correctAnswers[index]) {
        correctCount++;
      }
    }

    return correctCount;
  }

  Future<void> handleSavePoints({required int totalScore}) async {
    await ApiService.savePoints(
      userId: widget.user.id,
      countedPoints: totalScore,
      lesson: 'Lesson 1',
      day: 'Day 1',
      act: 'Act 4',
    );
  }

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = answer;
    });

    showAnswerPopup();
  }

  void showNoAnswerMessage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Please select TAMA or MALI for Question '
          '$currentQuestionNumber.',
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
    );
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex <= 0) {
      return;
    }

    setState(() {
      currentQuestionIndex--;
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex >= correctAnswers.length - 1) {
      return;
    }

    setState(() {
      currentQuestionIndex++;
    });
  }

  Widget smallButton({
    required String label,
    required VoidCallback? onTap,
    required double width,
    required double height,
    required double fontSize,
  }) {
    final bool disabled = onTap == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: disabled
                ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                : const LinearGradient(
                    colors: [Color(0xFFFFC857), Color(0xFFFFA500)],
                  ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: disabled
                ? []
                : const [
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
      ),
    );
  }

  void showAnswerPopup() {
    final Size size = MediaQuery.of(context).size;

    final double width = size.width;
    final double height = size.height;

    final String popupImage = popupImages[currentQuestionIndex];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: clampDouble(width * 0.04, 10, 22),
            vertical: clampDouble(height * 0.025, 10, 24),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 520,
              maxHeight: height * 0.88,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4D8),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.orange, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: Image.asset(
                        popupImage,
                        width: double.infinity,
                        height: clampDouble(height * 0.58, 280, 500),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: clampDouble(height * 0.48, 240, 400),
                            padding: const EdgeInsets.all(20),
                            alignment: Alignment.center,
                            color: const Color(0xFFFFF4D8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  color: Colors.orange,
                                  size: clampDouble(width * 0.20, 70, 110),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Image not found:\n$popupImage',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        clampDouble(width * 0.04, 14, 22),
                        clampDouble(height * 0.012, 8, 14),
                        clampDouble(width * 0.04, 14, 22),
                        clampDouble(height * 0.02, 14, 22),
                      ),
                      child: smallButton(
                        label: 'OK',
                        width: clampDouble(width * 0.23, 80, 120),
                        height: clampDouble(height * 0.052, 38, 50),
                        fontSize: clampDouble(width * 0.04, 14, 18),
                        onTap: () {
                          Navigator.pop(dialogContext);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showScorePopup() {
    final Size size = MediaQuery.of(context).size;

    final double width = size.width;
    final double height = size.height;

    final int score = getScore();
    final int correctCount = getCorrectCount();
    final int maximumScore = correctAnswers.length * pointsPerQuestion;

    isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(
                horizontal: clampDouble(width * 0.06, 16, 30),
                vertical: clampDouble(height * 0.03, 16, 30),
              ),
              child: SingleChildScrollView(
                child: Container(
                  width: clampDouble(width * 0.84, 280, 420),
                  padding: EdgeInsets.all(clampDouble(width * 0.06, 18, 28)),
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
                      Icon(
                        Icons.emoji_events,
                        color: Colors.amber,
                        size: clampDouble(width * 0.18, 65, 95),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'CONGRATULATIONS!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: clampDouble(width * 0.065, 22, 34),
                        ),
                      ),
                      SizedBox(height: clampDouble(height * 0.018, 10, 18)),
                      Text(
                        'Your Score',
                        style: TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                          fontSize: clampDouble(width * 0.05, 18, 26),
                        ),
                      ),
                      SizedBox(height: clampDouble(height * 0.012, 8, 14)),
                      Text(
                        '$score / $maximumScore',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: clampDouble(width * 0.09, 34, 50),
                        ),
                      ),
                      SizedBox(height: clampDouble(height * 0.01, 6, 12)),
                      Text(
                        '$correctCount out of '
                        '${correctAnswers.length} correct answers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: clampDouble(width * 0.04, 14, 20),
                        ),
                      ),
                      SizedBox(height: clampDouble(height * 0.025, 16, 26)),
                      if (isSaving)
                        const Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text(
                              'Saving your score...',
                              style: TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      else
                        smallButton(
                          label: 'OK',
                          width: clampDouble(width * 0.32, 110, 150),
                          height: clampDouble(height * 0.055, 40, 52),
                          fontSize: clampDouble(width * 0.04, 14, 18),
                          onTap: () async {
                            setDialogState(() {
                              isSaving = true;
                            });

                            try {
                              await handleSavePoints(totalScore: score);

                              if (!mounted) {
                                return;
                              }

                              Navigator.pop(dialogContext);
                              goHome();
                            } catch (error) {
                              if (!mounted) {
                                return;
                              }

                              setDialogState(() {
                                isSaving = false;
                              });

                              ScaffoldMessenger.of(
                                this.context,
                              ).hideCurrentSnackBar();

                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to save score: $error'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void submitAnswers() {
    final bool hasUnansweredQuestion = selectedAnswers.any(
      (answer) => answer == null,
    );

    if (hasUnansweredQuestion) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all five questions first.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );

      final int firstUnansweredIndex = selectedAnswers.indexWhere(
        (answer) => answer == null,
      );

      if (firstUnansweredIndex >= 0) {
        setState(() {
          currentQuestionIndex = firstUnansweredIndex;
        });
      }

      return;
    }

    showScorePopup();
  }

  void nextOrDone() {
    if (currentAnswer == null) {
      showNoAnswerMessage();
      return;
    }

    if (isLastQuestion) {
      submitAnswers();
    } else {
      goToNextQuestion();
    }
  }

  Widget circleButton({
    required Size size,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final double shortestSide = size.shortestSide;

    final double buttonSize = clampDouble(shortestSide * 0.12, 38, 58);

    final double iconSize = clampDouble(shortestSide * 0.065, 20, 32);

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

    final double buttonWidth = clampDouble(size.width * 0.32, 96, 145);

    final double buttonHeight = clampDouble(
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: isSelected ? buttonWidth + 4 : buttonWidth,
          height: isSelected ? buttonHeight + 3 : buttonHeight,
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
                    ? Colors.yellow.withOpacity(0.70)
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
      ),
    );
  }

  Widget questionIndicator(Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: clampDouble(size.width * 0.035, 12, 20),
        vertical: clampDouble(size.height * 0.008, 5, 10),
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        'Question $currentQuestionNumber of '
        '${correctAnswers.length}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: clampDouble(size.shortestSide * 0.035, 12, 17),
        ),
      ),
    );
  }

  Widget buildProgressIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(correctAnswers.length, (index) {
        final bool isCurrent = index == currentQuestionIndex;

        final bool isAnswered = selectedAnswers[index] != null;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isCurrent ? 22 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: isCurrent
                ? Colors.orange
                : isAnswered
                ? Colors.green
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.brown, width: 1.5),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String backgroundImage = backgroundImages[currentQuestionIndex];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final Size size = Size(constraints.maxWidth, constraints.maxHeight);

          final double width = size.width;
          final double height = size.height;

          final bool verySmall = height < 620;
          final bool small = height < 700;

          final double bottomButtonWidth = clampDouble(width * 0.28, 90, 135);

          final double bottomButtonHeight = clampDouble(height * 0.052, 36, 50);

          final double bottomButtonFont = clampDouble(width * 0.038, 13, 18);

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  backgroundImage,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFFFE5A3),
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Text(
                        'Image not found:\n$backgroundImage',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                ),
              ),

              SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    Positioned(
                      top: clampDouble(height * 0.005, 4, 14),
                      right: clampDouble(width * 0.03, 8, 18),
                      child: circleButton(
                        icon: Icons.home,
                        color: Colors.orange,
                        size: size,
                        onTap: goHome,
                      ),
                    ),
                    if (currentQuestionIndex > 0)
                      Positioned(
                        top: clampDouble(height * 0.005, 4, 14),
                        left: clampDouble(width * 0.03, 8, 18),
                        child: circleButton(
                          size: size,
                          icon: Icons.arrow_back,
                          color: Colors.blue,
                          onTap: goToPreviousQuestion,
                        ),
                      ),
                  ],
                ),
              ),

              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: clampDouble(height * 0.01, 7, 15),
                    ),
                    child: questionIndicator(size),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  top: false,
                  minimum: EdgeInsets.only(
                    left: clampDouble(width * 0.03, 8, 20),
                    right: clampDouble(width * 0.03, 8, 20),
                    bottom: clampDouble(height * 0.008, 5, 14),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: clampDouble(width * 0.025, 8, 16),
                      vertical: clampDouble(height * 0.012, 8, 14),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildProgressIndicator(),
                          SizedBox(
                            height: verySmall
                                ? 5
                                : small
                                ? 8
                                : 12,
                          ),
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
                                  onTap: () {
                                    selectAnswer('TAMA');
                                  },
                                ),
                                SizedBox(
                                  width: clampDouble(width * 0.06, 14, 32),
                                ),
                                choiceButton(
                                  size: size,
                                  label: 'MALI',
                                  color: Colors.red,
                                  isSelected: currentAnswer == 'MALI',
                                  onTap: () {
                                    selectAnswer('MALI');
                                  },
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
                            label: isLastQuestion ? 'DONE' : 'NEXT',
                            width: bottomButtonWidth,
                            height: bottomButtonHeight,
                            fontSize: bottomButtonFont,
                            onTap: nextOrDone,
                          ),
                        ],
                      ),
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
