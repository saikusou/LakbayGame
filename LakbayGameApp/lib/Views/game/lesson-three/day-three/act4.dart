import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/User/models/user_model.dart';

class LessonThreeDayOneActFour extends StatelessWidget {
  final UserModel user;

  const LessonThreeDayOneActFour({super.key, required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/lesson-three-day3-act4.png',
                fit: BoxFit.fill,
              ),
            ),

            // Home button
            Positioned(
              top: clampDouble(size.height * 0.025, 14, 22),
              right: clampDouble(size.width * 0.04, 12, 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => Lesson3Screen(user: user),
                    ),
                  );
                },
                child: Container(
                  width: clampDouble(size.width * 0.14, 50, 70),
                  height: clampDouble(size.width * 0.14, 50, 70),
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
                    size: clampDouble(size.width * 0.08, 28, 40),
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
