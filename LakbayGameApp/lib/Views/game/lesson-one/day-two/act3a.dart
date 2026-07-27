import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson1.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonOneDayTwoActThreeA extends StatefulWidget {
  final UserModel user;

  const LessonOneDayTwoActThreeA({super.key, required this.user});

  @override
  State<LessonOneDayTwoActThreeA> createState() =>
      _LessonOneDayTwoActThreeAState();
}

class _LessonOneDayTwoActThreeAState extends State<LessonOneDayTwoActThreeA> {
  static const String correctAnswer = 'EBIDENSYA';
  static const int score = 50;

  bool isSaving = false;

  final List<TextEditingController> controllers = List.generate(
    correctAnswer.length,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(
    correctAnswer.length,
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

  String get userAnswer {
    return controllers.map((c) => c.text.trim().toUpperCase()).join();
  }

  Future<void> handleSavePoints({required int totalScore}) async {
    await ApiService.savePoints(
      userId: widget.user.id,
      countedPoints: totalScore,
      lesson: 'Lesson 1',
      day: 'Day 2',
      act: 'Act 3',
    );
  }

  void retryAnswers() {
    for (final controller in controllers) {
      controller.clear();
    }

    FocusScope.of(context).requestFocus(focusNodes.first);
    setState(() {});
  }

  void goToNextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
    );
  }

  void showImagePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: clampDouble(size.width * 0.04, 12, 24),
            vertical: clampDouble(size.height * 0.04, 12, 24),
          ),
          child: Container(
            width: size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image container
                Container(
                  width: double.infinity,
                  height: size.height * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/lesson-two-day2-act3-c3.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Close button
                      Positioned(
                        top: clampDouble(size.height * 0.015, 8, 16),
                        right: clampDouble(size.width * 0.025, 8, 16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(dialogContext);
                            // Show congratulations after closing image popup
                            showCongratulationsDialog();
                          },
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
                    ],
                  ),
                ),

                // NEXT Button - outside the image
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: clampDouble(size.height * 0.02, 12, 20),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        // Show congratulations after closing image popup
                        showCongratulationsDialog();
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
                        'NEXT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: clampDouble(size.width * 0.04, 14, 18),
                        ),
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

  void showCongratulationsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 90,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Congratulations!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tamang Sagot!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: const Text(
                        'Score: 50',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                              setDialogState(() {
                                isSaving = true;
                              });

                              try {
                                await handleSavePoints(totalScore: score);

                                if (!mounted) return;

                                Navigator.pop(dialogContext);
                                goToNextPage();
                              } catch (e) {
                                if (!mounted) return;

                                setDialogState(() {
                                  isSaving = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Hindi na-save ang score: $e',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 42,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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

  void submitAnswers() {
    if (userAnswer != correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Maling sagot! Subukan muli.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show image popup first
    showImagePopup();
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
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            } else {
              focusNodes[index].unfocus();
            }
          } else if (index > 0) {
            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
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
            (availableWidth - (spacing * 18)) / correctAnswer.length,
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
                Positioned(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  bottom: bottomPosition - 35,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            correctAnswer.length,
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
