import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonFourDayOneActThree extends StatefulWidget {
  final UserModel user;

  const LessonFourDayOneActThree({super.key, required this.user});

  @override
  State<LessonFourDayOneActThree> createState() =>
      _LessonFourDayOneActThreeState();
}

class _LessonFourDayOneActThreeState extends State<LessonFourDayOneActThree> {
  static const int pointsPerPuzzle = 20;
  static const int totalPuzzleCount = 5;
  static const int maximumScore =
      pointsPerPuzzle * totalPuzzleCount; // 100 points

  /*
   * Each puzzle needs:
   * 1. Four separate puzzle-piece images
   * 2. One complete/correct image
   *
   * Change these asset paths to match your actual filenames.
   */
  final List<PuzzleData> puzzles = const [
    PuzzleData(
      pieces: [
        'assets/l3-d1-1.png',
        'assets/l3-d1-2.png',
        'assets/l3-d1-3.png',
        'assets/l3-d1-4.png',
      ],
      correctImage: 'assets/l3-d1-complete-1.png',
    ),
    PuzzleData(
      pieces: [
        'assets/l3-d1-5.png',
        'assets/l3-d1-6.png',
        'assets/l3-d1-7.png',
        'assets/l3-d1-8.png',
      ],
      correctImage: 'assets/l3-d1-complete-2.png',
    ),
    PuzzleData(
      pieces: [
        'assets/l3-d1-9.png',
        'assets/l3-d1-10.png',
        'assets/l3-d1-11.png',
        'assets/l3-d1-12.png',
      ],
      correctImage: 'assets/l3-d1-complete-3.png',
    ),
    PuzzleData(
      pieces: [
        'assets/l3-d1-13.png',
        'assets/l3-d1-14.png',
        'assets/l3-d1-15.png',
        'assets/l3-d1-16.png',
      ],
      correctImage: 'assets/l3-d1-complete-4.png',
    ),
    PuzzleData(
      pieces: [
        'assets/l3-d1-17.png',
        'assets/l3-d1-18.png',
        'assets/l3-d1-19.png',
        'assets/l3-d1-20.png',
      ],
      correctImage: 'assets/l3-d1-complete-5.png',
    ),
  ];

  final List<int?> placedPieces = List<int?>.filled(4, null);

  Timer? _timer;

  int currentPuzzleIndex = 0;
  int elapsedSeconds = 0;
  int completedPuzzleCount = 0;

  bool puzzleSolved = false;
  bool popupShown = false;
  bool isSaving = false;
  bool scoreSaved = false;

  PuzzleData get currentPuzzle => puzzles[currentPuzzleIndex];

  int get currentPuzzleNumber => currentPuzzleIndex + 1;

  int get currentScore => completedPuzzleCount * pointsPerPuzzle;

  bool get isLastPuzzle => currentPuzzleIndex == puzzles.length - 1;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || puzzleSolved) return;

      setState(() {
        elapsedSeconds++;
      });
    });
  }

  String get formattedTime {
    final int minutes = elapsedSeconds ~/ 60;
    final int seconds = elapsedSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  bool get puzzleIsCorrect {
    for (int position = 0; position < placedPieces.length; position++) {
      if (placedPieces[position] != position) {
        return false;
      }
    }

    return true;
  }

  Future<void> _placePiece({
    required int position,
    required int pieceIndex,
  }) async {
    if (puzzleSolved) return;

    // Do not replace a position that already contains a piece.
    if (placedPieces[position] != null) return;

    // Only accept the piece in its correct position.
    if (pieceIndex != position) {
      _showWrongPositionMessage();
      return;
    }

    setState(() {
      placedPieces[position] = pieceIndex;
    });

    if (puzzleIsCorrect) {
      await _completeCurrentPuzzle();
    }
  }

  void _showWrongPositionMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 900),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text(
            'Hindi ito ang tamang puwesto. Subukan muli!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      );
  }

  Future<void> _completeCurrentPuzzle() async {
    if (puzzleSolved || popupShown) return;

    setState(() {
      puzzleSolved = true;
      popupShown = true;
      completedPuzzleCount++;
    });

    _timer?.cancel();

    // Save all 100 points after completing puzzle 5.
    if (isLastPuzzle) {
      await _saveFinalScore();
    }

    if (!mounted) return;

    await _showCorrectPicturePopup();
  }

  Future<void> _saveFinalScore() async {
    if (isSaving || scoreSaved) return;

    setState(() {
      isSaving = true;
    });

    try {
      await ApiService.savePoints(
        userId: widget.user.id,
        countedPoints: maximumScore,
        lesson: 'Lesson 4',
        day: 'Day 1',
        act: 'Act 3',
      );

      scoreSaved = true;
    } catch (error) {
      /*
       * This allows the student to continue when the score was
       * previously saved and the API returns a duplicate error.
       */
      debugPrint('Save points response: $error');
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _showCorrectPicturePopup() async {
    final bool finalPuzzle = isLastPuzzle;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final Size size = MediaQuery.of(dialogContext).size;
        final double width = size.width;
        final double dialogWidth = clampDouble(width * 0.96, 300, 760);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Container(
            width: dialogWidth,
            padding: EdgeInsets.all(clampDouble(width * 0.025, 10, 16)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF3),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFF126FC0), width: 5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The complete picture is intentionally the largest
                  // element in the result popup.
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: LayoutBuilder(
                        builder: (context, imageConstraints) {
                          final double imageWidth = imageConstraints.maxWidth;
                          final double imageHeight = clampDouble(
                            imageWidth / 1.75,
                            170,
                            MediaQuery.of(dialogContext).size.height * 0.52,
                          );

                          return SizedBox(
                            width: imageWidth,
                            height: imageHeight,
                            child: _buildCompletedImage(),
                          );
                        },
                      ),
                    ),
                  ),
                  if (finalPuzzle) ...[
                    const SizedBox(height: 6),
                    SizedBox(
                      width: clampDouble(width * 0.28, 100, 130),
                      child: _resultBox(
                        title: 'TOTAL POINTS',
                        value: '$currentScore',
                        color: Colors.green,
                        width: width,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  _popupButton(
                    label: finalPuzzle ? 'OK' : 'NEXT PUZZLE',
                    icon: finalPuzzle ? Icons.check : Icons.navigate_next,
                    width: width,
                    isLoading: finalPuzzle && isSaving,
                    onTap: () {
                      if (finalPuzzle && isSaving) return;

                      Navigator.pop(dialogContext);

                      if (finalPuzzle) {
                        _returnToLessonFour();
                      } else {
                        _openNextPuzzle();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedImage() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.75,
      ),
      itemBuilder: (context, index) {
        return Image.asset(
          currentPuzzle.pieces[index],
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          isAntiAlias: true,
        );
      },
    );
  }

  void _openNextPuzzle() {
    if (isLastPuzzle) return;

    setState(() {
      currentPuzzleIndex++;

      for (int index = 0; index < placedPieces.length; index++) {
        placedPieces[index] = null;
      }

      puzzleSolved = false;
      popupShown = false;
    });

    _startTimer();
  }

  void _returnToLessonFour() {
    if (!mounted) return;

    // Close this activity and reveal the Lesson 4 page or its modal.
    Navigator.of(context).pop();
  }

  Widget _resultBox({
    required String title,
    required String value,
    required Color color,
    required double width,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: Color(0xFF126FC0),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: clampDouble(width * 0.038, 15, 19),
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _popupButton({
    required String label,
    required IconData icon,
    required double width,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: clampDouble(width * 0.60, 210, 280),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isLoading ? Colors.blueGrey : const Color(0xFF0D63B7),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFFFD84A), width: 4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            else ...[
              Text(
                label,
                style: TextStyle(
                  fontSize: clampDouble(width * 0.042, 15, 18),
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzleBoard({
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
        itemBuilder: (context, position) {
          return DragTarget<int>(
            onWillAcceptWithDetails: (details) {
              if (puzzleSolved) return false;
              if (placedPieces[position] != null) return false;

              return details.data == position;
            },
            onAcceptWithDetails: (details) {
              _placePiece(position: position, pieceIndex: details.data);
            },
            builder: (context, candidateData, rejectedData) {
              final bool isCandidate = candidateData.isNotEmpty;
              final int? pieceIndex = placedPieces[position];

              return Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isCandidate ? Colors.green.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: pieceIndex == position
                        ? Colors.green
                        : const Color(0xFF0B65AE),
                    width: 3,
                  ),
                ),
                child: pieceIndex == null
                    ? Center(
                        child: Text(
                          '${position + 1}',
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            color: Colors.blueGrey,
                          ),
                        ),
                      )
                    : Image.asset(
                        currentPuzzle.pieces[pieceIndex],
                        fit: BoxFit.fill,
                      ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAvailablePieces({
    required double pieceWidth,
    required double pieceHeight,
    required bool isSmall,
  }) {
    return Wrap(
      spacing: isSmall ? 7 : 12,
      runSpacing: isSmall ? 7 : 12,
      alignment: WrapAlignment.center,
      children: List<Widget>.generate(4, (pieceIndex) {
        final bool alreadyPlaced = placedPieces.contains(pieceIndex);

        if (alreadyPlaced) {
          return SizedBox(width: pieceWidth, height: pieceHeight);
        }

        return Draggable<int>(
          data: pieceIndex,
          maxSimultaneousDrags: puzzleSolved ? 0 : 1,
          feedback: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 7),
                ],
              ),
              child: Image.asset(
                currentPuzzle.pieces[pieceIndex],
                width: pieceWidth * 1.10,
                height: pieceHeight * 1.10,
                fit: BoxFit.fill,
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.25,
            child: Image.asset(
              currentPuzzle.pieces[pieceIndex],
              width: pieceWidth,
              height: pieceHeight,
              fit: BoxFit.fill,
            ),
          ),
          child: Image.asset(
            currentPuzzle.pieces[pieceIndex],
            width: pieceWidth,
            height: pieceHeight,
            fit: BoxFit.fill,
          ),
        );
      }),
    );
  }

  Widget _buildTimerBox({required double width}) {
    return Container(
      width: clampDouble(width * 0.31, 100, 130),
      height: clampDouble(width * 0.15, 52, 64),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF126FC0), width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: clampDouble(width * 0.048, 17, 22),
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
    );
  }

  Widget _buildProgressBox({required double width}) {
    return Container(
      height: clampDouble(width * 0.15, 52, 64),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D63B7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFD84A), width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$currentPuzzleNumber/$totalPuzzleCount',
            style: TextStyle(
              fontSize: clampDouble(width * 0.048, 17, 22),
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const Text(
            'PUZZLE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFFD84A),
            ),
          ),
        ],
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

            final bool isSmallHeight = height < 720;
            final bool isVerySmallHeight = height < 650;

            final double horizontalPadding = clampDouble(width * 0.035, 10, 18);

            final double boardWidth = clampDouble(width * 0.92, 285, 470);

            final double boardHeight = clampDouble(
              boardWidth * 0.62,
              170,
              isVerySmallHeight ? 220 : 285,
            );

            final double pieceWidth = clampDouble(
              width * 0.215,
              58,
              isSmallHeight ? 82 : 105,
            );

            final double pieceHeight = pieceWidth * 0.72;

            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFBDEEFF), Colors.white, Color(0xFFC9F6B8)],
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
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: clampDouble(
                                      width * 0.062,
                                      20,
                                      30,
                                    ),
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
                            'Puzzle $currentPuzzleNumber of 5\n'
                            'Ayusin ang apat na bahagi upang '
                            'mabuo ang larawan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: clampDouble(width * 0.037, 12, 17),
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF123B63),
                            ),
                          ),
                        ),
                        SizedBox(height: isVerySmallHeight ? 7 : 11),
                        _buildPuzzleBoard(
                          boardWidth: boardWidth,
                          boardHeight: boardHeight,
                        ),
                        SizedBox(height: isVerySmallHeight ? 8 : 13),
                        _buildAvailablePieces(
                          pieceWidth: pieceWidth,
                          pieceHeight: pieceHeight,
                          isSmall: isSmallHeight,
                        ),
                        SizedBox(height: isVerySmallHeight ? 10 : 16),

                        // RESET was removed.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTimerBox(width: width),
                            const SizedBox(width: 14),
                            _buildProgressBox(width: width),
                          ],
                        ),
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

class PuzzleData {
  final List<String> pieces;
  final String correctImage;

  const PuzzleData({required this.pieces, required this.correctImage});
}
