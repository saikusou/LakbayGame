import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/Views/game/lesson-two/day-two/act21a.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonTwoDayTwoActTwo1 extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayTwoActTwo1({super.key, required this.user});

  @override
  State<LessonTwoDayTwoActTwo1> createState() => _LessonTwoDayTwoActTwo1State();
}

class _LessonTwoDayTwoActTwo1State extends State<LessonTwoDayTwoActTwo1> {
  final List<String> pieces = [
    'assets/l2-d1a-1.png',
    'assets/l2-d1a-2.png',
    'assets/l2-d1a-3.png',
    'assets/l2-d1a-4.png',
  ];

  final List<int?> placed = List<int?>.filled(4, null);

  Timer? _timer;

  int elapsedSeconds = 0;

  bool timerStopped = false;
  bool popupShown = false;
  bool isSaving = false;
  bool isNavigating = false;

  int get score {
    if (elapsedSeconds <= 10) {
      return 20;
    }

    if (elapsedSeconds <= 20) {
      return 15;
    }

    return 10;
  }

  bool get isCompleted {
    for (int index = 0; index < placed.length; index++) {
      if (placed[index] != index) {
        return false;
      }
    }

    return true;
  }

  String get formattedTime {
    final int minutes = elapsedSeconds ~/ 60;
    final int seconds = elapsedSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

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

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || timerStopped) {
        return;
      }

      setState(() {
        elapsedSeconds++;
      });
    });
  }

  void resetPuzzle() {
    if (isSaving || isNavigating) {
      return;
    }

    _timer?.cancel();

    setState(() {
      for (int index = 0; index < placed.length; index++) {
        placed[index] = null;
      }

      elapsedSeconds = 0;
      timerStopped = false;
      popupShown = false;
      isSaving = false;
      isNavigating = false;
    });

    startTimer();
  }

  void returnPieceToTray(int slotIndex) {
    if (timerStopped || isSaving || isNavigating) {
      return;
    }

    if (placed[slotIndex] == null) {
      return;
    }

    setState(() {
      placed[slotIndex] = null;
    });
  }

  void placePiece({required int slotIndex, required int pieceIndex}) {
    if (timerStopped || isSaving || isNavigating) {
      return;
    }

    setState(() {
      for (int index = 0; index < placed.length; index++) {
        if (placed[index] == pieceIndex) {
          placed[index] = null;
        }
      }

      placed[slotIndex] = pieceIndex;
    });

    if (isCompleted) {
      completePuzzle();
    }
  }

  void completePuzzle() {
    if (popupShown || timerStopped) {
      return;
    }

    _timer?.cancel();

    setState(() {
      timerStopped = true;
      popupShown = true;
    });

    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        showCongratulationsPopup();
      }
    });
  }

  Future<void> handleSavePoints({required int totalScore}) async {
    await ApiService.savePoints(
      userId: widget.user.id,
      countedPoints: totalScore,
      lesson: 'Lesson 2',
      day: 'Day 2',
      act: 'Act 2a',
    );
  }

  Future<void> goToNextPage(
    BuildContext dialogContext,
    StateSetter setDialogState,
  ) async {
    if (isSaving || isNavigating) {
      return;
    }

    isSaving = true;

    setDialogState(() {});

    try {
      await handleSavePoints(totalScore: score);

      debugPrint('Points saved successfully.');
    } catch (error) {
      // Ignore duplicate activity errors and other save errors.
      // The student will still proceed to the next puzzle.
      debugPrint('Points already recorded or could not be saved: $error');
    }

    if (!mounted) {
      return;
    }

    isSaving = false;
    isNavigating = true;

    if (Navigator.of(dialogContext).canPop()) {
      Navigator.of(dialogContext).pop();
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LessonTwoDayTwoActTwoB(user: widget.user),
      ),
    );
  }

  Widget gameButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    required double width,
    required double height,
    bool compact = false,
    bool disabled = false,
  }) {
    final bool isSmallPhone = width < 360;

    final double buttonHeight = clampDouble(
      height * (isSmallPhone ? 0.045 : 0.055),
      35,
      compact ? 46 : 55,
    );

    final double horizontalPadding = clampDouble(
      width * (compact ? 0.025 : 0.04),
      8,
      compact ? 16 : 24,
    );

    final double buttonFontSize = clampDouble(
      width * (compact ? 0.032 : 0.04),
      11,
      compact ? 15 : 18,
    );

    final double iconSize = clampDouble(width * 0.045, 15, compact ? 20 : 25);

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: disabled ? 0.65 : 1,
        child: Container(
          height: buttonHeight,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(
            color: const Color(0xFF0D63B7),
            borderRadius: BorderRadius.circular(buttonHeight / 2),
            border: Border.all(
              color: const Color(0xFFFFD84A),
              width: clampDouble(width * 0.007, 2, 4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: clampDouble(width * 0.012, 4, 8)),
              Icon(icon, color: Colors.white, size: iconSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPuzzleSlot({required int slotIndex}) {
    final int? currentPiece = placed[slotIndex];

    return DragTarget<int>(
      onWillAcceptWithDetails: (_) {
        return !timerStopped && !isSaving && !isNavigating;
      },
      onAcceptWithDetails: (details) {
        placePiece(slotIndex: slotIndex, pieceIndex: details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final bool isHovering = candidateData.isNotEmpty;

        final bool isCorrect = currentPiece == slotIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isHovering ? const Color(0xFFE2F6FF) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCorrect
                  ? Colors.green
                  : isHovering
                  ? const Color(0xFFFFB300)
                  : const Color(0xFF0B65AE),
              width: isHovering ? 4 : 3,
            ),
          ),
          child: currentPiece == null
              ? const Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                )
              : Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      returnPieceToTray(slotIndex);
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            pieces[currentPiece],
                            fit: BoxFit.fill,
                          ),
                        ),
                        if (!timerStopped)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.55),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.undo,
                                size: 14,
                                color: Colors.white,
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
  }

  Widget buildAvailablePiece({
    required int pieceIndex,
    required double pieceWidth,
    required double pieceHeight,
  }) {
    final bool alreadyPlaced = placed.contains(pieceIndex);

    if (alreadyPlaced) {
      return SizedBox(width: pieceWidth, height: pieceHeight);
    }

    return Draggable<int>(
      data: pieceIndex,
      maxSimultaneousDrags: timerStopped || isSaving || isNavigating ? 0 : 1,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 7,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              pieces[pieceIndex],
              width: pieceWidth * 1.15,
              height: pieceHeight * 1.15,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.25,
        child: Image.asset(
          pieces[pieceIndex],
          width: pieceWidth,
          height: pieceHeight,
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF126FC0), width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            pieces[pieceIndex],
            width: pieceWidth,
            height: pieceHeight,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  void showCongratulationsPopup() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final Size screenSize = MediaQuery.sizeOf(dialogContext);

        final double popupWidth = clampDouble(
          screenSize.width * 0.88,
          285,
          430,
        );

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(14),
              child: Container(
                width: popupWidth,
                padding: EdgeInsets.all(
                  clampDouble(screenSize.width * 0.045, 14, 20),
                ),
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
                      size: clampDouble(screenSize.width * 0.15, 48, 65),
                      color: const Color(0xFFFFC928),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Congratulations!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: clampDouble(screenSize.width * 0.065, 21, 28),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF126FC0),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Nabuo mo ang puzzle!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: clampDouble(screenSize.width * 0.04, 14, 18),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF123B63),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: clampDouble(
                          screenSize.width * 0.035,
                          10,
                          16,
                        ),
                        vertical: clampDouble(screenSize.height * 0.012, 8, 12),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFF126FC0),
                          width: 3,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'TIME',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF126FC0),
                                  ),
                                ),
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    fontSize: clampDouble(
                                      screenSize.width * 0.062,
                                      22,
                                      28,
                                    ),
                                    fontWeight: FontWeight.w900,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 45,
                            color: Colors.grey.shade300,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color(0xFFFFC928),
                                      size: 18,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'SCORE',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF126FC0),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '$score Points',
                                  style: TextStyle(
                                    fontSize: clampDouble(
                                      screenSize.width * 0.055,
                                      19,
                                      25,
                                    ),
                                    fontWeight: FontWeight.w900,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: gameButton(
                            text: 'PLAY AGAIN',
                            icon: Icons.refresh,
                            width: screenSize.width,
                            height: screenSize.height,
                            compact: true,
                            disabled: isSaving || isNavigating,
                            onTap: () {
                              Navigator.of(dialogContext).pop();

                              resetPuzzle();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: gameButton(
                            text: isSaving ? 'SAVING' : 'NEXT',
                            icon: isSaving
                                ? Icons.hourglass_top
                                : Icons.arrow_forward,
                            width: screenSize.width,
                            height: screenSize.height,
                            compact: true,
                            disabled: isSaving || isNavigating,
                            onTap: () {
                              goToNextPage(dialogContext, setDialogState);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildClock({
    required double timerWidth,
    required double timerHeight,
    required double width,
  }) {
    return Container(
      width: timerWidth,
      height: timerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF126FC0),
          width: clampDouble(width * 0.008, 3, 4),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3)),
        ],
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedTime,
                style: TextStyle(
                  fontSize: clampDouble(width * 0.048, 14, 20),
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 1),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final double height = constraints.maxHeight;

            final bool isSmallPhone = height < 720;
            final bool isVerySmallPhone = height < 640;

            final double horizontalPadding = clampDouble(width * 0.035, 10, 18);

            final double titleFontSize = clampDouble(width * 0.068, 21, 30);

            final double instructionFontSize = clampDouble(
              width * 0.038,
              12,
              16,
            );

            final double boardWidth = clampDouble(width * 0.92, 300, 460);

            final double boardHeight = clampDouble(
              boardWidth * 0.62,
              185,
              isSmallPhone ? 245 : 285,
            );

            final double pieceWidth = clampDouble(
              width * 0.205,
              58,
              isSmallPhone ? 84 : 100,
            );

            final double pieceHeight = pieceWidth * 0.72;

            final double timerWidth = clampDouble(width * 0.25, 74, 100);

            final double timerHeight = clampDouble(height * 0.08, 52, 72);

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
                        isVerySmallPhone ? 6 : 10,
                        horizontalPadding,
                        16,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: isVerySmallPhone ? 5 : 8,
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
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
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
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFFFFD84A),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 34),
                              ],
                            ),
                          ),
                          SizedBox(height: isVerySmallPhone ? 8 : 12),
                          Container(
                            width: boardWidth,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: isVerySmallPhone ? 8 : 11,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFCF3),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFF1781D3),
                                width: 3,
                              ),
                            ),
                            child: Text(
                              'Ayusin ang apat na bahagi upang mabuo ang '
                              'larawan. Pindutin ang nakalagay na puzzle '
                              'upang ibalik ito.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: instructionFontSize,
                                height: 1.15,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF123B63),
                              ),
                            ),
                          ),
                          SizedBox(height: isVerySmallPhone ? 8 : 12),
                          Container(
                            width: boardWidth,
                            height: boardHeight,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFCF3),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF1781D3),
                                width: 3,
                              ),
                            ),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.75,
                                  ),
                              itemBuilder: (context, slotIndex) {
                                return buildPuzzleSlot(slotIndex: slotIndex);
                              },
                            ),
                          ),
                          SizedBox(height: isVerySmallPhone ? 9 : 14),
                          SizedBox(
                            width: boardWidth,
                            child: Wrap(
                              spacing: isSmallPhone ? 8 : 12,
                              runSpacing: isSmallPhone ? 8 : 12,
                              alignment: WrapAlignment.center,
                              children: List.generate(pieces.length, (
                                pieceIndex,
                              ) {
                                return buildAvailablePiece(
                                  pieceIndex: pieceIndex,
                                  pieceWidth: pieceWidth,
                                  pieceHeight: pieceHeight,
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: isVerySmallPhone ? 12 : 18),
                          SizedBox(
                            width: boardWidth,
                            child: Center(
                              child: buildClock(
                                timerWidth: timerWidth,
                                timerHeight: timerHeight,
                                width: width,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
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
