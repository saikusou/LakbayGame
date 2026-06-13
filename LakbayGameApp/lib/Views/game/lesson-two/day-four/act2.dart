import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(images[currentImage], fit: BoxFit.fill),
          ),

          /// Page Indicator
          Positioned(
            top: 50,
            right: 20,
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

          /// Floating Bottom Buttons
          Positioned(
            left: 20,
            right: 20,
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentImage > 0
                    ? ElevatedButton(
                        onPressed: previousImage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Previous'),
                      )
                    : const SizedBox(width: 110),

                currentImage < images.length - 1
                    ? ElevatedButton(
                        onPressed: nextImage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Next'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Done'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
