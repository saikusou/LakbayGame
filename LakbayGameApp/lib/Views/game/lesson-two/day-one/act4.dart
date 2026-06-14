import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson2.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonTwoDayOneActFour extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayOneActFour({super.key, required this.user});

  @override
  State<LessonTwoDayOneActFour> createState() => _LessonTwoDayOneActFourState();
}

class _LessonTwoDayOneActFourState extends State<LessonTwoDayOneActFour> {
  int currentPage = 0;

  final List<String> images = [
    'assets/lesson-two-day1-act4a.png',
    'assets/lesson-two-day1-act4b.png',
    'assets/lesson-two-day1-act4c.png',
  ];

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void nextPage() {
    if (currentPage < images.length - 1) {
      setState(() {
        currentPage++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Lesson2Screen(user: widget.user)),
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  Widget circleButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      ),
    );
  }

  Widget bottomButton({
    required String text,
    required double width,
    required double height,
    required double fontSize,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          elevation: 5,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double sidePadding = clampDouble(screenSize.width * 0.04, 12, 24);
    final double iconTop = clampDouble(screenSize.height * 0.035, 20, 40);
    final double homeButtonSize = clampDouble(screenSize.width * 0.11, 38, 54);

    final double bottomButtonWidth = clampDouble(
      screenSize.width * 0.28,
      95,
      135,
    );

    final double bottomButtonHeight = clampDouble(
      screenSize.height * 0.048,
      35,
      45,
    );

    final double bottomButtonFontSize = clampDouble(
      screenSize.width * 0.028,
      11,
      14,
    );

    final double bottomSpacing = clampDouble(screenSize.height * 0.025, 14, 24);

    final double buttonGap = clampDouble(screenSize.width * 0.03, 10, 20);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(images[currentPage], fit: BoxFit.fill),
          ),

          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: iconTop,
                  right: sidePadding,
                  child: circleButton(
                    icon: Icons.home,
                    color: Colors.orange,
                    size: homeButtonSize,
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
                  bottom: bottomSpacing,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentPage > 0)
                        bottomButton(
                          text: 'PREVIOUS',
                          width: bottomButtonWidth,
                          height: bottomButtonHeight,
                          fontSize: bottomButtonFontSize,
                          onTap: previousPage,
                        ),

                      if (currentPage > 0) SizedBox(width: buttonGap),

                      bottomButton(
                        text: currentPage == images.length - 1
                            ? 'DONE'
                            : 'NEXT',
                        width: bottomButtonWidth,
                        height: bottomButtonHeight,
                        fontSize: bottomButtonFontSize,
                        onTap: nextPage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
