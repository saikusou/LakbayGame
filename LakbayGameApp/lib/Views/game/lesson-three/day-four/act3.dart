import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    // Get device dimensions
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // 1. Fully Responsive Background
            SizedBox(
              width: size.width,
              height: size.height,
              child: Image.asset(
                'assets/lesson-three-day4-act3.png',
                // BoxFit.fill forces the template to match the target device screen dimensions precisely.
                // Alternatively, use BoxFit.fitWidth if you want to retain exact original asset ratios.
                fit: BoxFit.fill,
              ),
            ),

            // 2. Responsive Input Field Overlay
            SafeArea(
              child: Padding(
                // Using percentage multipliers based on screen height/width ensures the input
                // area scales down proportionally on small phones and up on larger displays.
                padding: EdgeInsets.only(
                  top:
                      size.height *
                      0.35, // Dynamically starts about 35% down the screen
                  left: size.width * 0.12, // 12% padding left
                  right: size.width * 0.12, // 12% padding right
                  bottom: size.height * 0.05,
                ),
                child: TextField(
                  controller: _answerController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    // Calculates text size dynamically so text scales smoothly across devices
                    fontSize: clampDouble(size.width * 0.045, 16.0, 22.0),
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Isulat ang iyong sagot dito...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    border: InputBorder.none,
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
      ),
    );
  }

  Widget circleButton({
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
