import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/game/lesson-four/act3a.dart';
import 'package:lakbay_game/models/user_model.dart';
import 'package:lakbay_game/Views/lesson4.dart'; // change if your page name/path is different

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

  Timer? _timer;
  int elapsedSeconds = 0;
  bool timerStopped = false;
  bool popupShown = false;

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

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!timerStopped && mounted) {
        setState(() {
          elapsedSeconds++;
        });
      }
    });
  }

  void resetPuzzle() {
    setState(() {
      for (int i = 0; i < placed.length; i++) {
        placed[i] = null;
      }

      if (timerStopped) {
        elapsedSeconds = 0;
      }

      timerStopped = false;
      popupShown = false;
    });
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

  void completePuzzle() {
    if (popupShown) return;

    setState(() {
      timerStopped = true;
      popupShown = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) showCongratulationsPopup();
    });
  }

  void playAgain() {
    Navigator.pop(context);

    setState(() {
      for (int i = 0; i < placed.length; i++) {
        placed[i] = null;
      }

      elapsedSeconds = 0;
      timerStopped = false;
      popupShown = false;
    });
  }

  void goToAnswerPage() {
    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LessonFourDayOneActThreeA(user: widget.user),
      ),
    );
  }

  void showCongratulationsPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final popupWidth = clampDouble(size.width * 0.85, 285, 420);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 18),
          child: Container(
            width: popupWidth,
            padding: EdgeInsets.all(clampDouble(size.width * 0.05, 16, 22)),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: clampDouble(size.width * 0.16, 55, 70),
                  color: const Color(0xFFFFC928),
                ),
                const SizedBox(height: 8),
                Text(
                  'Congratulations!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.07, 23, 28),
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF126FC0),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nabuo mo ang puzzle!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.045, 15, 18),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF123B63),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.red, width: 3),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'TIME RECORD',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF126FC0),
                        ),
                      ),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: clampDouble(size.width * 0.085, 26, 32),
                          fontWeight: FontWeight.w900,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: goToAnswerPage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D63B7),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFFFFD84A),
                        width: 4,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ANSWER',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: playAgain,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFFFFD84A),
                        width: 4,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'PLAY AGAIN',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.refresh, color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPuzzleBoard({
    required double boardWidth,
    required double boardHeight,
  }) {
    return Container(
      width: boardWidth,
      height: boardHeight,
      padding: const EdgeInsets.all(8),
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
                            fontSize: 32,
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
      spacing: isSmall ? 8 : 12,
      runSpacing: isSmall ? 8 : 12,
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
              width: pieceWidth * 1.18,
              height: pieceHeight * 1.18,
              fit: BoxFit.fill,
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
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
    final timerWidth = clampDouble(width * 0.27, 82, 105);
    final timerHeight = clampDouble(width * 0.16, 54, 68);

    return isNarrow
        ? Column(
            children: [
              buildTimerBox(timerWidth, timerHeight, width),
              const SizedBox(height: 12),
              buildResetButton(width),
            ],
          )
        : Row(
            children: [
              buildTimerBox(timerWidth, timerHeight, width),
              const Spacer(),
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
                fontSize: clampDouble(width * 0.05, 17, 22),
                fontWeight: FontWeight.w900,
                color: Colors.red,
              ),
            ),
            const Text(
              'ORAS',
              style: TextStyle(
                fontSize: 11,
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
      onTap: resetPuzzle,
      child: Container(
        height: clampDouble(width * 0.14, 48, 58),
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
                fontSize: clampDouble(width * 0.048, 17, 22),
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.refresh,
              color: Colors.white,
              size: clampDouble(width * 0.06, 22, 28),
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

            final isSmallHeight = height < 720;
            final isVerySmallHeight = height < 640;
            final isNarrow = width < 360;

            final horizontalPadding = clampDouble(width * 0.035, 10, 16);

            final boardWidth = clampDouble(width * 0.90, 285, 460);
            final boardHeight = clampDouble(
              boardWidth * 0.63,
              178,
              isSmallHeight ? 245 : 290,
            );

            final pieceWidth = clampDouble(
              width * 0.205,
              58,
              isSmallHeight ? 82 : 105,
            );
            final pieceHeight = pieceWidth * 0.72;

            final titleFont = clampDouble(width * 0.065, 21, 30);
            final instructionFont = clampDouble(width * 0.037, 12.5, 17);

            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
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
                  ),
                ),
                SingleChildScrollView(
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
                                    size: 28,
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
              ],
            );
          },
        ),
      ),
    );
  }
}
