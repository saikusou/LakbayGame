import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneDayTwoActThree extends StatefulWidget {
  final UserModel user;
  const LessonOneDayTwoActThree({super.key, required this.user});

  @override
  State<LessonOneDayTwoActThree> createState() =>
      _LessonOneDayTwoActThreeState();
}

class _LessonOneDayTwoActThreeState extends State<LessonOneDayTwoActThree> {
  // Array of text controllers to handle player input strings
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

  /// SUBMIT MODAL POPUP WITH BACKGROUND IMAGE ONLY (NO BUTTONS)
  void submitAnswers() {
    showDialog(
      context: context,
      barrierDismissible:
          true, // Allowed tapping outside to dismiss since the button is removed
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 12,
          clipBehavior:
              Clip.antiAlias, // Clips background image exactly to border radius
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            width: size.width * 0.92,
            height: size.height * 0.50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/lesson-two-day2-act3-c2.png'),
                fit: BoxFit
                    .fill, // Forces image to completely stretch and fill entire box dimensions
              ),
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
                /// INPUT BOXES ROW
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
                  MaterialPageRoute(
                    builder: (_) => Lesson1Screen(user: widget.user),
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
    );
  }
}
