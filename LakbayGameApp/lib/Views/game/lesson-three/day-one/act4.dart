import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson3.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonThreeActFour extends StatefulWidget {
  final UserModel user;

  const LessonThreeActFour({super.key, required this.user});

  @override
  State<LessonThreeActFour> createState() => _LessonThreeActFourState();
}

class _LessonThreeActFourState extends State<LessonThreeActFour> {
  final List<QuestionData> questions = const [
    QuestionData(
      imagePath: 'assets/lesson-three-act4-1.png',
      correctAnswer: 'MALI',
    ),
    QuestionData(
      imagePath: 'assets/lesson-three-act4-2.png',
      correctAnswer: 'TAMA',
    ),
    QuestionData(
      imagePath: 'assets/lesson-three-act4-3.png',
      correctAnswer: 'TAMA',
    ),
    QuestionData(
      imagePath: 'assets/lesson-three-act4-4.png',
      correctAnswer: 'MALI',
    ),
  ];

  late List<String?> selectedAnswers;

  int currentQuestionIndex = 0;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    selectedAnswers = List<String?>.filled(questions.length, null);
  }

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  QuestionData get currentQuestion {
    return questions[currentQuestionIndex];
  }

  String? get currentAnswer {
    return selectedAnswers[currentQuestionIndex];
  }

  bool get isLastQuestion {
    return currentQuestionIndex == questions.length - 1;
  }

  int getScore() {
    int score = 0;

    for (int index = 0; index < questions.length; index++) {
      if (selectedAnswers[index] == questions[index].correctAnswer) {
        score += 5;
      }
    }

    return score;
  }

  void selectAnswer(String answer) {
    if (isSaving) return;

    setState(() {
      selectedAnswers[currentQuestionIndex] = answer;
    });
  }

  void showNoAnswerMessage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Pumili muna ng TAMA o MALI.',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex <= 0 || isSaving) return;

    setState(() {
      currentQuestionIndex--;
    });
  }

  Future<void> handleNextOrSubmit() async {
    if (currentAnswer == null) {
      showNoAnswerMessage();
      return;
    }

    if (!isLastQuestion) {
      setState(() {
        currentQuestionIndex++;
      });

      return;
    }

    await saveScoreAndFinish();
  }

  Future<void> saveScoreAndFinish() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    final int score = getScore();

    try {
      await ApiService.savePoints(
        userId: widget.user.id,
        countedPoints: score,
        lesson: 'Lesson 3',
        day: 'Day 1',
        act: 'Act 4',
      );

      if (!mounted) return;

      showResultPopup(score);
    } catch (error) {
      if (!mounted) return;

      /*
       * Continue even when the activity score
       * was already saved previously.
       */
      showResultPopup(score);
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void showResultPopup(int score) {
    final int maximumScore = questions.length * 5;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 24,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double dialogWidth = clampDouble(
                  constraints.maxWidth,
                  270,
                  420,
                );

                final double titleSize = clampDouble(
                  dialogWidth * 0.075,
                  22,
                  32,
                );

                final double scoreSize = clampDouble(
                  dialogWidth * 0.095,
                  28,
                  40,
                );

                final double buttonWidth = clampDouble(
                  dialogWidth * 0.48,
                  130,
                  190,
                );

                return SingleChildScrollView(
                  child: Container(
                    width: dialogWidth,
                    padding: EdgeInsets.symmetric(
                      horizontal: clampDouble(dialogWidth * 0.07, 18, 30),
                      vertical: clampDouble(dialogWidth * 0.09, 24, 36),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3C4),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.orange, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'CONGRATULATIONS!',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(
                          height: clampDouble(dialogWidth * 0.06, 14, 24),
                        ),
                        Text(
                          '$score / $maximumScore POINTS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: scoreSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          height: clampDouble(dialogWidth * 0.08, 20, 30),
                        ),
                        SizedBox(
                          width: buttonWidth,
                          height: clampDouble(dialogWidth * 0.14, 44, 56),
                          child: Button(
                            label: 'OK',
                            press: () {
                              Navigator.of(dialogContext).pop();

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) {
                                    return Lesson3Screen(user: widget.user);
                                  },
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
            ),
          ),
        );
      },
    );
  }

  Widget buildCircleButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isSaving ? null : onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: isSaving ? 0.55 : 1,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: clampDouble(size * 0.06, 2, 4),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: size * 0.52),
        ),
      ),
    );
  }

  Widget buildChoiceButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
    required double availableWidth,
    required double screenHeight,
  }) {
    final bool smallScreen = availableWidth < 340 || screenHeight < 650;

    final double buttonHeight = smallScreen
        ? clampDouble(screenHeight * 0.085, 54, 66)
        : clampDouble(screenHeight * 0.10, 64, 82);

    final double iconSize = smallScreen
        ? clampDouble(availableWidth * 0.075, 23, 29)
        : clampDouble(availableWidth * 0.085, 26, 34);

    final double fontSize = smallScreen
        ? clampDouble(availableWidth * 0.045, 14, 17)
        : clampDouble(availableWidth * 0.05, 16, 20);

    return Expanded(
      child: GestureDetector(
        onTap: isSaving ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: buttonHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              clampDouble(availableWidth * 0.04, 12, 18),
            ),
            border: Border.all(
              color: selected ? Colors.yellow : Colors.white,
              width: selected ? 5 : 3,
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
              Icon(icon, color: Colors.white, size: iconSize),
              SizedBox(width: clampDouble(availableWidth * 0.018, 5, 10)),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
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
      ),
    );
  }

  Widget buildQuestionCounter({
    required double availableWidth,
    required double screenHeight,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: clampDouble(availableWidth * 0.045, 14, 24),
        vertical: clampDouble(screenHeight * 0.009, 6, 10),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.orange, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Text(
        '${currentQuestionIndex + 1} / ${questions.length}',
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: clampDouble(availableWidth * 0.045, 15, 22),
        ),
      ),
    );
  }

  Widget buildBottomControls({
    required double availableWidth,
    required double screenHeight,
  }) {
    final bool smallHeight = screenHeight < 650;

    final double horizontalGap = clampDouble(availableWidth * 0.04, 10, 20);

    final double verticalGap = smallHeight
        ? clampDouble(screenHeight * 0.012, 7, 10)
        : clampDouble(screenHeight * 0.018, 10, 18);

    final double mainButtonWidth = clampDouble(availableWidth * 0.48, 135, 200);

    final double mainButtonHeight = smallHeight
        ? clampDouble(screenHeight * 0.06, 42, 48)
        : clampDouble(screenHeight * 0.065, 45, 56);

    return Container(
      padding: EdgeInsets.fromLTRB(
        clampDouble(availableWidth * 0.025, 8, 14),
        clampDouble(screenHeight * 0.012, 8, 14),
        clampDouble(availableWidth * 0.025, 8, 14),
        clampDouble(screenHeight * 0.012, 8, 14),
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              buildChoiceButton(
                label: 'TAMA',
                icon: Icons.check,
                color: Colors.green,
                selected: currentAnswer == 'TAMA',
                availableWidth: availableWidth,
                screenHeight: screenHeight,
                onTap: () {
                  selectAnswer('TAMA');
                },
              ),
              SizedBox(width: horizontalGap),
              buildChoiceButton(
                label: 'MALI',
                icon: Icons.close,
                color: Colors.red,
                selected: currentAnswer == 'MALI',
                availableWidth: availableWidth,
                screenHeight: screenHeight,
                onTap: () {
                  selectAnswer('MALI');
                },
              ),
            ],
          ),
          SizedBox(height: verticalGap),
          SizedBox(
            width: mainButtonWidth,
            height: mainButtonHeight,
            child: Button(
              label: isSaving
                  ? 'SAVING...'
                  : isLastQuestion
                  ? 'SUBMIT'
                  : 'NEXT',
              press: isSaving ? () {} : handleNextOrSubmit,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final Size screenSize = MediaQuery.sizeOf(context);
          final EdgeInsets safePadding = MediaQuery.paddingOf(context);

          final double availableWidth = constraints.maxWidth;
          final double availableHeight = constraints.maxHeight;

          final bool isTablet = availableWidth >= 600;
          final bool isLandscape = availableWidth > availableHeight;

          final double contentMaxWidth = isTablet
              ? clampDouble(availableWidth * 0.75, 500, 700)
              : availableWidth;

          final double sidePadding = clampDouble(
            availableWidth * 0.04,
            12,
            isTablet ? 32 : 22,
          );

          final double topButtonSize = clampDouble(
            availableWidth * 0.13,
            44,
            isTablet ? 70 : 62,
          );

          final double topPosition = safePadding.top + 8;

          final double bottomSpacing = clampDouble(
            availableHeight * 0.025,
            10,
            30,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  currentQuestion.imagePath,
                  fit: isLandscape ? BoxFit.cover : BoxFit.fill,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFFFF3C4),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Image not found:\n${currentQuestion.imagePath}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: clampDouble(availableWidth * 0.045, 16, 22),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (currentQuestionIndex > 0)
                Positioned(
                  top: topPosition,
                  left: sidePadding,
                  child: buildCircleButton(
                    icon: Icons.arrow_back,
                    color: Colors.blue,
                    size: topButtonSize,
                    onTap: goToPreviousQuestion,
                  ),
                ),

              Positioned(
                top: topPosition,
                right: sidePadding,
                child: buildCircleButton(
                  icon: Icons.home,
                  color: Colors.orange,
                  size: topButtonSize,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) {
                          return Lesson3Screen(user: widget.user);
                        },
                      ),
                    );
                  },
                ),
              ),

              Positioned(
                top: topPosition + clampDouble(topButtonSize * 0.12, 4, 8),
                left: topButtonSize + sidePadding + 8,
                right: topButtonSize + sidePadding + 8,
                child: Center(
                  child: buildQuestionCounter(
                    availableWidth: availableWidth,
                    screenHeight: availableHeight,
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: bottomSpacing,
                child: SafeArea(
                  top: false,
                  minimum: EdgeInsets.symmetric(horizontal: sidePadding),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: buildBottomControls(
                        availableWidth: contentMaxWidth,
                        screenHeight: screenSize.height,
                      ),
                    ),
                  ),
                ),
              ),

              if (isSaving)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.18),
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const CircularProgressIndicator(),
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

class QuestionData {
  final String imagePath;
  final String correctAnswer;

  const QuestionData({required this.imagePath, required this.correctAnswer});
}
