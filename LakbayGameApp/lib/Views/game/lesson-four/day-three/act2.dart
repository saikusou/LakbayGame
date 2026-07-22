import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonFourDayThreeActTwo extends StatefulWidget {
  final UserModel user;

  const LessonFourDayThreeActTwo({super.key, required this.user});

  @override
  State<LessonFourDayThreeActTwo> createState() =>
      _LessonFourDayThreeActTwoState();
}

class _LessonFourDayThreeActTwoState extends State<LessonFourDayThreeActTwo> {
  static const int totalPuzzles = 3;

  final List<List<String>> puzzlePieces = const [
    [
      'assets/l4-d3-1.png',
      'assets/l4-d3-2.png',
      'assets/l4-d3-3.png',
      'assets/l4-d3-4.png',
    ],
    [
      'assets/l3-d1-1.png',
      'assets/l3-d1-2.png',
      'assets/l3-d1-3.png',
      'assets/l3-d1-4.png',
    ],
    [
      'assets/l4-d3-9.png',
      'assets/l4-d3-10.png',
      'assets/l4-d3-11.png',
      'assets/l4-d3-12.png',
    ],
  ];

  final List<int?> placed = List<int?>.filled(4, null);

  int currentPuzzle = 0;
  int elapsedSeconds = 0;

  bool isCompleting = false;
  bool isSaving = false;

  Timer? _timer;

  List<String> get pieces => puzzlePieces[currentPuzzle];

  int get score {
    if (elapsedSeconds <= 30) return 20;
    if (elapsedSeconds <= 60) return 15;
    return 10;
  }

  String get formattedTime {
    final int minutes = elapsedSeconds ~/ 60;
    final int seconds = elapsedSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  bool get isPuzzleComplete {
    for (int index = 0; index < placed.length; index++) {
      if (placed[index] != index) {
        return false;
      }
    }

    return true;
  }

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

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || isCompleting && currentPuzzle == totalPuzzles - 1) {
        return;
      }

      setState(() {
        elapsedSeconds++;
      });
    });
  }

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  Future<void> onPuzzleCompleted() async {
    if (isCompleting) return;

    setState(() {
      isCompleting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    if (currentPuzzle < totalPuzzles - 1) {
      await _showCompletedDialog(isLastPuzzle: false);

      if (!mounted) return;

      setState(() {
        currentPuzzle++;

        for (int index = 0; index < placed.length; index++) {
          placed[index] = null;
        }

        isCompleting = false;
      });

      return;
    }

    _timer?.cancel();

    await _saveScoreAndReturn();
  }

  Future<void> _saveScoreAndReturn() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    String message = 'Naisumite na ang iyong $score puntos.';

    try {
      await ApiService.savePoints(
        userId: widget.user.id,
        countedPoints: score,
        lesson: 'Lesson 4',
        day: 'Day 3',
        act: 'Act 2',
      );
    } catch (error) {
      // Duplicate score or connection errors will not block navigation.
      debugPrint('Save points result: $error');

      message = 'Tapos na ang gawain. Babalik ka na sa Lesson 4.';
    }

    if (!mounted) return;

    await _showCompletedDialog(isLastPuzzle: true, message: message);

    if (!mounted) return;

    /*
     * Close this activity and reveal the existing Lesson 4 screen.
     * Do not create another Lesson4Screen using pushAndRemoveUntil.
     */
    Navigator.of(context).pop(true);
  }

  Future<void> _showCompletedDialog({
    required bool isLastPuzzle,
    String? message,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFF126FC0), width: 4),
            ),
            icon: const Icon(
              Icons.emoji_events,
              color: Color(0xFFFFC928),
              size: 58,
            ),
            title: Text(
              isLastPuzzle ? 'Congratulations!' : 'Puzzle Complete!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF126FC0),
                fontWeight: FontWeight.w900,
              ),
            ),
            content: Text(
              message ??
                  'Nabuo mo ang Puzzle ${currentPuzzle + 1} '
                      'sa $totalPuzzles.\n'
                      'Oras: $formattedTime',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF123B63),
                fontWeight: FontWeight.w700,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D63B7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  /*
                   * Only close the dialog here.
                   * Navigation happens after showDialog finishes.
                   */
                  Navigator.of(dialogContext).pop();
                },
                icon: Icon(isLastPuzzle ? Icons.home : Icons.arrow_forward),
                label: Text(isLastPuzzle ? 'LESSON 4' : 'NEXT PUZZLE'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleBackButton() {
    if (isCompleting || isSaving) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth;
            final double height = constraints.maxHeight;

            final double boardWidth = clampDouble(width * 0.92, 300, 460);

            final double boardHeight = clampDouble(boardWidth * 0.62, 185, 285);

            final double pieceWidth = clampDouble(width * 0.205, 58, 100);

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
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
                child: Column(
                  children: [
                    _buildHeader(width),
                    const SizedBox(height: 12),
                    _buildInstructions(boardWidth, width),
                    const SizedBox(height: 12),
                    _buildBoard(boardWidth, boardHeight),
                    const SizedBox(height: 14),
                    _buildPieceTray(boardWidth, pieceWidth, pieceHeight),
                    const SizedBox(height: 18),
                    _buildTimer(width),
                    SizedBox(height: clampDouble(height * 0.01, 4, 12)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF126FC0),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: isCompleting || isSaving ? null : _handleBackButton,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'I-konek Mo Ako!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(width * 0.06, 20, 28),
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFD84A),
                  ),
                ),
                Text(
                  'PUZZLE ${currentPuzzle + 1} OF $totalPuzzles',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildInstructions(double boardWidth, double width) {
    return Container(
      width: boardWidth,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1781D3), width: 3),
      ),
      child: Text(
        'Ayusin ang apat na bahagi upang mabuo ang larawan.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: clampDouble(width * 0.038, 13, 16),
          fontWeight: FontWeight.w800,
          color: const Color(0xFF123B63),
        ),
      ),
    );
  }

  Widget _buildBoard(double boardWidth, double boardHeight) {
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
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.75,
        ),
        itemBuilder: (BuildContext context, int targetIndex) {
          return DragTarget<int>(
            onWillAcceptWithDetails: (DragTargetDetails<int> details) {
              return !isCompleting &&
                  !isSaving &&
                  placed[targetIndex] == null &&
                  details.data == targetIndex;
            },
            onAcceptWithDetails: (DragTargetDetails<int> details) {
              setState(() {
                placed[targetIndex] = details.data;
              });

              if (isPuzzleComplete) {
                unawaited(onPuzzleCompleted());
              }
            },
            builder:
                (
                  BuildContext context,
                  List<int?> candidateData,
                  List<dynamic> rejectedData,
                ) {
                  final int? pieceIndex = placed[targetIndex];

                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty
                          ? Colors.green.shade50
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: pieceIndex == targetIndex
                            ? Colors.green
                            : const Color(0xFF0B65AE),
                        width: 3,
                      ),
                    ),
                    child: pieceIndex == null
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
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              pieces[pieceIndex],
                              fit: BoxFit.fill,
                            ),
                          ),
                  );
                },
          );
        },
      ),
    );
  }

  Widget _buildPieceTray(
    double boardWidth,
    double pieceWidth,
    double pieceHeight,
  ) {
    return SizedBox(
      width: boardWidth,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: List<Widget>.generate(4, (int index) {
          if (placed.contains(index)) {
            return SizedBox(width: pieceWidth, height: pieceHeight);
          }

          return Draggable<int>(
            data: index,
            maxSimultaneousDrags: isCompleting || isSaving ? 0 : 1,
            feedback: Material(
              color: Colors.transparent,
              child: Image.asset(
                pieces[index],
                width: pieceWidth * 1.15,
                height: pieceHeight * 1.15,
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
      ),
    );
  }

  Widget _buildTimer(double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF126FC0), width: 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Color(0xFF126FC0),
            ),
          ),
        ],
      ),
    );
  }
}
