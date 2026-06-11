import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneDayThreeActFive extends StatelessWidget {
  final UserModel user;

  const LessonOneDayThreeActFive({super.key, required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
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
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final double sidePadding = clampDouble(screenSize.width * 0.04, 12, 24);
    final double iconTop = clampDouble(screenSize.height * 0.035, 20, 40);
    final double buttonSize = clampDouble(screenSize.width * 0.12, 42, 58);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/lesson-one-day3-act5.png',
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
            top: iconTop,
            right: sidePadding,
            child: circleButton(
              icon: Icons.home,
              color: Colors.orange,
              size: buttonSize,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Lesson1Screen(user: user)),
                );
              },
            ),
          ),

          const SafeArea(child: SizedBox.expand()),
        ],
      ),
    );
  }
}
