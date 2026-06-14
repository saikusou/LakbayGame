import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/game/lesson-two/day-two/act2a.dart';
import 'package:lakbay_game/Views/lesson2.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonTwoDayTwoActTwo extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayTwoActTwo({super.key, required this.user});

  @override
  State<LessonTwoDayTwoActTwo> createState() => _LessonTwoDayTwoActTwoState();
}

class _LessonTwoDayTwoActTwoState extends State<LessonTwoDayTwoActTwo> {
  final List<String> pieces = [
    'assets/l2-d1-1.png',
    'assets/l2-d1-2.png',
    'assets/l2-d1-3.png',
    'assets/l2-d1-4.png',
  ];

  final List<int?> placed = List.filled(4, null);

  Timer? _timer;
  int elapsedSeconds = 0;
  bool timerStopped = false;
  bool popupShown = false;

  int get score {
    if (elapsedSeconds <= 10) return 20;
    if (elapsedSeconds <= 20) return 15;
    return 10;
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
      elapsedSeconds = 0;
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

  Widget gameButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    required double width,
    required double height,
    bool compact = false,
  }) {
    final bool isSmallPhone = width < 360;

    final double buttonHeight = clampDouble(
      height * (isSmallPhone ? 0.045 : 0.055),
      35,
      compact ? 46 : 55,
    );

    final double buttonPadding = clampDouble(
      width * (compact ? 0.025 : 0.04),
      8,
      compact ? 16 : 24,
    );

    final double buttonFont = clampDouble(
      width * (compact ? 0.032 : 0.04),
      11,
      compact ? 15 : 18,
    );

    final double iconSize = clampDouble(width * 0.045, 15, compact ? 20 : 25);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: buttonPadding),
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
                fontSize: buttonFont,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            SizedBox(width: clampDouble(width * 0.012, 4, 8)),
            Icon(icon, color: Colors.white, size: iconSize),
          ],
        ),
      ),
    );
  }

  void showCongratulationsPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final popupWidth = clampDouble(size.width * 0.88, 285, 430);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(14),
          child: Container(
            width: popupWidth,
            padding: EdgeInsets.all(clampDouble(size.width * 0.045, 14, 20)),
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
                  size: clampDouble(size.width * 0.15, 48, 65),
                  color: const Color(0xFFFFC928),
                ),
                const SizedBox(height: 8),
                Text(
                  'Congratulations!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.065, 21, 28),
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF126FC0),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nabuo mo ang puzzle!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.04, 14, 18),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF123B63),
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: clampDouble(size.width * 0.035, 10, 16),
                    vertical: clampDouble(size.height * 0.012, 8, 12),
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
                                  size.width * 0.062,
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
                                  size.width * 0.055,
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
                        width: size.width,
                        height: size.height,
                        compact: true,
                        onTap: () {
                          Navigator.pop(context);
                          resetPuzzle();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: gameButton(
                        text: 'NEXT',
                        icon: Icons.arrow_forward,
                        width: size.width,
                        height: size.height,
                        compact: true,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LessonTwoDayTwoActTwoA(user: widget.user),
                            ),
                          );
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
                                      width: clampDouble(width * 0.008, 3, 4),
                                    ),
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
                                              fontSize: clampDouble(
                                                width * 0.048,
                                                14,
                                                20,
                                              ),
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
                                ),

                                const Spacer(),

                                gameButton(
                                  text: 'RESET',
                                  icon: Icons.refresh,
                                  width: width,
                                  height: height,
                                  onTap: resetPuzzle,
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
