import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson2.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonTwoDayFourActTwo extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayFourActTwo({super.key, required this.user});

  @override
  State<LessonTwoDayFourActTwo> createState() => _LessonTwoDayFourActTwoState();
}

class _LessonTwoDayFourActTwoState extends State<LessonTwoDayFourActTwo> {
  int currentImage = 0;

  final List<String> images = [
    'assets/lesson-two-act2-img1.png',
    'assets/lesson-two-act2-img2.png',
    'assets/lesson-two-act2-img3.png',
    'assets/lesson-two-act2-img4.png',
    'assets/lesson-two-act2-img5.png',
    'assets/lesson-two-act2-img6.png',
    'assets/lesson-two-act2-img7.png',
    'assets/lesson-two-act2-img8.png',
  ];

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void nextImage() {
    if (currentImage < images.length - 1) {
      setState(() => currentImage++);
    }
  }

  void previousImage() {
    if (currentImage > 0) {
      setState(() => currentImage--);
    }
  }

  Widget circleButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      ),
    );
  }

  Widget navButton({
    required String text,
    required VoidCallback onPressed,
    required double fontSize,
    required double horizontalPadding,
    required double verticalPadding,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double sidePadding = screenSize.width * 0.04;
    final double iconTop = screenSize.height * 0.03;
    final double homeSize = clampDouble(screenSize.width * 0.11, 38, 58);

    final double buttonFont = clampDouble(screenSize.width * 0.035, 12, 17);
    final double buttonHPadding = clampDouble(screenSize.width * 0.055, 16, 28);
    final double buttonVPadding = clampDouble(screenSize.height * 0.01, 8, 14);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                images[currentImage],
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'Image not found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              top: iconTop,
              right: sidePadding,
              child: circleButton(
                icon: Icons.home,
                color: Colors.orange,
                size: homeSize,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Lesson2Screen(user: widget.user),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              top: iconTop + homeSize + 8,
              right: sidePadding,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${currentImage + 1}/${images.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: buttonFont,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 16,
              right: 16,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentImage > 0
                      ? navButton(
                          text: 'Previous',
                          onPressed: previousImage,
                          fontSize: buttonFont,
                          horizontalPadding: buttonHPadding,
                          verticalPadding: buttonVPadding,
                        )
                      : SizedBox(
                          width: clampDouble(screenSize.width * 0.28, 90, 130),
                        ),

                  currentImage < images.length - 1
                      ? navButton(
                          text: 'Next',
                          onPressed: nextImage,
                          fontSize: buttonFont,
                          horizontalPadding: buttonHPadding,
                          verticalPadding: buttonVPadding,
                        )
                      : navButton(
                          text: 'Done',
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    Lesson2Screen(user: widget.user),
                              ),
                            );
                          },
                          fontSize: buttonFont,
                          horizontalPadding: buttonHPadding,
                          verticalPadding: buttonVPadding,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
