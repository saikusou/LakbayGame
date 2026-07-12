import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonOneDayThreeActTwo extends StatefulWidget {
  final UserModel user;

  const LessonOneDayThreeActTwo({super.key, required this.user});

  @override
  State<LessonOneDayThreeActTwo> createState() =>
      _LessonOneDayThreeActTwoState();
}

class _LessonOneDayThreeActTwoState extends State<LessonOneDayThreeActTwo> {
  int currentScenario = 1;

  String? answer1;
  String? answer2;
  String? answer3;

  bool isSaving = false;
  bool completionPopupOpened = false;

  final List<String> correctAnswers = ['B', 'B', 'B'];

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

  bool get hasCurrentAnswer => currentAnswer != null;

  bool get allQuestionsAnswered {
    return answer1 != null && answer2 != null && answer3 != null;
  }

  bool get isLastQuestion => currentScenario == 3;

  int getScore() {
    int score = 0;

    if (answer1 == correctAnswers[0]) {
      score += 5;
    }

    if (answer2 == correctAnswers[1]) {
      score += 5;
    }

    if (answer3 == correctAnswers[2]) {
      score += 5;
    }

    return score;
  }

  Future<void> handleSavePoints({required int totalScore}) async {
    await ApiService.savePoints(
      userId: widget.user.id,
      countedPoints: totalScore,
      lesson: 'Lesson 1',
      day: 'Day 3',
      act: 'Act 2',
    );
  }

  List<Map<String, String>> get currentChoices {
    switch (currentScenario) {
      case 1:
        return [
          {'letter': 'A', 'text': 'Pananaw ng may-akda'},
          {'letter': 'B', 'text': 'Austronesyano'},
          {'letter': 'C', 'text': 'Core Population'},
          {'letter': 'D', 'text': 'Kaalamang Bayan'},
        ];

      case 2:
        return [
          {'letter': 'A', 'text': 'Kaalamang Bayan'},
          {'letter': 'B', 'text': 'Austronesyano'},
          {'letter': 'C', 'text': 'Pananaw ng mambabasa'},
          {'letter': 'D', 'text': 'Core Population'},
        ];

      case 3:
        return [
          {'letter': 'A', 'text': 'Core Population'},
          {'letter': 'B', 'text': 'Kaalamang Bayan'},
          {'letter': 'C', 'text': 'Austronesyano'},
          {'letter': 'D', 'text': 'Pananaw ng may-akda'},
        ];

      default:
        return [];
    }
  }

  String get currentBackgroundImage {
    switch (currentScenario) {
      case 1:
        return 'assets/lesson-two-day3-act2a.png';

      case 2:
        return 'assets/lesson-two-day3-act2b.png';

      case 3:
        return 'assets/lesson-two-day3-act2c.png';

      default:
        return 'assets/lesson-two-day3-act2a.png';
    }
  }

  String get progressText {
    return '$currentScenario / 3';
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
      }
    });
  }

  void nextScenario() {
    if (!hasCurrentAnswer) {
      showSelectAnswerMessage();
      return;
    }

    if (currentScenario >= 3) {
      return;
    }

    setState(() {
      currentScenario++;
    });
  }

  void previousScenario() {
    if (currentScenario <= 1) {
      return;
    }

    setState(() {
      currentScenario--;
    });
  }

  void submitAnswers() {
    if (!allQuestionsAnswered) {
      showSelectAnswerMessage();
      return;
    }

    if (completionPopupOpened) {
      return;
    }

    setState(() {
      completionPopupOpened = true;
    });

    showCompletionPopup();
  }

  void showSelectAnswerMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Pumili muna ng sagot bago magpatuloy.',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
  }

  void showErrorMessage(Object error) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Hindi na-save ang puntos: $error',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void returnToLessonScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
      (route) => false,
    );
  }

  Future<void> saveScoreAndReturn({
    required BuildContext dialogContext,
    required StateSetter setDialogState,
  }) async {
    if (isSaving) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    setDialogState(() {});

    final int totalScore = getScore();

    try {
      await handleSavePoints(totalScore: totalScore);

      if (!mounted) {
        return;
      }

      Navigator.of(dialogContext, rootNavigator: true).pop();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isSaving = false;
      });

      setDialogState(() {});

      showErrorMessage(error);
    }
  }

  Future<void> showCompletionPopup() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            final MediaQueryData mediaQuery = MediaQuery.of(dialogContext);

            final Size screenSize = mediaQuery.size;

            final bool shortScreen = screenSize.height < 700;

            final double horizontalInset = clampDouble(
              screenSize.width * 0.04,
              12,
              24,
            );

            final double verticalInset = clampDouble(
              screenSize.height * 0.025,
              10,
              24,
            );

            final double availableHeight =
                screenSize.height -
                mediaQuery.padding.top -
                mediaQuery.padding.bottom -
                (verticalInset * 2);

            final double popupWidth = clampDouble(
              screenSize.width * 0.92,
              300,
              550,
            );

            final double popupHeight = availableHeight < 430
                ? availableHeight
                : clampDouble(availableHeight * 0.88, 430, 680);

            final double footerHeight = shortScreen ? 64 : 76;

            final double okButtonWidth = clampDouble(
              popupWidth * 0.42,
              130,
              185,
            );

            final double okButtonHeight = shortScreen ? 42 : 48;

            final double closeButtonSize = clampDouble(
              popupWidth * 0.09,
              36,
              44,
            );

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(
                horizontal: horizontalInset,
                vertical: verticalInset,
              ),
              child: Container(
                width: popupWidth,
                height: popupHeight,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.blue, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              'assets/lesson-one-day3-act2.png',
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),

                          Positioned(
                            top: shortScreen ? 65 : 90,
                            left: 15,
                            right: 15,
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: shortScreen ? 14 : 20,
                                  vertical: shortScreen ? 6 : 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'SCORE: ${getScore()} / 15',
                                  style: TextStyle(
                                    fontSize: clampDouble(
                                      popupWidth * 0.052,
                                      17,
                                      24,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 10,
                            right: 10,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: isSaving
                                    ? null
                                    : () {
                                        Navigator.of(
                                          dialogContext,
                                          rootNavigator: true,
                                        ).pop();
                                      },
                                customBorder: const CircleBorder(),
                                child: Container(
                                  width: closeButtonSize,
                                  height: closeButtonSize,
                                  decoration: BoxDecoration(
                                    color: isSaving ? Colors.grey : Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: clampDouble(
                                      closeButtonSize * 0.55,
                                      20,
                                      27,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Separate footer so the OK button
                    // cannot overlap the image contents.
                    Container(
                      width: double.infinity,
                      height: footerHeight,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: shortScreen ? 10 : 13,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.blue.shade200,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: okButtonWidth,
                          height: okButtonHeight,
                          child: ElevatedButton(
                            onPressed: isSaving
                                ? null
                                : () {
                                    saveScoreAndReturn(
                                      dialogContext: dialogContext,
                                      setDialogState: setDialogState,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB300),
                              disabledBackgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'OK',
                                    style: TextStyle(
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
            );
          },
        );
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      completionPopupOpened = false;
      isSaving = false;
    });
  }

  Widget plainButton({
    required String label,
    required VoidCallback? onPressed,
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB300),
          disabledBackgroundColor: Colors.orange.shade200,
          foregroundColor: Colors.white,
          elevation: onPressed == null ? 0 : 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required Size screenSize,
  }) {
    final double buttonSize = clampDouble(screenSize.width * 0.12, 42, 58);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
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
                blurRadius: 7,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: clampDouble(buttonSize * 0.55, 23, 33),
          ),
        ),
      ),
    );
  }

  Widget answerChoice({
    required String letter,
    required String text,
    required Size screenSize,
    required bool shortScreen,
  }) {
    final bool selected = currentAnswer == letter;

    final double choiceWidth = clampDouble(screenSize.width * 0.88, 275, 420);

    final double choiceHeight = shortScreen
        ? clampDouble(screenSize.height * 0.052, 38, 44)
        : clampDouble(screenSize.height * 0.06, 45, 58);

    final double circleSize = shortScreen
        ? clampDouble(screenSize.width * 0.065, 25, 31)
        : clampDouble(screenSize.width * 0.075, 29, 37);

    final double textSize = shortScreen
        ? clampDouble(screenSize.width * 0.034, 12, 15)
        : clampDouble(screenSize.width * 0.04, 14, 18);

    return GestureDetector(
      onTap: () {
        selectAnswer(letter);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: choiceWidth,
        height: choiceHeight,
        margin: EdgeInsets.only(bottom: shortScreen ? 5 : 8),
        padding: EdgeInsets.symmetric(
          horizontal: clampDouble(screenSize.width * 0.025, 7, 11),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: selected ? Colors.green : Colors.blue,
            width: selected ? 3 : 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: selected ? Colors.green : Colors.blue.shade800,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: selected
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: clampDouble(circleSize * 0.60, 15, 21),
                      )
                    : Text(
                        letter,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: clampDouble(circleSize * 0.55, 14, 19),
                        ),
                      ),
              ),
            ),
            SizedBox(width: clampDouble(screenSize.width * 0.025, 8, 12)),
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: textSize,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget choicesPanel({required Size screenSize, required bool shortScreen}) {
    final double titleSize = shortScreen
        ? clampDouble(screenSize.width * 0.034, 11, 14)
        : clampDouble(screenSize.width * 0.038, 12, 16);

    final double buttonWidth = clampDouble(screenSize.width * 0.44, 135, 180);

    final double buttonHeight = shortScreen ? 38 : 45;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: clampDouble(screenSize.width * 0.88, 275, 420),
          margin: EdgeInsets.only(bottom: shortScreen ? 3 : 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PILIIN ANG TAMANG SAGOT.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: titleSize,
                  shadows: const [Shadow(color: Colors.black54, blurRadius: 3)],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Text(
                  progressText,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: currentChoices.map((choice) {
            return answerChoice(
              letter: choice['letter']!,
              text: choice['text']!,
              screenSize: screenSize,
              shortScreen: shortScreen,
            );
          }).toList(),
        ),
        SizedBox(height: shortScreen ? 4 : 10),
        plainButton(
          label: isLastQuestion ? 'ISUMITE' : 'NEXT',
          onPressed: hasCurrentAnswer
              ? isLastQuestion
                    ? submitAnswers
                    : nextScenario
              : null,
          width: buttonWidth,
          height: buttonHeight,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size screenSize = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          final bool shortScreen = screenSize.height < 700;

          final double topPadding = MediaQuery.of(context).padding.top;

          final double iconTop =
              topPadding + clampDouble(screenSize.height * 0.012, 6, 14);

          final double sidePadding = clampDouble(
            screenSize.width * 0.04,
            12,
            20,
          );

          final double bottomPosition = shortScreen
              ? clampDouble(screenSize.height * 0.025, 12, 20)
              : clampDouble(screenSize.height * 0.05, 30, 55);

          return SizedBox.expand(
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Image.asset(
                      currentBackgroundImage,
                      key: ValueKey(currentBackgroundImage),
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                if (currentScenario > 1)
                  Positioned(
                    top: iconTop,
                    left: sidePadding,
                    child: circleButton(
                      icon: Icons.arrow_back,
                      color: Colors.blue,
                      screenSize: screenSize,
                      onTap: previousScenario,
                    ),
                  ),
                Positioned(
                  top: iconTop,
                  right: sidePadding,
                  child: circleButton(
                    icon: Icons.home,
                    color: Colors.orange,
                    screenSize: screenSize,
                    onTap: returnToLessonScreen,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: bottomPosition,
                  child: SafeArea(
                    top: false,
                    child: choicesPanel(
                      screenSize: screenSize,
                      shortScreen: shortScreen,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
