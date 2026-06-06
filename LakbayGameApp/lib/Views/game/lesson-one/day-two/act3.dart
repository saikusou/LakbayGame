import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';

class LessonOneDayTwoActThree extends StatefulWidget {
  const LessonOneDayTwoActThree({super.key});

  @override
  State<LessonOneDayTwoActThree> createState() =>
      _LessonOneDayTwoActThreeState();
}

class _LessonOneDayTwoActThreeState extends State<LessonOneDayTwoActThree> {
  final List<TextEditingController> controllers = List.generate(
    14,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void retryAnswers() {
    for (final controller in controllers) {
      controller.clear();
    }
    setState(() {});
  }

  /// MODAL POPUP ON SUBMIT
  void submitAnswers() {
    final answer = controllers.map((controller) => controller.text).join();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Header
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 30,
                  child: Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Activity Submitted!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // Content / Answer Summary
                Text(
                  'Your Answer: $answer',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // Close / Action Button
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Awesome!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget inputBox(int index, double boxSize) {
    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: TextField(
        controller: controllers[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: boxSize * 0.85,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.blue, width: 3),
          ),
        ),
        textCapitalization: TextCapitalization.characters,
      ),
    );
  }

  Widget actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required double width,
  }) {
    return SizedBox(
      width: width,
      height: 45,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Colors.white, width: 3),
        ),
        icon: Icon(icon, color: Colors.white, size: 22),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double boxSize = clampDouble(size.width * 0.155, 24, 38);
    final double spacing = clampDouble(size.width * 0.006, 2, 5);
    final double buttonWidth = clampDouble(size.width * 0.32, 115, 155);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/lesson-two-day2-act3-c1.png',
              fit: BoxFit.fill,
            ),
          ),

          /// INPUT BOXES AND BUTTONS
          Positioned(
            left: size.width * 0.03,
            right: size.width * 0.03,
            bottom: size.height * 0.03,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 14 INPUT BOXES (Note: Currently set to 5 items in the row generator)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing),
                      child: inputBox(index, boxSize),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.018),

                /// RETRY AND SUBMIT BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    actionButton(
                      label: 'Retry',
                      icon: Icons.refresh,
                      color: Colors.red,
                      onPressed: retryAnswers,
                      width: buttonWidth,
                    ),
                    SizedBox(width: size.width * 0.04),
                    actionButton(
                      label: 'Submit',
                      icon: Icons.check,
                      color: Colors.green,
                      onPressed: submitAnswers,
                      width: buttonWidth,
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// HOME BUTTON
          Positioned(
            top: clampDouble(size.height * 0.025, 14, 22),
            right: clampDouble(size.width * 0.04, 12, 20),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Lesson1Screen()),
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
    );
  }
}
