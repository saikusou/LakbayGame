import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneDayOneActThree extends StatefulWidget {
  final UserModel user;

  const LessonOneDayOneActThree({super.key, required this.user});

  @override
  State<LessonOneDayOneActThree> createState() =>
      _LessonOneDayOneActThreeState();
}

class _LessonOneDayOneActThreeState extends State<LessonOneDayOneActThree> {
  final List<TextEditingController> controllers = List.generate(
    14,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(14, (_) => FocusNode());

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  void retryAnswers() {
    for (final controller in controllers) {
      controller.clear();
    }

    focusNodes.first.requestFocus();
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
            vertical: clampDouble(size.height * 0.04, 12, 24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/lesson-one-day1-act3a.png',
                fit: BoxFit.contain,
              ),

              Positioned(
                top: clampDouble(size.height * 0.015, 8, 16),
                right: clampDouble(size.width * 0.025, 8, 16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: clampDouble(size.width * 0.11, 34, 45),
                    height: clampDouble(size.width * 0.11, 34, 45),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: clampDouble(size.width * 0.07, 22, 30),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: clampDouble(size.height * 0.035, 18, 32),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: clampDouble(size.width * 0.08, 24, 42),
                      vertical: clampDouble(size.height * 0.015, 9, 14),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.white, width: 3),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: clampDouble(size.width * 0.04, 14, 18),
                    ),
                  ),
                ),
              ),
            ],
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
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.text,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          TextInputFormatter.withFunction((oldValue, newValue) {
            final upperText = newValue.text.toUpperCase();

            return TextEditingValue(
              text: upperText,
              selection: TextSelection.collapsed(offset: upperText.length),
            );
          }),
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < focusNodes.length - 1) {
              focusNodes[index + 1].requestFocus();
            } else {
              focusNodes[index].unfocus();
            }
          } else {
            if (index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          }
        },
        style: TextStyle(
          fontSize: boxSize * 0.72,
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
        icon: Icon(icon, color: Colors.white, size: fontSize + 5),
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

    final double horizontalPadding = clampDouble(w * 0.025, 8, 18);
    final double availableWidth = w - (horizontalPadding * 2);
    final double spacing = clampDouble(w * 0.004, 1.5, 4);

    final double boxSize = clampDouble(
      (availableWidth - (spacing * 28)) / 14,
      20,
      38,
    );

    final double buttonWidth = clampDouble(w * 0.32, 105, 155);
    final double buttonHeight = clampDouble(h * 0.055, 38, 46);
    final double buttonFontSize = clampDouble(w * 0.035, 12, 15);
    final double bottomPosition = clampDouble(h * 0.035, 18, 35);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/lesson-one-day1-act3.png',
                fit: BoxFit.fill,
              ),
            ),

            Positioned(
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: bottomPosition,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        14,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: spacing),
                          child: inputBox(index, boxSize),
                        ),
                      ),
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
                        fontSize: buttonFontSize,
                      ),

                      SizedBox(width: clampDouble(w * 0.04, 14, 28)),

                      actionButton(
                        label: 'Check',
                        icon: Icons.check,
                        color: Colors.green,
                        onPressed: submitAnswers,
                        width: buttonWidth,
                        height: buttonHeight,
                        fontSize: buttonFontSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              top: clampDouble(h * 0.025, 14, 24),
              right: clampDouble(w * 0.04, 12, 22),
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
                  width: clampDouble(w * 0.13, 48, 68),
                  height: clampDouble(w * 0.13, 48, 68),
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
                    size: clampDouble(w * 0.075, 26, 38),
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
