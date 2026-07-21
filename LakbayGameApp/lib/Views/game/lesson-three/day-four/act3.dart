import 'package:flutter/material.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LessonThreeDayFourActThree(
        user: UserModel(id: null, userName: '', email: '', gender: ''),
      ),
    );
  }
}

class LessonThreeDayFourActThree extends StatelessWidget {
  final UserModel user;

  const LessonThreeDayFourActThree({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background
          Image.asset('assets/lesson-three-day3-act3act.png', fit: BoxFit.fill),

          // Home button
          Positioned(
            top: clampDouble(size.height * 0.025, 14, 22),
            right: clampDouble(size.width * 0.04, 12, 20),
            child: SafeArea(
              child: _circleButton(
                context: context,
                icon: Icons.home,
                color: Colors.orange,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => Lesson3Screen(user: user),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    final Size size = MediaQuery.sizeOf(context);
    final double buttonSize = clampDouble(size.width * 0.14, 50, 70);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
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
