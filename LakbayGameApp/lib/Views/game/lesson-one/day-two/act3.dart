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
  final List<TextEditingController> controllers = List.generate(
    14,
    (_) => TextEditingController(),
  );

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void retryAnswers() {
    for (final controller in controllers) {
      controller.clear();
    }
    setState(() {});
  }

  void submitAnswers() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final size = MediaQuery.of(context).size;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: clampDouble(size.width * 0.04, 12, 24),
            vertical: clampDouble(size.height * 0.03, 16, 28),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              clampDouble(size.width * 0.06, 18, 30),
            ),
            child: SizedBox(
              width: clampDouble(size.width * 0.92, 280, 520),
              height: clampDouble(size.height * 0.50, 260, 430),
              child: Image.asset(
                'assets/lesson-two-day2-act3-c2.png',
                fit: BoxFit.fill,
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
        textCapitalization: TextCapitalization.characters,
        style: TextStyle(
          fontSize: boxSize * 0.65,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.blue, width: 3),
          ),
        ),
      ),
    );
  }

  Widget actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required double width,
    required double height,
    required double fontSize,
    required double iconSize,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Colors.white, width: 3),
        ),
        icon: Icon(icon, color: Colors.white, size: iconSize),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final double boxSize = clampDouble(w * 0.14, 28, 45);
    final double spacing = clampDouble(w * 0.008, 2, 6);

    final double buttonWidth = clampDouble(w * 0.33, 120, 165);
    final double buttonHeight = clampDouble(h * 0.065, 42, 55);
    final double buttonFont = clampDouble(w * 0.038, 13, 16);
    final double buttonIcon = clampDouble(w * 0.055, 18, 24);

    final double homeSize = clampDouble(w * 0.14, 48, 70);
    final double homeIcon = clampDouble(w * 0.08, 26, 40);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/lesson-two-day2-act3-c1.png',
                  fit: BoxFit.fill,
                ),
              ),

              Positioned(
                left: w * 0.03,
                right: w * 0.03,
                bottom: clampDouble(h * 0.000, 0, 20),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: spacing,
                        runSpacing: spacing,
                        children: List.generate(
                          5,
                          (index) => inputBox(index, boxSize),
                        ),
                      ),

                      SizedBox(height: clampDouble(h * 0.018, 10, 18)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          actionButton(
                            label: 'Retry',
                            icon: Icons.refresh,
                            color: Colors.red,
                            onPressed: retryAnswers,
                            width: buttonWidth,
                            height: buttonHeight,
                            fontSize: buttonFont,
                            iconSize: buttonIcon,
                          ),
                          SizedBox(width: clampDouble(w * 0.04, 12, 22)),
                          actionButton(
                            label: 'Submit',
                            icon: Icons.check,
                            color: Colors.green,
                            onPressed: submitAnswers,
                            width: buttonWidth,
                            height: buttonHeight,
                            fontSize: buttonFont,
                            iconSize: buttonIcon,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: clampDouble(h * 0.025, 14, 24),
                right: clampDouble(w * 0.04, 12, 22),
                child: SafeArea(
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
                      width: homeSize,
                      height: homeSize,
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
                        size: homeIcon,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
