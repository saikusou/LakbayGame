import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonOneDayOneActThreeA extends StatefulWidget {
  final UserModel user;

  const LessonOneDayOneActThreeA({super.key, required this.user});

  @override
  State<LessonOneDayOneActThreeA> createState() =>
      _LessonOneDayOneActThreeAState();
}

class _LessonOneDayOneActThreeAState extends State<LessonOneDayOneActThreeA> {
  static const String correctAnswer = 'AUSTRONESYANO';
  static const int answerLength = correctAnswer.length;

  final List<TextEditingController> controllers = List.generate(
    answerLength,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(
    answerLength,
    (_) => FocusNode(),
  );

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

  String getTypedAnswer() {
    return controllers.map((c) => c.text.trim().toUpperCase()).join();
  }

  void retryAnswers() {
    for (final controller in controllers) {
      controller.clear();
    }

    FocusScope.of(context).requestFocus(focusNodes.first);
    setState(() {});
  }

  void goToNextPage() {
    Navigator.pop(context);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      showCongratulationsPopup();
    });
  }

  Future<void> handleSavePoints({required int totalScore}) async {
    await ApiService.savePoints(
      userId: widget.user.id,
      countedPoints: totalScore,
      lesson: 'Lesson 1',
      day: 'Day 1',
      act: 'Act 3',
    );
  }

  void showCongratulationsPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;
        final w = size.width;
        final h = size.height;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: clampDouble(w * 0.08, 20, 36),
            vertical: clampDouble(h * 0.05, 20, 36),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: clampDouble(w * 0.06, 18, 30),
              vertical: clampDouble(h * 0.035, 20, 34),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.green, width: 5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: clampDouble(w * 0.24, 80, 110),
                  height: clampDouble(w * 0.24, 80, 110),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.yellow, width: 5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: Colors.yellow,
                    size: clampDouble(w * 0.14, 48, 70),
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'Congratulations!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(w * 0.07, 25, 34),
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'You got 50 points!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(w * 0.052, 18, 25),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Lesson1Screen(user: widget.user),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: clampDouble(w * 0.055, 20, 26),
                  ),
                  label: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: clampDouble(w * 0.045, 15, 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: clampDouble(w * 0.09, 30, 48),
                      vertical: clampDouble(h * 0.017, 11, 16),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: const BorderSide(color: Colors.white, width: 3),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void submitAnswers() {
    final typedAnswer = getTypedAnswer();

    if (typedAnswer != correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Maling sagot. Subukan ulit.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: clampDouble(size.width * 0.04, 12, 24),
            vertical: clampDouble(size.height * 0.04, 12, 24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/lesson-one-day1-act32.png', fit: BoxFit.fill),

              Positioned(
                top: clampDouble(size.height * 0.015, 8, 16),
                right: clampDouble(size.width * 0.025, 8, 16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(dialogContext),
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
                  onPressed: () async {
                    final score = 50;

                    await handleSavePoints(totalScore: score);

                    goToNextPage();
                  },
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
                    'Done',
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
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
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
      (availableWidth - (spacing * answerLength * 2)) / answerLength,
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
                'assets/lesson-one-day1-act31.png',
                fit: BoxFit.fill,
              ),
            ),

            Positioned(
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: bottomPosition - 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        answerLength,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: spacing),
                          child: inputBox(index, boxSize),
                        ),
                      ),
                    ),
                  ),

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
