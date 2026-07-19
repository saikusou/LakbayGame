import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson1.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonOneDayTwoActTwo extends StatefulWidget {
  final UserModel user;

  const LessonOneDayTwoActTwo({super.key, required this.user});

  @override
  State<LessonOneDayTwoActTwo> createState() => _LessonOneDayTwoActTwoState();
}

class _LessonOneDayTwoActTwoState extends State<LessonOneDayTwoActTwo> {
  int currentQuestionIndex = 0;

  bool isSaving = false;
  bool scorePopupOpened = false;

  final List<String?> selectedAnswers = List<String?>.filled(5, null);

  final List<String> correctAnswers = [
    'KUWENTO',
    'FACT',
    'KUWENTO',
    'FACT',
    'FACT',
  ];

  final List<String> backgroundImages = [
    'assets/lesson-two-day1-act21.png',
    'assets/lesson-two-day1-act22.png',
    'assets/lesson-two-day1-act23.png',
    'assets/lesson-two-day1-act24.png',
    'assets/lesson-two-day1-act25.png',
  ];

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  String? get currentAnswer {
    return selectedAnswers[currentQuestionIndex];
  }

  bool get isLastQuestion {
    return currentQuestionIndex == backgroundImages.length - 1;
  }

  Future<void> handleSavePoints({required int totalScore}) async {
    await ApiService.savePoints(
      userId: widget.user.id,
      countedPoints: totalScore,
      lesson: 'Lesson 1',
      day: 'Day 2',
      act: 'Act 2',
    );
  }

  void selectAnswer(String answer) {
    if (isSaving) return;

    setState(() {
      selectedAnswers[currentQuestionIndex] = answer;
    });
  }

  int getScore() {
    int score = 0;

    for (int index = 0; index < correctAnswers.length; index++) {
      if (selectedAnswers[index] == correctAnswers[index]) {
        score += 5;
      }
    }

    return score;
  }

  Future<void> showScorePopup() async {
    if (scorePopupOpened || !mounted) return;

    scorePopupOpened = true;

    final int score = getScore();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final Size screenSize = MediaQuery.sizeOf(context);

            final bool smallScreen = screenSize.width < 400;

            final double popupWidth = clampDouble(
              screenSize.width * 0.88,
              280,
              430,
            );

            final double popupPadding = smallScreen ? 18 : 26;

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(
                horizontal: smallScreen ? 16 : 24,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: popupWidth,
                  maxHeight: screenSize.height * 0.85,
                ),
                child: Container(
                  width: popupWidth,
                  padding: EdgeInsets.all(popupPadding),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFCF4),
                    borderRadius: BorderRadius.circular(smallScreen ? 20 : 26),
                    border: Border.all(
                      color: Colors.orange,
                      width: smallScreen ? 3 : 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'ISKOR MO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: smallScreen ? 24 : 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        SizedBox(height: smallScreen ? 12 : 18),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$score / 25',
                            style: TextStyle(
                              fontSize: smallScreen ? 40 : 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(height: smallScreen ? 10 : 14),
                        Text(
                          score == 25
                              ? 'Perfect! Magaling!'
                              : score >= 15
                              ? 'Good job! Mahusay ang iyong ginawa.'
                              : 'Subukan ulit para mas mataas ang score.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: smallScreen ? 14 : 17,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: smallScreen ? 18 : 26),
                        buildPlainButton(
                          context: context,
                          label: isSaving ? 'SAVING...' : 'OK',
                          enabled: !isSaving,
                          onTap: () async {
                            if (isSaving) return;

                            setState(() {
                              isSaving = true;
                            });

                            setDialogState(() {});

                            try {
                              await handleSavePoints(totalScore: score);

                              if (!mounted) return;

                              Navigator.of(dialogContext).pop();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      Lesson1Screen(user: widget.user),
                                ),
                              );
                            } catch (error) {
                              if (!mounted) return;

                              setState(() {
                                isSaving = false;
                              });

                              setDialogState(() {});

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to save score: $error',
                                    ),
                                  ),
                                );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (mounted && !isSaving) {
      scorePopupOpened = false;
    }
  }

  void handleNextOrSubmit() {
    if (currentAnswer == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Pumili muna ng sagot.'),
            behavior: SnackBarBehavior.floating,
          ),
        );

      return;
    }

    if (isLastQuestion) {
      showScorePopup();
      return;
    }

    setState(() {
      currentQuestionIndex++;
    });
  }

  void handlePreviousQuestion() {
    if (currentQuestionIndex == 0 || isSaving) return;

    setState(() {
      currentQuestionIndex--;
    });
  }

  void goBackToLesson() {
    if (isSaving) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
    );
  }

  Widget buildPlainButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    bool enabled = true,
    double? width,
  }) {
    final Size screenSize = MediaQuery.sizeOf(context);

    final bool smallPhone = screenSize.width < 360;
    final bool tablet = screenSize.width >= 600;

    final double buttonWidth =
        width ??
        (tablet
            ? 220
            : smallPhone
            ? 135
            : 180);

    final double buttonHeight = tablet
        ? 60
        : smallPhone
        ? 46
        : 52;

    final double fontSize = tablet
        ? 22
        : smallPhone
        ? 15
        : 19;

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: enabled ? 1 : 0.55,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: buttonWidth,
              height: buttonHeight,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(smallPhone ? 14 : 18),
                border: Border.all(
                  color: Colors.white,
                  width: smallPhone ? 2.5 : 3,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 7,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChoiceButton({
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
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label, $subLabel',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSaving ? null : onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? Colors.yellow : Colors.white,
                width: isSelected ? 5 : 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? Colors.yellow.withOpacity(0.65)
                      : Colors.black26,
                  blurRadius: isSelected ? 14 : 6,
                  spreadRadius: isSelected ? 1 : 0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            transform: isSelected
                ? Matrix4.translationValues(0, -3, 0)
                : Matrix4.identity(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSelected ? titleSize + 2 : titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      subLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required double size,
    required String semanticLabel,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSaving ? null : onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: size < 50 ? 3 : 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: size * 0.54),
          ),
        ),
      ),
    );
  }

  Widget buildQuestionIndicator({required double screenWidth}) {
    final bool smallPhone = screenWidth < 360;
    final bool tablet = screenWidth >= 600;

    return Container(
      constraints: BoxConstraints(maxWidth: screenWidth * 0.48),
      padding: EdgeInsets.symmetric(
        horizontal: smallPhone
            ? 10
            : tablet
            ? 22
            : 15,
        vertical: smallPhone
            ? 6
            : tablet
            ? 11
            : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.58),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'TANONG ${currentQuestionIndex + 1} / '
          '${backgroundImages.length}',
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontSize: smallPhone
                ? 12
                : tablet
                ? 19
                : 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildTopControls({
    required double screenWidth,
    required double screenHeight,
    required bool landscape,
  }) {
    final bool smallPhone = screenWidth < 360;
    final bool tablet = screenWidth >= 600;

    final double circleSize = tablet
        ? 66
        : smallPhone
        ? 43
        : 52;

    final double horizontalPadding = clampDouble(screenWidth * 0.035, 10, 28);

    final double topPadding = landscape
        ? 8
        : clampDouble(screenHeight * 0.015, 8, 20);

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: topPadding,
      ),
      child: Row(
        children: [
          SizedBox(
            width: circleSize,
            height: circleSize,
            child: currentQuestionIndex > 0
                ? buildCircleButton(
                    icon: Icons.arrow_back_rounded,
                    color: Colors.blue,
                    size: circleSize,
                    semanticLabel: 'Previous question',
                    onTap: handlePreviousQuestion,
                  )
                : null,
          ),
          Expanded(
            child: Center(
              child: buildQuestionIndicator(screenWidth: screenWidth),
            ),
          ),
          buildCircleButton(
            icon: Icons.home_rounded,
            color: Colors.orange,
            size: circleSize,
            semanticLabel: 'Go back to lesson',
            onTap: goBackToLesson,
          ),
        ],
      ),
    );
  }

  Widget buildAnswerControls({
    required BoxConstraints constraints,
    required bool landscape,
  }) {
    final double availableWidth = constraints.maxWidth;

    final double availableHeight = constraints.maxHeight;

    final bool verySmallPhone = availableWidth < 340;

    final bool smallPhone = availableWidth < 400;

    final bool tablet = availableWidth >= 600;

    final double horizontalPadding = tablet
        ? clampDouble(availableWidth * 0.08, 35, 90)
        : clampDouble(availableWidth * 0.04, 10, 22);

    final double availableContentWidth =
        availableWidth - (horizontalPadding * 2);

    final bool useColumnLayout = verySmallPhone || availableContentWidth < 270;

    final double spacing = tablet
        ? 22
        : smallPhone
        ? 8
        : 14;

    final double choiceWidth = useColumnLayout
        ? clampDouble(availableContentWidth, 230, tablet ? 360 : 320)
        : clampDouble(
            (availableContentWidth - spacing) / 2,
            115,
            tablet ? 250 : 190,
          );

    final double choiceHeight = landscape
        ? clampDouble(availableHeight * 0.18, 62, 90)
        : tablet
        ? clampDouble(availableHeight * 0.12, 90, 120)
        : clampDouble(availableHeight * 0.10, 68, 92);

    final double titleSize = tablet
        ? 27
        : smallPhone
        ? 17
        : 22;

    final double subtitleSize = tablet
        ? 15
        : smallPhone
        ? 10
        : 12;

    final Widget factButton = buildChoiceButton(
      label: 'FACT',
      subLabel: 'Siyentipikong\nPag-aaral',
      color: const Color(0xFF007EE6),
      isSelected: currentAnswer == 'FACT',
      onTap: () => selectAnswer('FACT'),
      width: choiceWidth,
      height: choiceHeight,
      titleSize: titleSize,
      subtitleSize: subtitleSize,
    );

    final Widget storyButton = buildChoiceButton(
      label: 'KUWENTO',
      subLabel: 'Alamat o\nKaalamang Bayan',
      color: const Color(0xFFFFB900),
      isSelected: currentAnswer == 'KUWENTO',
      onTap: () => selectAnswer('KUWENTO'),
      width: choiceWidth,
      height: choiceHeight,
      titleSize: titleSize,
      subtitleSize: subtitleSize,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (useColumnLayout)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                factButton,
                SizedBox(height: spacing),
                storyButton,
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                factButton,
                SizedBox(width: spacing),
                storyButton,
              ],
            ),
          SizedBox(
            height: landscape
                ? 8
                : tablet
                ? 20
                : 12,
          ),
          buildPlainButton(
            context: context,
            label: isLastQuestion ? 'SUBMIT' : 'NEXT',
            enabled: !isSaving,
            onTap: handleNextOrSubmit,
            width: tablet ? 220 : clampDouble(availableWidth * 0.44, 145, 190),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String backgroundImage = backgroundImages[currentQuestionIndex];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final MediaQueryData mediaQuery = MediaQuery.of(context);

          final double screenWidth = constraints.maxWidth;

          final double screenHeight = constraints.maxHeight;

          final bool landscape = screenWidth > screenHeight;

          final double bottomSafeArea = mediaQuery.padding.bottom;

          // Increased bottom padding moves the FACT,
          // KUWENTO, and NEXT/SUBMIT buttons higher.
          final double bottomPadding = landscape
              ? clampDouble(screenHeight * 0.08, 25, 55)
              : screenHeight < 650
              ? clampDouble(screenHeight * 0.08, 45, 70)
              : clampDouble(screenHeight * 0.12, 75, 130);

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                backgroundImage,
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFFFF3D6),
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      'Background image not found:\n'
                      '$backgroundImage',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth < 400 ? 14 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    buildTopControls(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      landscape: landscape,
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: bottomPadding + bottomSafeArea,
                      ),
                      child: buildAnswerControls(
                        constraints: constraints,
                        landscape: landscape,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSaving)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(color: Colors.black.withOpacity(0.08)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
