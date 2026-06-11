import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonThreeGameOne extends StatefulWidget {
  final UserModel user;

  const LessonThreeGameOne({super.key, required this.user});

  @override
  State<LessonThreeGameOne> createState() => _LessonThreeGameOneState();
}

class _LessonThreeGameOneState extends State<LessonThreeGameOne> {
  final String correctWord = "MAYANAPAN";

  final List<String> originalLetters = [
    "M",
    "A",
    "Y",
    "A",
    "N",
    "A",
    "P",
    "A",
    "N",
  ];

  late List<String?> answers;
  late List<String?> availableLetters;

  @override
  void initState() {
    super.initState();
    answers = List.filled(correctWord.length, null);
    availableLetters = List.from(originalLetters);
  }

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void checkAnswer() {
    final userAnswer = answers.map((e) => e ?? "").join();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(userAnswer == correctWord ? "Tama!" : "Subukan muli"),
        content: Text(
          userAnswer == correctWord
              ? "Magaling! Nabuo mo ang salitang MAYANAPAN."
              : "Hindi pa tama ang sagot.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void resetAnswer() {
    setState(() {
      answers = List.filled(correctWord.length, null);
      availableLetters = List.from(originalLetters);
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
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Lesson3Screen(user: widget.user)),
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
      child: tile(letter, tileSize),
    );
  }

  Widget answerBox(int index, double boxWidth, double boxHeight) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        final draggedIndex = details.data;
        final draggedLetter = availableLetters[draggedIndex];

        if (draggedLetter == null) return;

        setState(() {
          if (answers[index] != null) {
            final emptyIndex = availableLetters.indexWhere((e) => e == null);
            if (emptyIndex != -1) {
              availableLetters[emptyIndex] = answers[index];
            }
          }

          answers[index] = draggedLetter;
          availableLetters[draggedIndex] = null;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () {
            if (answers[index] != null) {
              setState(() {
                final emptyIndex = availableLetters.indexWhere(
                  (e) => e == null,
                );
                if (emptyIndex != -1) {
                  availableLetters[emptyIndex] = answers[index];
                }
                answers[index] = null;
              });
            }
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
                width: 2,
              ),
            ),
            child: Text(
              answers[index] ?? "",
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
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;

    final bool smallScreen = size.height < 650 || size.width < 370;

    final double boxWidth = clampDouble(shortestSide * 0.085, 26, 40);
    final double boxHeight = clampDouble(size.height * 0.047, 30, 43);
    final double tileSize = clampDouble(shortestSide * 0.105, 30, 47);
    final double fontSize = clampDouble(shortestSide * 0.038, 11, 16);

    final double bottomPosition = smallScreen
        ? clampDouble(size.height * 0.025, 12, 25)
        : clampDouble(size.height * 0.075, 45, 80);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/lesson-three-game1a.png",
              fit: BoxFit.fill,
            ),
          ),

          homeButton(context, size),

          Positioned(
            left: clampDouble(size.width * 0.035, 10, 18),
            right: clampDouble(size.width * 0.035, 10, 18),
            bottom: bottomPosition,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 2,
                    children: List.generate(
                      correctWord.length,
                      (index) => answerBox(index, boxWidth, boxHeight),
                    ),
                  ),
                  SizedBox(height: clampDouble(size.height * 0.01, 4, 10)),
                  SizedBox(
                    height: tileSize * 2.4,
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        runSpacing: 2,
                        children: List.generate(availableLetters.length, (
                          index,
                        ) {
                          final letter = availableLetters[index];

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
                  ),
                  SizedBox(height: clampDouble(size.height * 0.008, 4, 8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      actionButton(
                        text: "Check",
                        onTap: checkAnswer,
                        color: Colors.green,
                        fontSize: fontSize,
                        horizontalPadding: smallScreen ? 12 : 18,
                        verticalPadding: smallScreen ? 7 : 9,
                      ),
                      const SizedBox(width: 8),
                      actionButton(
                        text: "Reset",
                        onTap: resetAnswer,
                        color: Colors.red,
                        fontSize: fontSize,
                        horizontalPadding: smallScreen ? 12 : 18,
                        verticalPadding: smallScreen ? 7 : 9,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
