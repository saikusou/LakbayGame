import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson3.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonThreeGameOne extends StatefulWidget {
  final UserModel user;

  const LessonThreeGameOne({super.key, required this.user});

  @override
  State<LessonThreeGameOne> createState() => _LessonThreeGameOneState();
}

class _LessonThreeGameOneState extends State<LessonThreeGameOne> {
  final List<GameRound> rounds = const [
    GameRound(
      imagePath: 'assets/lesson-three-game1a.png',
      displayAnswer: 'PAMAYANAN',
      shuffledLetters: ['M', 'A', 'Y', 'A', 'N', 'A', 'P', 'A', 'N'],
    ),
    GameRound(
      imagePath: 'assets/lesson-three-game1b.png',
      displayAnswer: 'SINAUNANG TAO',
      shuffledLetters: [
        'N',
        'A',
        'T',
        'I',
        'O',
        'N',
        'A',
        'S',
        'U',
        'G',
        'A',
        'N',
      ],
    ),
  ];

  int currentRoundIndex = 0;

  late List<String?> answers;
  late List<String?> availableLetters;

  bool isRoundSolved = false;
  bool isSavingScore = false;
  bool isDialogOpen = false;
  bool hasNavigatedBack = false;

  GameRound get currentRound => rounds[currentRoundIndex];

  String get correctWord {
    return currentRound.displayAnswer.replaceAll(' ', '').toUpperCase();
  }

  bool get isLastRound => currentRoundIndex == rounds.length - 1;

  @override
  void initState() {
    super.initState();
    prepareCurrentRound();
  }

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  void prepareCurrentRound() {
    answers = List<String?>.filled(correctWord.length, null);

    availableLetters = List<String?>.from(currentRound.shuffledLetters);

    isRoundSolved = false;
    isDialogOpen = false;
  }

  void resetGame() {
    if (isRoundSolved) return;

    setState(() {
      prepareCurrentRound();
    });
  }

  Future<void> handleSavePoints({required int totalScore}) async {
    try {
      await ApiService.savePoints(
        userId: widget.user.id,
        countedPoints: totalScore,
        lesson: 'Lesson 3',
        day: 'Day 1',
        act: 'Act 1',
      ).timeout(const Duration(seconds: 4));
    } on TimeoutException {
      debugPrint('Saving points timed out. Player can still continue.');
    } catch (error) {
      final String errorMessage = error.toString().toLowerCase();

      final bool isDuplicate =
          errorMessage.contains('already completed') ||
          errorMessage.contains('already exists') ||
          errorMessage.contains('duplicate') ||
          errorMessage.contains('conflict') ||
          errorMessage.contains('409');

      if (isDuplicate) {
        debugPrint('Activity was already recorded. Duplicate ignored.');
        return;
      }

      debugPrint('Failed to save points: $error');
    }
  }

  void autoCheckAnswer() {
    if (isRoundSolved) return;

    final bool hasEmptyAnswer = answers.any((letter) => letter == null);

    if (hasEmptyAnswer) return;

    final String userAnswer = answers.join().toUpperCase();

    if (userAnswer != correctWord) return;

    setState(() {
      isRoundSolved = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted || isDialogOpen) return;

      if (isLastRound) {
        showFinalCongratulationsPopup();
      } else {
        showNextPicturePopup();
      }
    });
  }

  void goToNextRound() {
    if (!mounted) return;

    Navigator.of(context, rootNavigator: true).pop();

    setState(() {
      currentRoundIndex++;
      prepareCurrentRound();
    });
  }

  void closeDialogIfOpen() {
    if (!isDialogOpen || !mounted) return;

    final NavigatorState navigator = Navigator.of(context, rootNavigator: true);

    if (navigator.canPop()) {
      navigator.pop();
    }

    isDialogOpen = false;
  }

  void navigateToLessonScreen() {
    if (!mounted || hasNavigatedBack) return;

    hasNavigatedBack = true;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => Lesson3Screen(user: widget.user)),
    );
  }

  void saveAndReturnToLesson() {
    if (isSavingScore || hasNavigatedBack) return;

    isSavingScore = true;

    /*
     * Close the popup first.
     * Do not wait for the API before navigating.
     */
    closeDialogIfOpen();

    if (!mounted) return;

    navigateToLessonScreen();

    /*
     * Save points without blocking the screen.
     * Duplicate records and timeout errors are ignored.
     */
    unawaited(handleSavePoints(totalScore: 20));
  }

  void showNextPicturePopup() {
    if (!mounted || isDialogOpen) return;

    isDialogOpen = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final Size screenSize = MediaQuery.sizeOf(dialogContext);

        final double popupWidth = clampDouble(
          screenSize.width * 0.85,
          280,
          430,
        );

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: popupWidth,
            padding: EdgeInsets.all(
              clampDouble(screenSize.width * 0.05, 18, 28),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.orange, width: 4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: clampDouble(screenSize.shortestSide * 0.16, 55, 80),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tamang Sagot!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: clampDouble(
                      screenSize.shortestSide * 0.06,
                      21,
                      30,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Mahusay!\nPumunta tayo sa ikalawang larawan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(
                      screenSize.shortestSide * 0.043,
                      15,
                      20,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: clampDouble(screenSize.height * 0.065, 45, 55),
                  child: ElevatedButton.icon(
                    onPressed: goToNextRound,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text(
                      'SUSUNOD',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      if (mounted) {
        isDialogOpen = false;
      }
    });
  }

  void showFinalCongratulationsPopup() {
    if (!mounted || isDialogOpen) return;

    isDialogOpen = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final Size screenSize = MediaQuery.sizeOf(dialogContext);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                width: clampDouble(screenSize.width * 0.85, 280, 430),
                padding: EdgeInsets.all(
                  clampDouble(screenSize.width * 0.05, 18, 28),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.green, width: 4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: clampDouble(screenSize.shortestSide * 0.18, 60, 90),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Congratulations!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: clampDouble(
                          screenSize.shortestSide * 0.06,
                          21,
                          30,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Natapos mo ang dalawang larawan!\n\n'
                      'Nakakuha ka ng 20/20.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: clampDouble(
                          screenSize.shortestSide * 0.043,
                          15,
                          20,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: clampDouble(screenSize.height * 0.065, 45, 55),
                      child: ElevatedButton(
                        onPressed: isSavingScore
                            ? null
                            : () {
                                setDialogState(() {
                                  isSavingScore = true;
                                });

                                /*
                                 * Set it back to false before calling the
                                 * method because saveAndReturnToLesson checks
                                 * the state internally.
                                 */
                                isSavingScore = false;
                                saveAndReturnToLesson();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.green.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isSavingScore
                            ? const SizedBox(
                                width: 23,
                                height: 23,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'OK',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
    ).then((_) {
      if (mounted) {
        isDialogOpen = false;
      }
    });
  }

  void returnLetterToAvailable(int answerIndex) {
    if (isRoundSolved) return;

    if (answerIndex < 0 || answerIndex >= answers.length) {
      return;
    }

    final String? selectedLetter = answers[answerIndex];

    if (selectedLetter == null) return;

    final int emptyIndex = availableLetters.indexWhere(
      (letter) => letter == null,
    );

    if (emptyIndex == -1) return;

    setState(() {
      availableLetters[emptyIndex] = selectedLetter;
      answers[answerIndex] = null;
    });
  }

  Widget homeButton(BuildContext context, BoxConstraints constraints) {
    final double shortestSide = constraints.maxWidth < constraints.maxHeight
        ? constraints.maxWidth
        : constraints.maxHeight;

    final double buttonSize = clampDouble(shortestSide * 0.12, 40, 58);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: clampDouble(constraints.maxWidth * 0.035, 10, 22),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(buttonSize),
          onTap: () {
            if (hasNavigatedBack) return;

            hasNavigatedBack = true;

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => Lesson3Screen(user: widget.user),
              ),
            );
          },
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.home,
              color: Colors.white,
              size: clampDouble(buttonSize * 0.55, 22, 32),
            ),
          ),
        ),
      ),
    );
  }

  Widget roundProgress(BuildContext context, BoxConstraints constraints) {
    final double fontSize = clampDouble(constraints.maxWidth * 0.034, 12, 17);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: clampDouble(constraints.maxWidth * 0.035, 10, 22),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: clampDouble(constraints.maxWidth * 0.03, 10, 16),
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.60),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Larawan ${currentRoundIndex + 1}/${rounds.length}',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget tile(String letter, double tileSize, {bool isDragging = false}) {
    final double size = isDragging ? tileSize + 6 : tileSize;

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(
          clampDouble(tileSize * 0.22, 7, 12),
        ),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: clampDouble(tileSize * 0.50, 14, 24),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget letterTile(int index, String letter, double tileSize) {
    return Draggable<int>(
      data: index,
      maxSimultaneousDrags: isRoundSolved ? 0 : 1,
      feedback: Material(
        color: Colors.transparent,
        child: tile(letter, tileSize, isDragging: true),
      ),
      childWhenDragging: SizedBox(width: tileSize + 6, height: tileSize + 6),
      child: tile(letter, tileSize),
    );
  }

  Widget answerBox(int index, double boxWidth, double boxHeight) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) {
        if (isRoundSolved) return false;

        final int sourceIndex = details.data;

        return sourceIndex >= 0 &&
            sourceIndex < availableLetters.length &&
            availableLetters[sourceIndex] != null;
      },
      onAcceptWithDetails: (details) {
        final int draggedIndex = details.data;

        if (draggedIndex < 0 ||
            draggedIndex >= availableLetters.length ||
            isRoundSolved) {
          return;
        }

        final String? draggedLetter = availableLetters[draggedIndex];

        if (draggedLetter == null) return;

        setState(() {
          if (answers[index] != null) {
            availableLetters[draggedIndex] = answers[index];
          } else {
            availableLetters[draggedIndex] = null;
          }

          answers[index] = draggedLetter;
        });

        autoCheckAnswer();
      },
      builder:
          (
            BuildContext context,
            List<int?> candidateData,
            List<dynamic> rejectedData,
          ) {
            final bool highlighted = candidateData.isNotEmpty;

            return GestureDetector(
              onTap: () {
                returnLetterToAvailable(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: boxWidth,
                height: boxHeight,
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: highlighted ? Colors.orange : Colors.brown,
                    width: highlighted ? 3 : 2,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    answers[index] ?? '',
                    style: TextStyle(
                      fontSize: clampDouble(boxHeight * 0.50, 14, 23),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
    );
  }

  List<Widget> buildAnswerBoxes(double boxWidth, double boxHeight) {
    final List<Widget> widgets = [];

    int answerIndex = 0;

    for (int index = 0; index < currentRound.displayAnswer.length; index++) {
      final String character = currentRound.displayAnswer[index];

      if (character == ' ') {
        widgets.add(SizedBox(width: boxWidth * 0.65, height: boxHeight));
      } else {
        widgets.add(answerBox(answerIndex, boxWidth, boxHeight));

        answerIndex++;
      }
    }

    return widgets;
  }

  Widget responsiveGamePanel(BoxConstraints constraints) {
    final double screenWidth = constraints.maxWidth;
    final double screenHeight = constraints.maxHeight;

    final bool isLandscape = screenWidth > screenHeight;
    final bool isSmallPhone = screenWidth < 370;
    final bool isTablet = screenWidth >= 600;

    final int longestAnswerLength = currentRound.displayAnswer
        .split(' ')
        .map((word) => word.length)
        .reduce((a, b) => a > b ? a : b);

    final double usableAnswerWidth =
        screenWidth *
        (isLandscape
            ? 0.58
            : isTablet
            ? 0.72
            : 0.92);

    final double calculatedBoxWidth =
        (usableAnswerWidth / longestAnswerLength) - 5;

    final double boxWidth = clampDouble(
      calculatedBoxWidth,
      isSmallPhone ? 24 : 27,
      isTablet ? 48 : 39,
    );

    final double boxHeight = clampDouble(
      boxWidth * 1.12,
      30,
      isTablet ? 54 : 45,
    );

    final double availableTileWidth = isLandscape
        ? screenWidth * 0.45
        : screenWidth * 0.90;

    final int tilesPerRow = isLandscape
        ? 6
        : screenWidth < 360
        ? 6
        : 7;

    final double calculatedTileSize = (availableTileWidth / tilesPerRow) - 8;

    final double tileSize = clampDouble(
      calculatedTileSize,
      29,
      isTablet ? 53 : 45,
    );

    final double panelWidth = isLandscape
        ? clampDouble(screenWidth * 0.56, 380, 700)
        : clampDouble(screenWidth * 0.96, 290, 700);

    final double panelPadding = clampDouble(screenWidth * 0.025, 7, 16);

    final double fontSize = clampDouble(screenWidth * 0.035, 12, 17);

    return Align(
      alignment: isLandscape ? Alignment.bottomRight : Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.only(
          left: isLandscape ? 8 : 6,
          right: isLandscape ? 12 : 6,
          bottom: clampDouble(screenHeight * 0.015, 6, 18),
        ),
        child: Container(
          width: panelWidth,
          constraints: BoxConstraints(
            maxHeight: isLandscape ? screenHeight * 0.72 : screenHeight * 0.43,
          ),
          padding: EdgeInsets.all(panelPadding),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.35),
              width: 1.5,
            ),
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 0,
                  runSpacing: 2,
                  children: buildAnswerBoxes(boxWidth, boxHeight),
                ),
                SizedBox(height: clampDouble(screenHeight * 0.012, 5, 12)),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 0,
                  runSpacing: 2,
                  children: List.generate(availableLetters.length, (index) {
                    final String? letter = availableLetters[index];

                    if (letter == null) {
                      return SizedBox(
                        width: tileSize + 6,
                        height: tileSize + 6,
                      );
                    }

                    return letterTile(index, letter, tileSize);
                  }),
                ),
                SizedBox(height: clampDouble(screenHeight * 0.01, 5, 10)),
                SizedBox(
                  height: clampDouble(screenHeight * 0.06, 40, 50),
                  child: ElevatedButton.icon(
                    onPressed: isRoundSolved ? null : resetGame,
                    icon: Icon(
                      Icons.refresh,
                      size: clampDouble(fontSize * 1.4, 18, 24),
                    ),
                    label: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(
                        horizontal: clampDouble(screenWidth * 0.05, 18, 30),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Image.asset(
                  currentRound.imagePath,
                  key: ValueKey(currentRound.imagePath),
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  fit: BoxFit.fill,
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        return Container(
                          color: Colors.blue.shade100,
                          alignment: Alignment.center,
                          child: Text(
                            'Image not found:\n'
                            '${currentRound.imagePath}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                ),
              ),
              roundProgress(context, constraints),
              homeButton(context, constraints),
              responsiveGamePanel(constraints),
            ],
          );
        },
      ),
    );
  }
}

class GameRound {
  final String imagePath;
  final String displayAnswer;
  final List<String> shuffledLetters;

  const GameRound({
    required this.imagePath,
    required this.displayAnswer,
    required this.shuffledLetters,
  });
}
