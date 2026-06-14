import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/Views/lesson2.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneDayFourActThree extends StatefulWidget {
  final UserModel user;

  const LessonOneDayFourActThree({super.key, required this.user});

  @override
  State<LessonOneDayFourActThree> createState() =>
      _LessonOneDayFourActThreeState();
}

class _LessonOneDayFourActThreeState extends State<LessonOneDayFourActThree> {
  int currentImage = 0;

  final List<String> images = [
    'assets/lesson-two-day4-act-3-a.png',
    'assets/lesson-two-day4-act-3-b.png',
    'assets/lesson-two-day4-act-3-c.png',
    'assets/lesson-two-day4-act-3-d.png',
  ];

  void nextImage() {
    if (currentImage < images.length - 1) {
      setState(() {
        currentImage++;
      });
    }
  }

  void previousImage() {
    if (currentImage > 0) {
      setState(() {
        currentImage--;
      });
    }
  }

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
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
    final double iconTop = screenSize.height * 0.05;
    final double homeSize = clampDouble(screenSize.width * 0.12, 42, 70);

    final double buttonFont = clampDouble(screenSize.width * 0.035, 13, 18);
    final double buttonHPadding = clampDouble(screenSize.width * 0.06, 18, 30);
    final double buttonVPadding = clampDouble(
      screenSize.height * 0.012,
      10,
      16,
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(images[currentImage], fit: BoxFit.fill),
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
                      builder: (_) => Lesson1Screen(user: widget.user),
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
              left: 20,
              right: 20,
              bottom: 5,
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
                                    Lesson1Screen(user: widget.user),
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
