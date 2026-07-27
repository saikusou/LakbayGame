import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson2.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonTwoDayOneActTwo extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayOneActTwo({super.key, required this.user});

  @override
  State<LessonTwoDayOneActTwo> createState() => _LessonTwoDayOneActTwoState();
}

class _LessonTwoDayOneActTwoState extends State<LessonTwoDayOneActTwo> {
  final List<String> correctWords = [
    'LOKASYON',
    'ARKIPELAGO',
    'LATITUD',
    'LONGHITUD',
  ];

  final List<List<String>> scrambledLetters = [
    ['O', 'L', 'K', 'A', 'Y', 'S', 'N', 'O'],
    ['P', 'A', 'G', 'R', 'I', 'K', 'E', 'L', 'A', 'O'],
    ['T', 'A', 'D', 'L', 'U', 'T', 'I'],
    ['H', 'L', 'D', 'O', 'I', 'U', 'N', 'G', 'T'],
  ];

  final List<String> backgroundImages = [
    'assets/lesson-three-day1-act2t.png',
    'assets/arkipelago.png',
    'assets/latitud.png',
    'assets/longhitud.png',
  ];

  int currentQuestionIndex = 0;

  late List<String?> answers;
  late List<String?> availableLetters;

  bool isSaving = false;
  bool dialogIsOpen = false;

  String get currentCorrectWord {
    return correctWords[currentQuestionIndex];
  }

  String get currentBackgroundImage {
    return backgroundImages[currentQuestionIndex];
  }

  bool get isLastQuestion {
    return currentQuestionIndex == correctWords.length - 1;
  }

  @override
  void initState() {
    super.initState();
    initializeQuestion();
  }

  void initializeQuestion() {
    answers = List<String?>.filled(currentCorrectWord.length, null);

    availableLetters = List<String?>.from(
      scrambledLetters[currentQuestionIndex],
    );
  }

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  Future<void> handleSavePoints({required int totalScore}) async {
    await ApiService.savePoints(
      userId: widget.user.id,
      countedPoints: totalScore,
      lesson: 'Lesson 2',
      day: 'Day 1',
      act: 'Act 2',
    );
  }

  void navigateToLesson2() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Lesson2Screen(user: widget.user)),
      );
    }
  }

  Future<void> saveScoreAndReturn() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      await handleSavePoints(totalScore: 20);

      if (!mounted) return;

      // Navigate immediately after saving
      navigateToLesson2();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
        dialogIsOpen = false;
      });

      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Score not saved', textAlign: TextAlign.center),
            content: Text(
              'Please check your backend or API connection.\n\n$error',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void checkAnswer() {
    if (dialogIsOpen) return;

    final bool hasEmptyBox = answers.any((answer) => answer == null);

    if (hasEmptyBox) {
      showIncompleteAnswerDialog();
      return;
    }

    final String userAnswer = answers.map((letter) => letter ?? '').join();

    if (userAnswer == currentCorrectWord) {
      setState(() {
        dialogIsOpen = true;
      });

      showCorrectAnswerDialog();
    } else {
      showWrongAnswerDialog();
    }
  }

  void showIncompleteAnswerDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Kulang ang sagot', textAlign: TextAlign.center),
          content: const Text(
            'Ilagay muna ang lahat ng letra sa mga kahon.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showWrongAnswerDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.red, width: 3),
          ),
          title: const Icon(Icons.close_rounded, color: Colors.red, size: 55),
          content: const Text(
            'Hindi pa tama ang sagot.\nSubukan mong muli.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showCorrectAnswerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: const BorderSide(color: Colors.orange, width: 4),
              ),
              title: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isLastQuestion ? Icons.emoji_events : Icons.check_rounded,
                      color: Colors.white,
                      size: 55,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    isLastQuestion ? 'Congratulations!' : 'Tamang Sagot!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              content: Text(
                isLastQuestion
                    ? 'Magaling! Nabuo mo ang lahat ng salita.\n\n'
                          'LOKASYON\n'
                          'ARKIPELAGO\n'
                          'LATITUD\n'
                          'LONGHITUD\n\n'
                          '🏆 +20 Points'
                    : 'Magaling! Nabuo mo ang salitang '
                          '$currentCorrectWord.\n\n'
                          '⭐ +5 Points',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (isLastQuestion) {
                            // Close the dialog first
                            Navigator.pop(dialogContext);

                            // Navigate immediately after dialog closes
                            // Use a microtask to ensure dialog is fully dismissed
                            Future.microtask(() {
                              saveScoreAndReturn();
                            });
                          } else {
                            Navigator.pop(dialogContext);
                            goToNextQuestion();
                          }
                        },
                  child: isSaving && isLastQuestion
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isLastQuestion ? 'TAPOS NA' : 'SUSUNOD',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      if (mounted && !isSaving) {
        setState(() {
          dialogIsOpen = false;
        });
      }
    });
  }

  void goToNextQuestion() {
    if (isLastQuestion) return;

    setState(() {
      currentQuestionIndex++;
      dialogIsOpen = false;
      initializeQuestion();
    });
  }

  void resetAnswer() {
    setState(() {
      answers = List<String?>.filled(currentCorrectWord.length, null);

      availableLetters = List<String?>.from(
        scrambledLetters[currentQuestionIndex],
      );
    });
  }

  Widget homeButton(BuildContext context, Size screenSize) {
    final double buttonSize = clampDouble(
      screenSize.shortestSide * 0.11,
      42,
      55,
    );

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      right: clampDouble(screenSize.width * 0.04, 12, 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(buttonSize),
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => Lesson2Screen(user: widget.user)),
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
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.home,
            color: Colors.white,
            size: clampDouble(buttonSize * 0.55, 22, 30),
          ),
        ),
      ),
    );
  }

  Widget numberIndicator(Size screenSize) {
    final double circleSize = clampDouble(
      screenSize.shortestSide * 0.13,
      48,
      62,
    );

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: clampDouble(screenSize.width * 0.04, 12, 20),
      child: Container(
        width: circleSize,
        height: circleSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orange, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Text(
          '${currentQuestionIndex + 1}/${correctWords.length}',
          style: TextStyle(
            color: Colors.brown,
            fontSize: clampDouble(circleSize * 0.29, 14, 18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget tile(String letter, double size, {bool isDragging = false}) {
    return Container(
      width: isDragging ? size + 6 : size,
      height: isDragging ? size + 6 : size,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: clampDouble(size * 0.52, 15, 23),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget letterTile(int index, String letter, double tileSize) {
    return Draggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: tile(letter, tileSize, isDragging: true),
      ),
      childWhenDragging: SizedBox(width: tileSize + 6, height: tileSize + 6),
      child: GestureDetector(
        onTap: () {
          placeLetterInFirstEmptyBox(index);
        },
        child: tile(letter, tileSize),
      ),
    );
  }

  void placeLetterInFirstEmptyBox(int letterIndex) {
    final String? letter = availableLetters[letterIndex];

    if (letter == null) return;

    final int emptyAnswerIndex = answers.indexWhere((answer) => answer == null);

    if (emptyAnswerIndex == -1) return;

    setState(() {
      answers[emptyAnswerIndex] = letter;
      availableLetters[letterIndex] = null;
    });
  }

  Widget answerBox(int index, double boxWidth, double boxHeight) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        final int draggedIndex = details.data;

        final String? draggedLetter = availableLetters[draggedIndex];

        if (draggedLetter == null) return;

        setState(() {
          if (answers[index] != null) {
            final int emptyLetterIndex = availableLetters.indexWhere(
              (letter) => letter == null,
            );

            if (emptyLetterIndex != -1) {
              availableLetters[emptyLetterIndex] = answers[index];
            }
          }

          answers[index] = draggedLetter;
          availableLetters[draggedIndex] = null;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () {
            removeLetterFromAnswer(index);
          },
          child: Container(
            width: boxWidth,
            height: boxHeight,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: candidateData.isNotEmpty ? Colors.orange : Colors.brown,
                width: candidateData.isNotEmpty ? 3 : 2,
              ),
            ),
            child: Text(
              answers[index] ?? '',
              style: TextStyle(
                fontSize: clampDouble(boxHeight * 0.48, 15, 22),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  void removeLetterFromAnswer(int answerIndex) {
    final String? letter = answers[answerIndex];

    if (letter == null) return;

    final int emptyLetterIndex = availableLetters.indexWhere(
      (availableLetter) => availableLetter == null,
    );

    if (emptyLetterIndex == -1) return;

    setState(() {
      availableLetters[emptyLetterIndex] = letter;
      answers[answerIndex] = null;
    });
  }

  Widget actionButton({
    required String text,
    required VoidCallback onTap,
    required Color color,
    required double fontSize,
    required double horizontalPadding,
    required double verticalPadding,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(60, 28),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final double shortestSide = size.shortestSide;

    final bool smallScreen = size.height < 650 || size.width < 370;

    final double calculatedBoxWidth = currentCorrectWord.length >= 10
        ? shortestSide * 0.072
        : shortestSide * 0.085;

    final double boxWidth = clampDouble(calculatedBoxWidth, 24, 40);

    final double boxHeight = clampDouble(size.height * 0.047, 30, 43);

    final double tileSize = clampDouble(shortestSide * 0.10, 29, 45);

    final double buttonFontSize = clampDouble(shortestSide * 0.04, 14, 18);

    final double bottomPosition = smallScreen
        ? clampDouble(size.height * 0.02, 8, 18)
        : clampDouble(size.height * 0.065, 35, 70);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              currentBackgroundImage,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF87CEEB), Color(0xFFFFE0A3)],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    currentCorrectWord,
                    style: const TextStyle(
                      color: Colors.brown,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          numberIndicator(size),
          homeButton(context, size),
          Positioned(
            left: clampDouble(size.width * 0.025, 8, 15),
            right: clampDouble(size.width * 0.025, 8, 15),
            bottom: bottomPosition,
            child: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: smallScreen ? 8 : 12,
                  vertical: smallScreen ? 8 : 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      spacing: 1,
                      runSpacing: 2,
                      children: List.generate(currentCorrectWord.length, (
                        index,
                      ) {
                        return answerBox(index, boxWidth, boxHeight);
                      }),
                    ),
                    SizedBox(height: clampDouble(size.height * 0.012, 5, 10)),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: tileSize + 8,
                        maxHeight: tileSize * 2.5,
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        spacing: 1,
                        runSpacing: 2,
                        children: List.generate(availableLetters.length, (
                          index,
                        ) {
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
                    ),
                    SizedBox(height: clampDouble(size.height * 0.008, 4, 8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        actionButton(
                          text: 'CHECK',
                          onTap: checkAnswer,
                          color: Colors.green,
                          fontSize: buttonFontSize,
                          horizontalPadding: smallScreen ? 18 : 26,
                          verticalPadding: smallScreen ? 10 : 14,
                        ),
                        const SizedBox(width: 12),
                        actionButton(
                          text: 'RESET',
                          onTap: resetAnswer,
                          color: Colors.red,
                          fontSize: buttonFontSize,
                          horizontalPadding: smallScreen ? 18 : 26,
                          verticalPadding: smallScreen ? 10 : 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
