import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-one/act3b.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson1.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonOneDayOneActThreeA extends StatefulWidget {
  final UserModel user;

  const LessonOneDayOneActThreeA({super.key, required this.user});

  @override
  State<LessonOneDayOneActThreeA> createState() =>
      _LessonOneDayOneActThreeAState();
}

class _LessonOneDayOneActThreeAState extends State<LessonOneDayOneActThreeA> {
  static const String correctAnswer = 'AUSTRONESYANO';
  static const int activityScore = 150;

  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;

  final List<String> alphabet = List<String>.generate(
    26,
    (int index) => String.fromCharCode(65 + index),
  );

  int selectedBoxIndex = 0;

  bool answerChecked = false;
  bool answerIsCorrect = false;
  bool dialogIsShowing = false;
  bool isSavingPoints = false;

  @override
  void initState() {
    super.initState();

    controllers = List<TextEditingController>.generate(
      correctAnswer.length,
      (_) => TextEditingController(),
    );

    focusNodes = List<FocusNode>.generate(
      correctAnswer.length,
      (_) => FocusNode(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && focusNodes.isNotEmpty) {
        focusNodes.first.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (final TextEditingController controller in controllers) {
      controller.dispose();
    }

    for (final FocusNode focusNode in focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  double responsiveValue({
    required double screenWidth,
    required double small,
    required double medium,
    required double large,
  }) {
    if (screenWidth < 360) {
      return small;
    }

    if (screenWidth < 600) {
      return medium;
    }

    return large;
  }

  String getTypedAnswer() {
    return controllers
        .map(
          (TextEditingController controller) =>
              controller.text.trim().toUpperCase(),
        )
        .join();
  }

  bool hasEmptyAnswerBox() {
    return controllers.any(
      (TextEditingController controller) => controller.text.trim().isEmpty,
    );
  }

  void selectAnswerBox(int index) {
    if (index < 0 || index >= controllers.length) {
      return;
    }

    setState(() {
      selectedBoxIndex = index;
      answerChecked = false;
      answerIsCorrect = false;
    });

    focusNodes[index].requestFocus();
  }

  void decoderLetterClicked(String letter) {
    if (selectedBoxIndex < 0 || selectedBoxIndex >= controllers.length) {
      return;
    }

    final int currentIndex = selectedBoxIndex;

    controllers[currentIndex]
      ..text = letter
      ..selection = const TextSelection.collapsed(offset: 1);

    HapticFeedback.selectionClick();

    setState(() {
      answerChecked = false;
      answerIsCorrect = false;

      if (currentIndex < controllers.length - 1) {
        selectedBoxIndex = currentIndex + 1;
      }
    });

    if (currentIndex < controllers.length - 1) {
      focusNodes[selectedBoxIndex].requestFocus();
    } else {
      focusNodes[currentIndex].unfocus();
    }
  }

  void handleTypedLetter(int index, String value) {
    if (index < 0 || index >= controllers.length) {
      return;
    }

    final String cleanedValue = value
        .replaceAll(RegExp(r'[^a-zA-Z]'), '')
        .toUpperCase();

    if (cleanedValue.isEmpty) {
      controllers[index].clear();

      setState(() {
        answerChecked = false;
        answerIsCorrect = false;
        selectedBoxIndex = index > 0 ? index - 1 : 0;
      });

      focusNodes[selectedBoxIndex].requestFocus();
      return;
    }

    final String letter = cleanedValue.substring(0, 1);

    controllers[index]
      ..text = letter
      ..selection = const TextSelection.collapsed(offset: 1);

    setState(() {
      answerChecked = false;
      answerIsCorrect = false;

      if (index < controllers.length - 1) {
        selectedBoxIndex = index + 1;
      } else {
        selectedBoxIndex = index;
      }
    });

    if (index < controllers.length - 1) {
      focusNodes[selectedBoxIndex].requestFocus();
    } else {
      focusNodes[index].unfocus();
    }
  }

  void retryAnswer() {
    HapticFeedback.lightImpact();

    for (final TextEditingController controller in controllers) {
      controller.clear();
    }

    FocusScope.of(context).unfocus();

    setState(() {
      selectedBoxIndex = 0;
      answerChecked = false;
      answerIsCorrect = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && focusNodes.isNotEmpty) {
        focusNodes.first.requestFocus();
      }
    });
  }

  void showMessage({required String message, required Color backgroundColor}) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  Future<bool> handleSavePoints({required int totalScore}) async {
    if (isSavingPoints) {
      return false;
    }

    setState(() {
      isSavingPoints = true;
    });

    try {
      await ApiService.savePoints(
        userId: widget.user.id,
        countedPoints: totalScore,
        lesson: 'Lesson 1',
        day: 'Day 1',
        act: 'Act 3A',
      );

      return true;
    } catch (error) {
      if (!mounted) {
        return false;
      }

      final String errorMessage = error.toString().toLowerCase();

      // The backend may return Conflict when the activity
      // has already been completed.
      if (errorMessage.contains('already completed') ||
          errorMessage.contains('conflict') ||
          errorMessage.contains('409')) {
        return true;
      }

      showMessage(
        message: 'Hindi na-save ang puntos. Pakisubukan muli.',
        backgroundColor: Colors.red,
      );

      return false;
    } finally {
      if (mounted) {
        setState(() {
          isSavingPoints = false;
        });
      }
    }
  }

  void goToNextPage() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
      (Route<dynamic> route) => false,
    );
  }

  String getUserAnswer() {
    return controllers
        .map(
          (TextEditingController controller) =>
              controller.text.trim().toUpperCase(),
        )
        .join();
  }

  void checkAnswer() {
    FocusScope.of(context).unfocus();

    if (hasEmptyAnswerBox()) {
      setState(() {
        answerChecked = true;
        answerIsCorrect = false;
      });

      showMessage(
        message: 'Kumpletuhin muna ang lahat ng kahon.',
        backgroundColor: Colors.orange,
      );

      return;
    }

    final bool isCorrect = getUserAnswer() == correctAnswer;

    setState(() {
      answerChecked = true;
      answerIsCorrect = isCorrect;
    });

    if (!isCorrect) {
      HapticFeedback.mediumImpact();

      showMessage(
        message: 'Mali ang sagot. Subukan ulit.',
        backgroundColor: Colors.red,
      );

      return;
    }

    HapticFeedback.heavyImpact();
    showCorrectAnswerDialog();
  }

  Future<void> showCorrectAnswerDialog() async {
    if (!mounted || dialogIsShowing) {
      return;
    }

    dialogIsShowing = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            final MediaQueryData mediaQuery = MediaQuery.of(dialogContext);

            final Size screenSize = mediaQuery.size;
            final double screenWidth = screenSize.width;
            final double screenHeight = screenSize.height;

            final bool isSmallPhone = screenWidth < 390;
            final bool isLandscape =
                mediaQuery.orientation == Orientation.landscape;

            final double maximumDialogHeight =
                screenHeight * (isLandscape ? 0.94 : 0.88);

            Future<void> finishActivity() async {
              if (isSavingPoints) {
                return;
              }

              setDialogState(() {});

              final bool saved = await handleSavePoints(
                totalScore: activityScore,
              );

              if (!dialogContext.mounted) {
                return;
              }

              setDialogState(() {});

              if (!saved) {
                return;
              }

              Navigator.of(dialogContext).pop();

              if (mounted) {
                goToNextPage();
              }
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(
                horizontal: isSmallPhone ? 10 : 22,
                vertical: isLandscape ? 8 : 18,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 600,
                  maxHeight: maximumDialogHeight,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isSmallPhone ? 10 : 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.green, width: 4),
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
                      Flexible(
                        child: Stack(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: isLandscape
                                    ? screenHeight * 0.42
                                    : screenHeight * 0.35,
                                maxHeight: isLandscape
                                    ? screenHeight * 0.68
                                    : screenHeight * 0.64,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'assets/lesson-one-day1-act32.png',
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (
                                          BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace,
                                        ) {
                                          return Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(
                                              isSmallPhone ? 18 : 28,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF7FFF7),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.green,
                                                  size: isSmallPhone ? 65 : 85,
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  'TAMANG SAGOT!',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: isSmallPhone
                                                        ? 22
                                                        : 28,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  correctAnswer,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: isSmallPhone
                                                        ? 18
                                                        : 23,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  '+$activityScore points',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: isSmallPhone
                                                        ? 16
                                                        : 20,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: isSavingPoints
                                      ? null
                                      : () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    width: isSmallPhone ? 36 : 44,
                                    height: isSmallPhone ? 36 : 44,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: isSmallPhone ? 22 : 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isSmallPhone ? 10 : 14),
                      SafeArea(
                        top: false,
                        child: SizedBox(
                          width: isSmallPhone ? double.infinity : 220,
                          height: isSmallPhone ? 46 : 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LessonOneDayOneActThreeB(
                                    user: widget.user,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: isSmallPhone ? 22 : 26,
                            ),
                            label: Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallPhone ? 16 : 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 5,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
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
      },
    );

    if (mounted) {
      dialogIsShowing = false;
    }
  }

  Color getAnswerBorderColor(int index) {
    if (!answerChecked) {
      return selectedBoxIndex == index ? Colors.orange : Colors.black87;
    }

    if (answerIsCorrect) {
      return Colors.green;
    }

    final String typedLetter = controllers[index].text.trim().toUpperCase();

    if (typedLetter.isEmpty) {
      return Colors.red;
    }

    return typedLetter == correctAnswer[index] ? Colors.green : Colors.red;
  }

  Color getAnswerBoxColor(int index) {
    if (!answerChecked) {
      return Colors.white;
    }

    if (answerIsCorrect) {
      return const Color(0xFFE5F8E7);
    }

    final String typedLetter = controllers[index].text.trim().toUpperCase();

    return typedLetter == correctAnswer[index]
        ? const Color(0xFFE5F8E7)
        : const Color(0xFFFFE8E8);
  }

  Widget buildSingleAnswerBox({required int index, required double boxSize}) {
    final bool isSelected = selectedBoxIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: boxSize,
      height: boxSize + 8,
      decoration: BoxDecoration(
        color: getAnswerBoxColor(index),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getAnswerBorderColor(index),
          width: isSelected ? 2.8 : 1.8,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.text,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
          LengthLimitingTextInputFormatter(1),
        ],
        onTap: () {
          selectAnswerBox(index);
        },
        onChanged: (String value) {
          handleTypedLetter(index, value);
        },
        style: TextStyle(
          fontSize: boxSize * 0.50,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }

  Widget buildAnswerBoxes(double availableWidth) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double spacing = responsiveValue(
          screenWidth: availableWidth,
          small: 2,
          medium: 4,
          large: 6,
        );

        final double desiredBoxSize = responsiveValue(
          screenWidth: availableWidth,
          small: 28,
          medium: 34,
          large: 40,
        );

        final double usableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : availableWidth;

        final double totalSpacing = spacing * (controllers.length - 1);

        final double calculatedBoxSize =
            (usableWidth - totalSpacing) / controllers.length;

        final double boxSize = calculatedBoxSize
            .clamp(22.0, desiredBoxSize)
            .toDouble();

        final double completeRowWidth =
            (boxSize * controllers.length) + totalSpacing;

        return SizedBox(
          width: double.infinity,
          height: boxSize + 14,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: usableWidth),
              child: Center(
                child: SizedBox(
                  width: completeRowWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(controllers.length, (
                      int index,
                    ) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == controllers.length - 1 ? 0 : spacing,
                        ),
                        child: buildSingleAnswerBox(
                          index: index,
                          boxSize: boxSize,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildHeader(double screenWidth) {
    final double titleFontSize = responsiveValue(
      screenWidth: screenWidth,
      small: 17,
      medium: 21,
      large: 25,
    );

    final double homeButtonSize = responsiveValue(
      screenWidth: screenWidth,
      small: 44,
      medium: 52,
      large: 62,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(
            left: screenWidth < 390 ? 8 : 45,
            right: homeButtonSize + 10,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth < 390 ? 10 : 18,
            vertical: screenWidth < 390 ? 11 : 14,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D5C94), Color(0xFF063B68)],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF62A7D4), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'CRACK THE CODE #2',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 3,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => Lesson1Screen(user: widget.user),
                ),
              );
            },
            child: Container(
              width: homeButtonSize,
              height: homeButtonSize,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 7,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: homeButtonSize * 0.55,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWoodenTitle({
    required String title,
    required double screenWidth,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth < 390 ? 24 : 32,
        vertical: screenWidth < 390 ? 7 : 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF784015),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF321500), width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 3, offset: Offset(0, 3)),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: responsiveValue(
            screenWidth: screenWidth,
            small: 18,
            medium: 21,
            large: 24,
          ),
          fontWeight: FontWeight.w900,
          shadows: const [
            Shadow(color: Colors.black, blurRadius: 2, offset: Offset(1, 1)),
          ],
        ),
      ),
    );
  }

  Widget buildPurpleBanner(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: screenWidth < 390 ? 8 : 11,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4E176B), Color(0xFF7A2691), Color(0xFF4E176B)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2F0B3D), width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 3)),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'I-DECODE ANG SALITA!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: responsiveValue(
              screenWidth: screenWidth,
              small: 17,
              medium: 20,
              large: 23,
            ),
            fontWeight: FontWeight.w900,
            shadows: const [
              Shadow(color: Colors.black, blurRadius: 2, offset: Offset(1, 1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLockRow(double screenWidth) {
    final double lockSize = responsiveValue(
      screenWidth: screenWidth,
      small: 22,
      medium: 27,
      large: 32,
    );

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: screenWidth < 390 ? 6 : 12,
      runSpacing: 5,
      children: List<Widget>.generate(
        10,
        (_) => Icon(
          Icons.lock_rounded,
          color: const Color(0xFFF5A800),
          size: lockSize,
          shadows: const [
            Shadow(color: Colors.black54, blurRadius: 2, offset: Offset(1, 2)),
          ],
        ),
      ),
    );
  }

  Widget buildDecoderTable(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth < 390 ? 6 : 10),
      decoration: BoxDecoration(
        color: const Color(0xFF075285),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFF083757), width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'DECODER TABLE (GABAY)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: responsiveValue(
                  screenWidth: screenWidth,
                  small: 16,
                  medium: 19,
                  large: 22,
                ),
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          buildDecoderRow(
            letters: alphabet.sublist(0, 10),
            startNumber: 1,
            screenWidth: screenWidth,
          ),
          buildDecoderRow(
            letters: alphabet.sublist(10, 20),
            startNumber: 11,
            screenWidth: screenWidth,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.60,
              child: buildDecoderRow(
                letters: alphabet.sublist(20, 26),
                startNumber: 21,
                screenWidth: screenWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDecoderRow({
    required List<String> letters,
    required int startNumber,
    required double screenWidth,
  }) {
    final double letterHeight = responsiveValue(
      screenWidth: screenWidth,
      small: 31,
      medium: 36,
      large: 42,
    );

    final double numberHeight = responsiveValue(
      screenWidth: screenWidth,
      small: 31,
      medium: 37,
      large: 42,
    );

    return Row(
      children: List<Widget>.generate(letters.length, (int index) {
        final String letter = letters[index];
        final int number = startNumber + index;

        return Expanded(
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    decoderLetterClicked(letter);
                  },
                  splashColor: Colors.orange.withOpacity(0.5),
                  highlightColor: Colors.orange.withOpacity(0.25),
                  child: Container(
                    height: letterHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54, width: 0.7),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        letter,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsiveValue(
                            screenWidth: screenWidth,
                            small: 13,
                            medium: 16,
                            large: 19,
                          ),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: numberHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF064572),
                  border: Border.all(color: Colors.white54, width: 0.7),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsiveValue(
                        screenWidth: screenWidth,
                        small: 11,
                        medium: 14,
                        large: 16,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
            ],
          ),
        );
      }),
    );
  }

  Widget actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required double screenWidth,
  }) {
    final double buttonHeight = responsiveValue(
      screenWidth: screenWidth,
      small: 46,
      medium: 52,
      large: 58,
    );

    final double fontSize = responsiveValue(
      screenWidth: screenWidth,
      small: 13,
      medium: 16,
      large: 18,
    );

    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: fontSize + 7),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 5,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
            side: const BorderSide(color: Colors.white, width: 3),
          ),
        ),
      ),
    );
  }

  Widget buildButtons(double screenWidth) {
    return Row(
      children: [
        Expanded(
          child: actionButton(
            label: 'Retry',
            icon: Icons.refresh_rounded,
            color: const Color(0xFFFF3F3A),
            onPressed: retryAnswer,
            screenWidth: screenWidth,
          ),
        ),
        SizedBox(width: screenWidth < 390 ? 10 : 16),
        Expanded(
          child: actionButton(
            label: 'Check',
            icon: Icons.check_rounded,
            color: Colors.green,
            onPressed: checkAnswer,
            screenWidth: screenWidth,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color(0xFFD3A55E),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE7C884), Color(0xFFD7A85C), Color(0xFFC48A3F)],
            ),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double outerPadding = constraints.maxWidth < 390 ? 8 : 16;

              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  outerPadding,
                  12,
                  outerPadding,
                  mediaQuery.viewInsets.bottom + 25,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: LayoutBuilder(
                      builder:
                          (
                            BuildContext context,
                            BoxConstraints contentConstraints,
                          ) {
                            final double contentWidth =
                                contentConstraints.maxWidth;

                            final double sectionSpacing = isLandscape ? 12 : 20;

                            return Column(
                              children: [
                                buildHeader(contentWidth),
                                SizedBox(height: sectionSpacing),
                                buildWoodenTitle(
                                  title: 'TANONG',
                                  screenWidth: contentWidth,
                                ),
                                SizedBox(height: isLandscape ? 10 : 14),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: contentWidth < 390 ? 10 : 35,
                                  ),
                                  child: Text(
                                    '“'
                                    'ang ating mga ninuno ay kabilang '
                                    'sa malaking pangkat ng mga tao '
                                    'na dumating galing sa ibang bansa, '
                                    'tumawid ng dagat, at kumalat sa '
                                    'Timog-Silangang Asya.”',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF24170C),
                                      fontSize: responsiveValue(
                                        screenWidth: contentWidth,
                                        small: 16,
                                        medium: 19,
                                        large: 22,
                                      ),
                                      height: 1.28,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                SizedBox(height: sectionSpacing),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: contentWidth < 390 ? 10 : 28,
                                  ),
                                  child: buildPurpleBanner(contentWidth),
                                ),
                                SizedBox(height: isLandscape ? 10 : 15),
                                buildLockRow(contentWidth),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '1-21-19-20-18-15-14-5-19-25-1-14-15',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF2A2018),
                                        fontSize: responsiveValue(
                                          screenWidth: contentWidth,
                                          small: 14,
                                          medium: 18,
                                          large: 21,
                                        ),
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: isLandscape ? 12 : 18),

                                // All answer boxes are kept in one row.
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: contentWidth < 390 ? 0 : 12,
                                  ),
                                  child: buildAnswerBoxes(contentWidth),
                                ),

                                SizedBox(height: isLandscape ? 14 : 22),
                                buildDecoderTable(contentWidth),
                                SizedBox(height: isLandscape ? 14 : 20),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: contentWidth < 390 ? 10 : 55,
                                  ),
                                  child: buildButtons(contentWidth),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
