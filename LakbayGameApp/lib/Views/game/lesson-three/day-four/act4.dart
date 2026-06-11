import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LessonThreeDayFourActThree1(
        user: UserModel(id: null, userName: '', email: '', gender: ''),
      ),
    );
  }
}

class LessonThreeDayFourActThree1 extends StatelessWidget {
  final UserModel user;

  const LessonThreeDayFourActThree1({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/lesson-three-day4-act3.png',
                fit: BoxFit.fill,
              ),
            ),

            // HOME BUTTON
            Positioned(
              top: clampDouble(size.height * 0.025, 14, 22),
              right: clampDouble(size.width * 0.04, 12, 20),
              child: circleButton(
                context: context,
                icon: Icons.home,
                color: Colors.orange,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Lesson3Screen(user: user),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget circleButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: clampDouble(size.width * 0.14, 50, 70),
        height: clampDouble(size.width * 0.14, 50, 70),
        decoration: BoxDecoration(
          color: color,
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
          icon,
          color: Colors.white,
          size: clampDouble(size.width * 0.08, 28, 40),
        ),
      ),
    );
  }
}
