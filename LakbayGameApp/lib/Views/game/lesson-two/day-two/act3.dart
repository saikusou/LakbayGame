import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson2.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class HiddenPopup extends StatelessWidget {
  final UserModel user;
  final String image;

  const HiddenPopup({super.key, required this.image, required this.user});

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    final popupWidth = clampDouble(screenSize.width * 0.88, 280, 420);

    final popupHeight = clampDouble(screenSize.height * 0.65, 360, 560);

    final closeButtonSize = clampDouble(popupWidth * 0.12, 36, 48);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: clampDouble(screenSize.width * 0.04, 12, 24),
        vertical: clampDouble(screenSize.height * 0.03, 12, 28),
      ),
      child: Container(
        width: popupWidth,
        height: popupHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.orange,
            width: clampDouble(popupWidth * 0.012, 3, 5),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              image,
              fit: BoxFit.fill,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.broken_image_rounded,
                            color: Colors.red,
                            size: 60,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Image not found',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            image,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
            ),

            // CLOSE BUTTON
            Positioned(
              top: clampDouble(popupHeight * 0.025, 8, 14),
              right: clampDouble(popupWidth * 0.025, 8, 14),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: closeButtonSize,
                    height: closeButtonSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'X',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: clampDouble(closeButtonSize * 0.48, 16, 22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CongratsPopup extends StatefulWidget {
  final int totalPoints;
  final Future<void> Function() onOk;

  const CongratsPopup({
    super.key,
    required this.totalPoints,
    required this.onOk,
  });

  @override
  State<CongratsPopup> createState() {
    return _CongratsPopupState();
  }
}

class _CongratsPopupState extends State<CongratsPopup> {
  bool isSaving = false;

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  Future<void> handleOk() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      await widget.onOk();

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save score: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return PopScope(
      canPop: !isSaving,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: clampDouble(screenSize.width * 0.06, 18, 28),
        ),
        child: Container(
          width: clampDouble(screenSize.width * 0.85, 280, 390),
          padding: EdgeInsets.symmetric(
            horizontal: clampDouble(screenSize.width * 0.06, 18, 28),
            vertical: clampDouble(screenSize.height * 0.035, 22, 35),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3D6),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.orange, width: 5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: clampDouble(screenSize.width * 0.20, 70, 95),
              ),
              SizedBox(height: clampDouble(screenSize.height * 0.015, 10, 18)),
              Text(
                'Congratulations!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: clampDouble(screenSize.width * 0.075, 25, 34),
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: clampDouble(screenSize.height * 0.015, 10, 18)),
              Text(
                '${widget.totalPoints} points total',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: clampDouble(screenSize.width * 0.055, 20, 26),
                  fontWeight: FontWeight.w700,
                  color: Colors.orange.shade900,
                ),
              ),
              SizedBox(height: clampDouble(screenSize.height * 0.03, 20, 30)),
              SizedBox(
                width: double.infinity,
                height: clampDouble(screenSize.height * 0.065, 48, 60),
                child: ElevatedButton(
                  onPressed: isSaving ? null : handleOk,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    disabledBackgroundColor: Colors.orange.shade300,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isSaving
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Saving...',
                              style: TextStyle(
                                fontSize: clampDouble(
                                  screenSize.width * 0.045,
                                  16,
                                  22,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'OK',
                          style: TextStyle(
                            fontSize: clampDouble(
                              screenSize.width * 0.045,
                              16,
                              22,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LessonTwoDayTwoActThree extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayTwoActThree({super.key, required this.user});

  @override
  State<LessonTwoDayTwoActThree> createState() {
    return _LessonTwoDayTwoActThreeState();
  }
}

class _LessonTwoDayTwoActThreeState extends State<LessonTwoDayTwoActThree> {
  // The new background image contains five diamonds.
  static const int totalDiamonds = 5;

  // Total score after opening all five diamonds.
  static const int activityPoints = 100;

  // Actual dimensions of the new image.
  static const double originalImageWidth = 1080;
  static const double originalImageHeight = 1408;

  final Set<int> clickedDiamonds = <int>{};

  bool congratulationsShown = false;
  bool alreadyScored = false;
  bool isOpeningPopup = false;

  // Only five popup pictures are required.
  final List<String> popupImages = const [
    'assets/lesson-two-day2-act3-pic1.png',
    'assets/lesson-two-day2-act3-pic2.png',
    'assets/lesson-two-day2-act3-pic3.png',
    'assets/lesson-two-day2-act3-pic4.png',
    'assets/lesson-two-day2-act3-pic5.png',
  ];

  /*
   * Coordinates are based on the 1080 × 1408 image.
   *
   * Diamond 1: upper-left
   * Diamond 2: upper-right
   * Diamond 3: middle
   * Diamond 4: lower-left
   * Diamond 5: lower-right
   */
  final List<DiamondPosition> diamondPositions = const [
    DiamondPosition(id: 1, x: 227, y: 779),
    DiamondPosition(id: 2, x: 834, y: 802),
    DiamondPosition(id: 3, x: 516, y: 944),
    DiamondPosition(id: 4, x: 226, y: 1173),
    DiamondPosition(id: 5, x: 817, y: 1198),
  ];

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  String getPopupImage(int id) {
    if (id < 1 || id > popupImages.length) {
      return popupImages.first;
    }

    return popupImages[id - 1];
  }

  Future<void> handleSavePoints({required int totalScore}) async {
    if (alreadyScored) return;

    try {
      await ApiService.savePoints(
        userId: widget.user.id,
        countedPoints: totalScore,
        lesson: 'Lesson 2',
        day: 'Day 2',
        act: 'Act 3',
      );

      alreadyScored = true;
    } catch (error) {
      final errorMessage = error.toString().toLowerCase();

      final isDuplicate =
          errorMessage.contains('already completed') ||
          errorMessage.contains('activity already completed') ||
          errorMessage.contains('conflict') ||
          errorMessage.contains('409');

      // Ignore duplicate record and continue.
      if (isDuplicate) {
        alreadyScored = true;
        return;
      }

      alreadyScored = false;
      rethrow;
    }
  }

  Future<void> showDiamondPopup({required int id}) async {
    if (!mounted || isOpeningPopup) return;

    isOpeningPopup = true;

    if (!clickedDiamonds.contains(id)) {
      setState(() {
        clickedDiamonds.add(id);
      });
    }

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return HiddenPopup(image: getPopupImage(id), user: widget.user);
        },
      );
    } finally {
      isOpeningPopup = false;
    }

    if (!mounted) return;

    final allDiamondsClicked = clickedDiamonds.length >= totalDiamonds;

    if (!allDiamondsClicked || congratulationsShown) {
      return;
    }

    setState(() {
      congratulationsShown = true;
    });

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return CongratsPopup(
          totalPoints: activityPoints,
          onOk: () async {
            await handleSavePoints(totalScore: activityPoints);
          },
        );
      },
    );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return Lesson2Screen(user: widget.user);
        },
      ),
    );
  }

  Widget buildClickableDiamond({
    required DiamondPosition diamond,
    required double imageScale,
    required double imageOffsetX,
    required double imageOffsetY,
  }) {
    // Clickable size based on the diamonds in the new image.
    const originalClickableWidth = 185.0;
    const originalClickableHeight = 155.0;

    final clickableWidth = originalClickableWidth * imageScale;

    final clickableHeight = originalClickableHeight * imageScale;

    final centerX = imageOffsetX + (diamond.x * imageScale);

    final centerY = imageOffsetY + (diamond.y * imageScale);

    final alreadyClicked = clickedDiamonds.contains(diamond.id);

    return Positioned(
      left: centerX - (clickableWidth / 2),
      top: centerY - (clickableHeight / 2),
      width: clickableWidth,
      height: clickableHeight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          showDiamondPopup(id: diamond.id);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(clickableWidth * 0.20),
            color: alreadyClicked
                ? Colors.green.withValues(alpha: 0.55)
                : Colors.transparent,
            border: alreadyClicked
                ? Border.all(
                    color: Colors.green.shade800,
                    width: clampDouble(clickableWidth * 0.025, 2, 4),
                  )
                : null,
            boxShadow: alreadyClicked
                ? const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: alreadyClicked
              ? Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: clampDouble(clickableWidth * 0.35, 22, 48),
                  shadows: const [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                      offset: Offset(1, 2),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }

  Widget buildProgressCounter({
    required double screenWidth,
    required double screenHeight,
  }) {
    return Positioned(
      top: clampDouble(screenHeight * 0.02, 12, 22),
      left: clampDouble(screenWidth * 0.03, 10, 18),
      child: IgnorePointer(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: clampDouble(screenWidth * 0.04, 12, 18),
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Text(
            '${clickedDiamonds.length}/$totalDiamonds found',
            style: TextStyle(
              color: Colors.white,
              fontSize: clampDouble(screenWidth * 0.038, 13, 18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHomeButton({
    required double screenWidth,
    required double screenHeight,
  }) {
    final buttonSize = clampDouble(screenWidth * 0.14, 48, 68);

    return Positioned(
      top: clampDouble(screenHeight * 0.02, 12, 22),
      right: clampDouble(screenWidth * 0.03, 10, 18),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) {
                return Lesson2Screen(user: widget.user);
              },
            ),
          );
        },
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromARGB(255, 105, 69, 69),
              width: 4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.home,
            color: Colors.white,
            size: clampDouble(screenWidth * 0.08, 27, 38),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            final scaleByWidth = screenWidth / originalImageWidth;

            final scaleByHeight = screenHeight / originalImageHeight;

            // BoxFit.contain scaling.
            final imageScale = scaleByWidth < scaleByHeight
                ? scaleByWidth
                : scaleByHeight;

            final displayedImageWidth = originalImageWidth * imageScale;

            final displayedImageHeight = originalImageHeight * imageScale;

            final imageOffsetX = (screenWidth - displayedImageWidth) / 2;

            final imageOffsetY = (screenHeight - displayedImageHeight) / 2;

            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: imageOffsetX,
                  top: imageOffsetY,
                  width: displayedImageWidth,
                  height: displayedImageHeight,
                  child: Image.asset(
                    // Use your new five-diamond image here.
                    'assets/lesson-two-day1-act3m.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // Five responsive clickable areas.
                ...diamondPositions.map((DiamondPosition diamond) {
                  return buildClickableDiamond(
                    diamond: diamond,
                    imageScale: imageScale,
                    imageOffsetX: imageOffsetX,
                    imageOffsetY: imageOffsetY,
                  );
                }),

                buildProgressCounter(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),

                buildHomeButton(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DiamondPosition {
  final int id;
  final double x;
  final double y;

  const DiamondPosition({required this.id, required this.x, required this.y});
}
