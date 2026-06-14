import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson2.dart';
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
      home: LessonOneDayFourActFour(
        user: UserModel(id: null, userName: '', email: '', gender: ''),
      ),
    );
  }
}

class LessonOneDayFourActFour extends StatefulWidget {
  final UserModel user;

  const LessonOneDayFourActFour({super.key, required this.user});

  @override
  State<LessonOneDayFourActFour> createState() =>
      _LessonOneDayFourActFourState();
}

class _LessonOneDayFourActFourState extends State<LessonOneDayFourActFour> {
  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
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
            child: Image.asset(
              'assets/lesson-one-day4-act-4.png',
              fit: BoxFit.fill,
            ),
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
                    builder: (_) => Lesson2Screen(user: widget.user),
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
        ],
      ),
    );
  }
}
