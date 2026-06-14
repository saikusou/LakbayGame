import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonTwoDayTwoActTwo extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayTwoActTwo({super.key, required this.user});

  @override
  State<LessonTwoDayTwoActTwo> createState() => _LessonTwoDayTwoActTwoState();
}

class _LessonTwoDayTwoActTwoState extends State<LessonTwoDayTwoActTwo> {
  final List<String> pieces = [
    'assets/l2-d1-3.png',
    'assets/l2-d1-4.png',
    'assets/l2-d1-1.png',
    'assets/l2-d1-2.png',
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
      if (mounted) {
        showCongratulationsPopup();
      }
    });
  }

  void showCongratulationsPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final popupWidth = clampDouble(size.width * 0.86, 285, 420);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(18),
          child: Container(
            width: popupWidth,
            padding: const EdgeInsets.all(22),
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
                const Icon(
                  Icons.emoji_events,
                  size: 70,
                  color: Color(0xFFFFC928),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Congratulations!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF126FC0),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nabuo mo ang puzzle!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF123B63),
                  ),
                ),
                const SizedBox(height: 18),
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
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      for (int i = 0; i < placed.length; i++) {
                        placed[i] = null;
                      }

                      elapsedSeconds = 0;
                      timerStopped = false;
                      popupShown = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 13,
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
                          'PLAY AGAIN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.refresh, color: Colors.white, size: 25),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            final bool isSmallPhone = height < 720;
            final bool isVerySmallPhone = height < 640;

            final double horizontalPadding = clampDouble(width * 0.035, 10, 18);

            final double titleFont = clampDouble(width * 0.068, 21, 30);
            final double instructionFont = clampDouble(width * 0.038, 12, 16);

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

            final double timerWidth = clampDouble(width * 0.25, 78, 100);
            final double timerHeight = clampDouble(height * 0.075, 52, 68);

            final double resetHeight = clampDouble(height * 0.065, 44, 58);
            final double resetFont = clampDouble(width * 0.047, 16, 21);

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
                              'Ayusin ang apat na bahagi upang mabuo ang larawan.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: instructionFont,
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
                                  builder:
                                      (context, candidateData, rejectedData) {
                                        return Container(
                                          margin: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                                      fontSize: 34,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                )
                                              : Image.asset(
                                                  pieces[placed[index]!],
                                                  fit: BoxFit.fill,
                                                ),
                                        );
                                      },
                                );
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
                              children: List.generate(4, (index) {
                                final bool alreadyPlaced = placed.contains(
                                  index,
                                );

                                if (alreadyPlaced) {
                                  return SizedBox(
                                    width: pieceWidth,
                                    height: pieceHeight,
                                  );
                                }

                                return Draggable<int>(
                                  data: index,
                                  maxSimultaneousDrags: timerStopped ? 0 : 1,
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: Image.asset(
                                      pieces[index],
                                      width: pieceWidth * 1.2,
                                      height: pieceHeight * 1.2,
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
                            ),
                          ),

                          SizedBox(height: isVerySmallPhone ? 12 : 18),

                          SizedBox(
                            width: boardWidth,
                            child: Row(
                              children: [
                                Container(
                                  width: timerWidth,
                                  height: timerHeight,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: const Color(0xFF126FC0),
                                      width: 4,
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          formattedTime,
                                          style: TextStyle(
                                            fontSize: clampDouble(
                                              width * 0.052,
                                              16,
                                              22,
                                            ),
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
                                ),

                                const Spacer(),

                                GestureDetector(
                                  onTap: resetPuzzle,
                                  child: Container(
                                    height: resetHeight,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: clampDouble(
                                        width * 0.052,
                                        15,
                                        24,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0D63B7),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: const Color(0xFFFFD84A),
                                        width: 5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'RESET',
                                          style: TextStyle(
                                            fontSize: resetFont,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.refresh,
                                          color: Colors.white,
                                          size: clampDouble(
                                            width * 0.062,
                                            21,
                                            28,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
