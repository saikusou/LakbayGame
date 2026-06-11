import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneDayTwoActThreeA extends StatefulWidget {
  final UserModel user;

  const LessonOneDayTwoActThreeA({super.key, required this.user});

  @override
  State<LessonOneDayTwoActThreeA> createState() =>
      _LessonOneDayTwoActThreeAState();
}

class _LessonOneDayTwoActThreeAState extends State<LessonOneDayTwoActThreeA> {
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

  void goToNextPage() {
    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
    );
  }

  void submitAnswers() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            final dialogWidth = clampDouble(w * 0.92, 300, 520);
            final dialogHeight = clampDouble(h * 0.75, 360, 560);

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(12),
              child: SizedBox(
                width: dialogWidth,
                height: dialogHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/lesson-one-day2-act3b.png',
                        fit: BoxFit.fill,
                      ),
                    ),

                    Positioned(
                      top: clampDouble(dialogHeight * 0.025, 8, 15),
                      right: clampDouble(dialogWidth * 0.025, 8, 15),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(dialogContext),
                        child: Container(
                          width: clampDouble(dialogWidth * 0.09, 34, 45),
                          height: clampDouble(dialogWidth * 0.09, 34, 45),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: clampDouble(dialogWidth * 0.06, 22, 30),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: clampDouble(dialogHeight * 0.04, 16, 30),
                      child: ElevatedButton(
                        onPressed: goToNextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                            horizontal: clampDouble(dialogWidth * 0.08, 24, 42),
                            vertical: clampDouble(dialogHeight * 0.018, 9, 14),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Colors.white, width: 3),
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: clampDouble(dialogWidth * 0.04, 14, 18),
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
          } else if (index > 0) {
            focusNodes[index - 1].requestFocus();
          }
        },
        style: TextStyle(
          fontSize: boxSize * 0.60,
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
            borderSide: BorderSide(
              color: Colors.black,
              width: clampDouble(boxSize * 0.07, 1.5, 2.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: Colors.blue,
              width: clampDouble(boxSize * 0.09, 2, 3),
            ),
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
        icon: Icon(icon, color: Colors.white, size: fontSize + 4),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          final horizontalPadding = clampDouble(w * 0.04, 10, 24);
          final availableWidth = w - (horizontalPadding * 2);

          final spacing = clampDouble(w * 0.008, 2, 5);
          final boxSize = clampDouble(
            (availableWidth - (spacing * 18)) / 9,
            24,
            42,
          );

          final buttonWidth = clampDouble(w * 0.34, 110, 160);
          final buttonHeight = clampDouble(h * 0.06, 40, 52);
          final buttonFontSize = clampDouble(w * 0.035, 12, 16);

          final bottomPosition = clampDouble(h * 0.04, 20, 42);
          final homeSize = clampDouble(w * 0.13, 46, 68);

          return SizedBox.expand(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/lesson-one-day2-act3a.png',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 130), // TOP MARGIN
                Positioned(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  bottom: bottomPosition - 35, // move UP
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            9,
                            (index) => Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacing,
                              ),
                              child: inputBox(index, boxSize),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: clampDouble(h * 0.02, 10, 18)),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: clampDouble(w * 0.04, 14, 28),
                        runSpacing: 10,
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
                        size: clampDouble(w * 0.075, 26, 38),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
