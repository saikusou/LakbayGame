import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Note: Ensure Lesson3Screen is properly exported inside this file
import 'package:lakbay_game/Views/lesson3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LessonThreeDayFourActThree(),
    );
  }
}

class LessonThreeDayFourActThree extends StatefulWidget {
  const LessonThreeDayFourActThree({super.key});

  @override
  State<LessonThreeDayFourActThree> createState() =>
      _LessonThreeDayFourActThreeState();
}

class _LessonThreeDayFourActThreeState
    extends State<LessonThreeDayFourActThree> {
  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIX 1: Defined 'size' so clampDouble has access to screen dimensions
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Prevents the background from shrinking or distorting when the keyboard pops up
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/lesson-three-day4-act3.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Input Field Overlay
          SafeArea(
            child: Padding(
              // Pushes the input area down so it aligns with the blank space below the question
              padding: const EdgeInsets.only(
                top: 280.0,
                left: 45.0,
                right: 45.0,
                bottom: 40.0,
              ),
              child: TextField(
                controller: _answerController,
                maxLines:
                    null, // Allows the text field to grow vertically as you type
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  height: 1.5, // Line height spacing
                ),
                decoration: const InputDecoration(
                  hintText: 'Isulat ang iyong sagot dito...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder
                      .none, // Removes the default rectangular border
                ),
              ),
            ),
          ),

          // 3. Home Button Action Overlay
          Positioned(
            top: clampDouble(size.height * 0.025, 14, 22),
            right: clampDouble(size.width * 0.04, 12, 20),
            child: circleButton(
              icon: Icons.home,
              color: Colors.orange,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Lesson3Screen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // FIX 2: Added the missing circleButton builder method
  Widget circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(
                51,
              ), // 20% opacity matching 2026 specs
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
