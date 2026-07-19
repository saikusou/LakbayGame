import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonThreeDayOneActTwo extends StatefulWidget {
  final UserModel user;

  const LessonThreeDayOneActTwo({super.key, required this.user});

  @override
  State<LessonThreeDayOneActTwo> createState() =>
      _LessonThreeDayOneActTwoState();
}

class _LessonThreeDayOneActTwoState extends State<LessonThreeDayOneActTwo> {
  static const int totalScenarios = 7;
  static const int pointsPerCorrectAnswer = 2;
  static const int maximumScore = totalScenarios * pointsPerCorrectAnswer;

  int currentScenarioIndex = 0;

  bool isSaving = false;
  bool isNavigating = false;
  bool scoreSaved = false;
  bool scorePopupOpen = false;

  final List<String?> userAnswers = List<String?>.filled(totalScenarios, null);

  final List<String> correctAnswers = const [
    'ILAYA',
    'ILAYA',
    'ILAYA',
    'ILAWUD',
    'ILAWUD',
    'ILAWUD',
    'ILAWUD',
  ];

  final List<String> backgroundImages = const [
    'assets/lesson-three-day3-act2-c1.png',
    'assets/lesson-three-day3-act2-c2.png',
    'assets/lesson-three-day3-act2-c3.png',
    'assets/lesson-three-day3-act2-c4.png',
    'assets/lesson-three-day3-act2-c5.png',
    'assets/lesson-three-day3-act2-c6.png',
    'assets/lesson-three-day3-act2-c7.png',
  ];

  bool get controlsDisabled {
    return isSaving || isNavigating || scorePopupOpen;
  }

  int get currentScenario => currentScenarioIndex + 1;

  String? get currentAnswer {
    return userAnswers[currentScenarioIndex];
  }

  String get backgroundImage {
    return backgroundImages[currentScenarioIndex];
  }

  bool get isLastScenario {
    return currentScenarioIndex == totalScenarios - 1;
  }

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  int getScore() {
    int score = 0;

    for (int index = 0; index < correctAnswers.length; index++) {
      if (userAnswers[index] == correctAnswers[index]) {
        score += pointsPerCorrectAnswer;
      }
    }

    return score;
  }

  Future<void> savePoints({required int score}) async {
    await ApiService.savePoints(
      userId: widget.user.id,
      countedPoints: score,
      lesson: 'Lesson 3',
      day: 'Day 3',
      act: 'Act 2',
    );
  }

  bool isDuplicateScoreError(Object error) {
    final String message = error.toString().toLowerCase();

    return message.contains('409') ||
        message.contains('already completed') ||
        message.contains('already recorded') ||
        message.contains('activity already completed') ||
        message.contains('duplicate');
  }

  void showMessage(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message), duration: duration));
  }

  void selectAnswer(String answer) {
    if (controlsDisabled) return;

    setState(() {
      userAnswers[currentScenarioIndex] = answer;
    });
  }

  void nextScenario() {
    if (controlsDisabled) return;

    if (currentAnswer == null) {
      showMessage(
        'Please choose an answer first.',
        duration: const Duration(seconds: 1),
      );
      return;
    }

    if (isLastScenario) return;

    setState(() {
      currentScenarioIndex++;
    });
  }

  void previousScenario() {
    if (controlsDisabled || currentScenarioIndex == 0) {
      return;
    }

    setState(() {
      currentScenarioIndex--;
    });
  }

  void submitAnswers() {
    if (controlsDisabled) return;

    if (currentAnswer == null) {
      showMessage(
        'Please choose an answer first.',
        duration: const Duration(seconds: 1),
      );
      return;
    }

    final bool hasUnansweredQuestion = userAnswers.any(
      (String? answer) => answer == null,
    );

    if (hasUnansweredQuestion) {
      showMessage('Please answer all seven questions.');
      return;
    }

    showScorePopup();
  }

  Future<void> closeActivity() async {
    if (!mounted || isSaving || isNavigating) return;

    setState(() {
      isNavigating = true;
    });

    final NavigatorState rootNavigator = Navigator.of(
      context,
      rootNavigator: true,
    );

    // Return to the existing Lesson3Screen.
    if (rootNavigator.canPop()) {
      rootNavigator.pop();
    }
  }

  Future<void> completeActivity({required BuildContext dialogContext}) async {
    if (isSaving || isNavigating) return;

    setState(() {
      isSaving = true;
    });

    final int score = getScore();

    if (!scoreSaved) {
      try {
        await savePoints(score: score).timeout(const Duration(seconds: 10));

        scoreSaved = true;

        debugPrint('Score saved successfully.');
      } on TimeoutException catch (error) {
        debugPrint('Saving score timed out: $error');

        // Allow the player to continue.
      } catch (error, stackTrace) {
        if (isDuplicateScoreError(error)) {
          scoreSaved = true;

          debugPrint('Activity was already completed. Continuing.');
        } else {
          debugPrint('Saving score failed: $error');
          debugPrintStack(stackTrace: stackTrace);

          // Allow the player to continue even if saving fails.
        }
      }
    }

    if (!mounted) return;

    setState(() {
      isNavigating = true;
    });

    /*
     * dialogContext belongs to the score popup.
     * Pop it first so its modal barrier is removed.
     */
    final NavigatorState dialogNavigator = Navigator.of(
      dialogContext,
      rootNavigator: true,
    );

    if (dialogNavigator.canPop()) {
      dialogNavigator.pop();
    }

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    /*
     * Now close the activity.
     * The existing Lesson3Screen underneath will become visible.
     */
    final NavigatorState rootNavigator = Navigator.of(
      context,
      rootNavigator: true,
    );

    if (rootNavigator.canPop()) {
      rootNavigator.pop();
    }
  }

  Future<void> showScorePopup() async {
    if (controlsDisabled) return;

    final int score = getScore();

    setState(() {
      scorePopupOpen = true;
    });

    try {
      await showDialog<void>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          final Size size = MediaQuery.sizeOf(dialogContext);

          final double popupWidth = clampDouble(size.width * 0.86, 280, 390);

          final double titleFont = clampDouble(size.width * 0.055, 20, 28);

          final double textFont = clampDouble(size.width * 0.038, 13, 18);

          return PopScope(
            canPop: false,
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: popupWidth,
                  maxHeight: size.height * 0.88,
                ),
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          score == maximumScore
                              ? 'CONGRATULATIONS!'
                              : 'GOOD JOB!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: titleFont,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Your Score: $score / $maximumScore',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: textFont + 2,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'The correct answers are:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: textFont,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          correctAnswers
                              .asMap()
                              .entries
                              .map((MapEntry<int, String> entry) {
                                return '${entry.key + 1}. '
                                    '${formatAnswer(entry.value)}';
                              })
                              .join('\n'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: textFont,
                            height: 1.45,
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
                              completeActivity(dialogContext: dialogContext);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('Score popup error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (mounted && !isNavigating) {
        setState(() {
          scorePopupOpen = false;
          isSaving = false;
        });
      }
    }
  }

  String formatAnswer(String answer) {
    if (answer.isEmpty) return answer;

    return '${answer[0]}${answer.substring(1).toLowerCase()}';
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
      onTap: controlsDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
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
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.yellowAccent.withValues(alpha: 0.45)
                  : Colors.black26,
              blurRadius: isSelected ? 10 : 6,
              offset: const Offset(0, 3),
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
      onTap: controlsDisabled ? null : onTap,
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

  Widget scenarioIndicator({required double fontSize}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        '$currentScenario / $totalScenarios',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final EdgeInsets safe = MediaQuery.paddingOf(context);

    final bool smallPhone = size.width < 380 || size.height < 700;

    final bool verySmallPhone = size.height < 620;

    final double sidePadding = clampDouble(size.width * 0.045, 10, 24);

    final double topPadding =
        safe.top + clampDouble(size.height * 0.012, 6, 16);

    final double topButtonSize = clampDouble(size.width * 0.115, 38, 58);

    final double indicatorFont = clampDouble(size.width * 0.038, 13, 17);

    final double choiceWidth = clampDouble(
      size.width * (smallPhone ? 0.36 : 0.33),
      108,
      150,
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

    return PopScope(
      canPop: !isSaving && !isNavigating,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Image.asset(
                  backgroundImage,
                  key: ValueKey<String>(backgroundImage),
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        debugPrint('Background image error: $error');

                        return const ColoredBox(
                          color: Color(0xFFFFF6D8),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Colors.brown,
                            ),
                          ),
                        );
                      },
                ),
              ),
            ),

            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              child: Center(child: scenarioIndicator(fontSize: indicatorFont)),
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
                  child: isLastScenario
                      ? Button(label: 'SUBMIT', press: submitAnswers)
                      : Button(label: 'NEXT', press: nextScenario),
                ),
              ),
            ),

            if (currentScenarioIndex > 0)
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
                onTap: closeActivity,
              ),
            ),

            if (isSaving || isNavigating)
              const Positioned.fill(
                child: AbsorbPointer(
                  child: ColoredBox(
                    color: Colors.black26,
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
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
  }
}
