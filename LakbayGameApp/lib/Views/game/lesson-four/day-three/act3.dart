import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson4.dart';
import 'package:lakbay_game/User/models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LessonFourDayThreeActThree(
        user: UserModel(id: null, userName: '', email: '', gender: ''),
      ),
    );
  }
}

class LessonFourDayThreeActThree extends StatefulWidget {
  final UserModel user;

  const LessonFourDayThreeActThree({super.key, required this.user});

  @override
  State<LessonFourDayThreeActThree> createState() =>
      _LessonFourDayThreeActThreeState();
}

class _LessonFourDayThreeActThreeState
    extends State<LessonFourDayThreeActThree> {
  int currentImage = 0;

  final List<String> images = [
    'assets/lesson-four-day3-act3.jpg',
    'assets/lesson-four-day3-act3a.jpg',
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double screenWidth = size.width;
    final double screenHeight = size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(images[currentImage], fit: BoxFit.fill),
          ),

          const SafeArea(child: SizedBox.expand()),

          Positioned(
            top: clampDouble(screenHeight * 0.025, 12, 22),
            right: clampDouble(screenWidth * 0.04, 12, 22),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Lesson4Screen(user: widget.user),
                  ),
                );
              },
              child: Container(
                width: clampDouble(screenWidth * 0.13, 46, 68),
                height: clampDouble(screenWidth * 0.13, 46, 68),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
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
                  size: clampDouble(screenWidth * 0.075, 26, 38),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: clampDouble(screenHeight * 0.035, 18, 38),
            left: clampDouble(screenWidth * 0.06, 18, 35),
            right: clampDouble(screenWidth * 0.06, 18, 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                navButton(
                  text: 'Previous',
                  icon: Icons.arrow_back,
                  enabled: currentImage > 0,
                  onTap: previousImage,
                  screenWidth: screenWidth,
                ),
                navButton(
                  text: 'Next',
                  icon: Icons.arrow_forward,
                  enabled: currentImage < images.length - 1,
                  onTap: nextImage,
                  screenWidth: screenWidth,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget navButton({
    required String text,
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: clampDouble(screenWidth * 0.045, 14, 24),
            vertical: clampDouble(screenWidth * 0.025, 8, 14),
          ),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: clampDouble(screenWidth * 0.04, 14, 18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
