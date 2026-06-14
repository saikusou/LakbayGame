import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonThreeDayFourActTwo extends StatefulWidget {
  final UserModel user;

  const LessonThreeDayFourActTwo({super.key, required this.user});

  @override
  State<LessonThreeDayFourActTwo> createState() =>
      _LessonThreeDayFourActTwoState();
}

class _LessonThreeDayFourActTwoState extends State<LessonThreeDayFourActTwo> {
  int currentImage = 0;

  final List<String> images = [
    'assets/lesson-three-day4-act2-p1.png',
    'assets/lesson-three-day4-act2-p2.png',
  ];

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

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

  Widget circleButton({
    required IconData icon,
    required Color color,
    required Size size,
    required VoidCallback onTap,
  }) {
    final double buttonSize = clampDouble(size.width * 0.12, 42, 58);
    final double iconSize = clampDouble(size.width * 0.06, 24, 32);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
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
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }

  Widget navButton({
    required String text,
    required VoidCallback onPressed,
    required Size size,
  }) {
    return SizedBox(
      width: clampDouble(size.width * 0.30, 105, 145),
      height: clampDouble(size.height * 0.055, 40, 50),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: clampDouble(size.width * 0.035, 13, 16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double sidePadding = clampDouble(size.width * 0.04, 12, 22);
    final double iconTop = clampDouble(size.height * 0.05, 28, 45);
    final double bottomPadding = clampDouble(size.height * 0.025, 14, 28);

    return Scaffold(
      body: Stack(
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
              size: size,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Lesson3Screen(user: widget.user),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: iconTop + 58,
            right: sidePadding,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${currentImage + 1}/${images.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: bottomPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentImage > 0
                    ? navButton(
                        text: 'Previous',
                        onPressed: previousImage,
                        size: size,
                      )
                    : SizedBox(width: clampDouble(size.width * 0.30, 105, 145)),

                currentImage < images.length - 1
                    ? navButton(text: 'Next', onPressed: nextImage, size: size)
                    : navButton(
                        text: 'Done',
                        size: size,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Lesson3Screen(user: widget.user),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
