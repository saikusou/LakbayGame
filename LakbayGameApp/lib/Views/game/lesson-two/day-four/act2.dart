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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.12,
        height: size.width * 0.12,
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
        child: Icon(icon, color: Colors.white, size: size.width * 0.065),
      ),
    );
  }

  Widget navButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double sidePadding = size.width * 0.04;
    final double iconTop = size.height * 0.05;

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
                    builder: (_) => Lesson2Screen(user: widget.user),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: iconTop + 55,
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
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentImage > 0
                    ? navButton(text: 'Previous', onPressed: previousImage)
                    : const SizedBox(width: 110),

                currentImage < images.length - 1
                    ? navButton(text: 'Next', onPressed: nextImage)
                    : navButton(
                        text: 'Done',
                        onPressed: () {
                          Navigator.pop(context);
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
