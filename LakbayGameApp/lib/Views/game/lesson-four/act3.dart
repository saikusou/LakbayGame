import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/game/lesson-four/act3a.dart';
import 'package:lakbay_game/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonFourDayOneActThree extends StatefulWidget {
  final UserModel user;

  const LessonFourDayOneActThree({super.key, required this.user});

  @override
  State<LessonFourDayOneActThree> createState() =>
      _LessonFourDayOneActThreeState();
}

class _LessonFourDayOneActThreeState extends State<LessonFourDayOneActThree> {
  final List<String> pieces = [
    'assets/l3-d1-1.png',
    'assets/l3-d1-2.png',
    'assets/l3-d1-3.png',
    'assets/l3-d1-4.png',
  ];

  final List<int?> placed = List.filled(4, null);

  static const int totalPoints = 20;

  Timer? _timer;
  int elapsedSeconds = 0;
  bool timerStopped = false;
  bool popupShown = false;
  bool alreadySaved = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  Future<void> handleSavePoints({required int totalScore}) async {
    if (alreadySaved) return;

    alreadySaved = true;

    try {
      await ApiService.savePoints(
        userId: widget.user.id,
        countedPoints: totalScore,
        lesson: 'Lesson 4',
        day: 'Day 1',
        act: 'Act 3',
      );
    } catch (e) {
      alreadySaved = false;
      debugPrint('Save points error: $e');
    }
  }

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || timerStopped) return;

      setState(() {
        elapsedSeconds++;
      });
    });
  }

  void resetPuzzle() {
    setState(() {
      for (int i = 0; i < placed.length; i++) {
        placed[i] = null;
      }

      elapsedSeconds = 0;
      timerStopped = false;
      popupShown = false;
      alreadySaved = false;
    });

    startTimer();
  }

  bool get isCompleted {
    for (int i = 0; i < placed.length; i++) {
      if (placed[i] != i) return false;
    }
    return true;
  }

  String get formattedTime {
    final minutes = elapsedSeconds ~/ 60;
    final seconds = elapsedSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> completePuzzle() async {
    if (popupShown) return;

    setState(() {
      timerStopped = true;
      popupShown = true;
    });

    await handleSavePoints(totalScore: totalPoints);

    if (!mounted) return;

    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        showCongratulationsPopup();
      }
    });
  }

  void playAgain() {
    Navigator.pop(context);
    resetPuzzle();
  }

  void goToAnswerPage() {
    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LessonFourDayOneActThreeA(user: widget.user),
      ),
    );
  }

  void showCongratulationsPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final width = size.width;

        final popupWidth = clampDouble(width * 0.88, 285, 420);
        final iconSize = clampDouble(width * 0.16, 50, 70);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: popupWidth,
            padding: EdgeInsets.all(clampDouble(width * 0.045, 14, 22)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF3),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFF126FC0), width: 5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: iconSize,
                    color: const Color(0xFFFFC928),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Congratulations!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: clampDouble(width * 0.07, 22, 28),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF126FC0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nabuo mo ang puzzle!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: clampDouble(width * 0.043, 14, 18),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF123B63),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: resultBox(
                          title: 'TIME',
                          value: formattedTime,
                          color: Colors.red,
                          width: width,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: resultBox(
                          title: 'POINTS',
                          value: '$totalPoints',
                          color: Colors.green,
                          width: width,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  popupButton(
                    label: 'ANSWER',
                    icon: Icons.arrow_forward,
                    color: const Color(0xFF0D63B7),
                    width: width,
                    onTap: goToAnswerPage,
                  ),
                  const SizedBox(height: 10),
                  popupButton(
                    label: 'PLAY AGAIN',
                    icon: Icons.refresh,
                    color: Colors.red,
                    width: width,
                    onTap: playAgain,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget resultBox({
    required String title,
    required String value,
    required Color color,
    required double width,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: clampDouble(width * 0.02, 8, 16),
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color, width: 3),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xFF126FC0),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: clampDouble(width * 0.065, 22, 30),
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget popupButton({
    required String label,
    required IconData icon,
    required Color color,
    required double width,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: clampDouble(width * 0.58, 210, 270),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFFFD84A), width: 4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: clampDouble(width * 0.043, 15, 18),
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget buildPuzzleBoard({
    required double boardWidth,
    required double boardHeight,
  }) {
    return Container(
      width: boardWidth,
      height: boardHeight,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1781D3), width: 3),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.75,
        ),
        itemBuilder: (context, index) {
          return DragTarget<int>(
            onAcceptWithDetails: (details) {
              if (timerStopped) return;

              setState(() {
                placed[index] = details.data;
              });

              if (isCompleted) {
                completePuzzle();
              }
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: placed[index] == index
                        ? Colors.green
                        : const Color(0xFF0B65AE),
                    width: 3,
                  ),
                ),
                child: placed[index] == null
                    ? const Center(
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      )
                    : Image.asset(pieces[placed[index]!], fit: BoxFit.fill),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildPieces({
    required double pieceWidth,
    required double pieceHeight,
    required bool isSmall,
  }) {
    return Wrap(
      spacing: isSmall ? 7 : 12,
      runSpacing: isSmall ? 7 : 12,
      alignment: WrapAlignment.center,
      children: List.generate(4, (index) {
        final alreadyPlaced = placed.contains(index);

        if (alreadyPlaced) {
          return SizedBox(width: pieceWidth, height: pieceHeight);
        }

        return Draggable<int>(
          data: index,
          maxSimultaneousDrags: timerStopped ? 0 : 1,
          feedback: Material(
            color: Colors.transparent,
            child: Image.asset(
              pieces[index],
              width: pieceWidth * 1.12,
              height: pieceHeight * 1.12,
              fit: BoxFit.fill,
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.25,
            child: Image.asset(
              pieces[index],
              width: pieceWidth,
              height: pieceHeight,
              fit: BoxFit.fill,
            ),
          ),
          child: Image.asset(
            pieces[index],
            width: pieceWidth,
            height: pieceHeight,
            fit: BoxFit.fill,
          ),
        );
      }),
    );
  }

  Widget buildBottomControls({required double width, required bool isNarrow}) {
    final timerWidth = clampDouble(width * 0.28, 86, 115);
    final timerHeight = clampDouble(width * 0.15, 50, 66);

    if (isNarrow) {
      return Column(
        children: [
          buildTimerBox(timerWidth, timerHeight, width),
          const SizedBox(height: 10),
          buildResetButton(width),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimerBox(timerWidth, timerHeight, width),
        const SizedBox(width: 18),
        buildResetButton(width),
      ],
    );
  }

  Widget buildTimerBox(double timerWidth, double timerHeight, double width) {
    return Container(
      width: timerWidth,
      height: timerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF126FC0), width: 4),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: clampDouble(width * 0.048, 16, 22),
                fontWeight: FontWeight.w900,
                color: Colors.red,
              ),
            ),
            const Text(
              'ORAS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Color(0xFF126FC0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResetButton(double width) {
    return GestureDetector(
      onTap: timerStopped ? null : resetPuzzle,
      child: Container(
        height: clampDouble(width * 0.13, 46, 56),
        padding: EdgeInsets.symmetric(
          horizontal: clampDouble(width * 0.055, 16, 24),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0D63B7),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFFFD84A), width: 5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'RESET',
              style: TextStyle(
                fontSize: clampDouble(width * 0.045, 16, 21),
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.refresh,
              color: Colors.white,
              size: clampDouble(width * 0.055, 21, 27),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            final isNarrow = width < 370;
            final isSmallHeight = height < 720;
            final isVerySmallHeight = height < 650;

            final horizontalPadding = clampDouble(width * 0.035, 10, 18);

            final boardWidth = clampDouble(width * 0.92, 285, 470);
            final boardHeight = clampDouble(
              boardWidth * 0.62,
              170,
              isVerySmallHeight ? 220 : 285,
            );

            final pieceWidth = clampDouble(
              width * 0.215,
              58,
              isSmallHeight ? 82 : 105,
            );

            final pieceHeight = pieceWidth * 0.72;

            final titleFont = clampDouble(width * 0.062, 20, 30);
            final instructionFont = clampDouble(width * 0.037, 12, 17);

            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFBDEEFF),
                    Color(0xFFFFFFFF),
                    Color(0xFFC9F6B8),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: height),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      isVerySmallHeight ? 6 : 10,
                      horizontalPadding,
                      18,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: isVerySmallHeight ? 5 : 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF126FC0),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 34,
                                  minHeight: 34,
                                ),
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 27,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'I-konek Mo Ako!',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: titleFont,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFFFFD84A),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 34),
                            ],
                          ),
                        ),
                        SizedBox(height: isVerySmallHeight ? 7 : 11),
                        Container(
                          width: boardWidth,
                          padding: EdgeInsets.all(isVerySmallHeight ? 8 : 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFCF3),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF1781D3),
                              width: 3,
                            ),
                          ),
                          child: Text(
                            'Ayusin ang apat na bahagi upang mabuo ang larawan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: instructionFont,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF123B63),
                            ),
                          ),
                        ),
                        SizedBox(height: isVerySmallHeight ? 7 : 11),
                        buildPuzzleBoard(
                          boardWidth: boardWidth,
                          boardHeight: boardHeight,
                        ),
                        SizedBox(height: isVerySmallHeight ? 8 : 13),
                        buildPieces(
                          pieceWidth: pieceWidth,
                          pieceHeight: pieceHeight,
                          isSmall: isSmallHeight,
                        ),
                        SizedBox(height: isVerySmallHeight ? 10 : 16),
                        buildBottomControls(width: width, isNarrow: isNarrow),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
