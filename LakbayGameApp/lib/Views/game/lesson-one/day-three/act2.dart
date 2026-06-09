import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneDayThreeActTwo extends StatefulWidget {
  final UserModel user;

  const LessonOneDayThreeActTwo({super.key, required this.user});

  @override
  State<LessonOneDayThreeActTwo> createState() =>
      _LessonOneDayThreeActTwoState();
}

class _LessonOneDayThreeActTwoState extends State<LessonOneDayThreeActTwo> {
  int currentScenario = 1;

  final TextEditingController answer1Controller = TextEditingController();
  final TextEditingController answer2Controller = TextEditingController();

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  void dispose() {
    answer1Controller.dispose();
    answer2Controller.dispose();
    super.dispose();
  }

  Widget circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required Size size,
  }) {
    final double btnSize = clampDouble(size.width * 0.13, 48, 65);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnSize,
        height: btnSize,
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
          size: clampDouble(btnSize * 0.55, 26, 38),
        ),
      ),
    );
  }

  Widget answerInput({
    required TextEditingController controller,
    required String hintText,
    required Size size,
  }) {
    return Container(
      width: clampDouble(size.width * 0.80, 270, 390),
      height: clampDouble(size.height * 0.075, 52, 64),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        textInputAction: currentScenario == 1
            ? TextInputAction.next
            : TextInputAction.done,
        style: TextStyle(
          fontSize: clampDouble(size.width * 0.055, 18, 23),
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: clampDouble(size.width * 0.045, 15, 19),
            fontWeight: FontWeight.bold,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: clampDouble(size.height * 0.018, 10, 16),
          ),
        ),
      ),
    );
  }

  void nextScenario() {
    FocusScope.of(context).unfocus();
    setState(() {
      currentScenario = 2;
    });
  }

  void previousScenario() {
    FocusScope.of(context).unfocus();
    setState(() {
      currentScenario = 1;
    });
  }

  void submitAnswers() {
    FocusScope.of(context).unfocus();

    debugPrint('Picture 1 Answer: ${answer1Controller.text}');
    debugPrint('Picture 2 Answer: ${answer2Controller.text}');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final String backgroundImage = currentScenario == 1
        ? 'assets/lesson-two-day3-act2a.png'
        : 'assets/lesson-two-day3-act2b.png';

    final double topPadding = MediaQuery.of(context).padding.top;
    final double iconTop = topPadding + clampDouble(size.height * 0.015, 8, 16);
    final double sidePadding = clampDouble(size.width * 0.04, 12, 22);

    final double answerTop = keyboardHeight > 0
        ? clampDouble(size.height * 0.53, 330, 430)
        : clampDouble(size.height * 0.70, 460, 610);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(backgroundImage, fit: BoxFit.fill),
            ),

            if (currentScenario == 2)
              Positioned(
                top: iconTop,
                left: sidePadding,
                child: circleButton(
                  icon: Icons.arrow_back,
                  color: Colors.blue,
                  size: size,
                  onTap: previousScenario,
                ),
              ),

            Positioned(
              top: iconTop,
              right: sidePadding,
              child: circleButton(
                icon: Icons.home,
                color: Colors.orange,
                size: size,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Lesson1Screen(user: widget.user),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              top: answerTop,
              left: 0,
              right: 0,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: keyboardHeight > 0 ? keyboardHeight * 0.25 : 0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IndexedStack(
                      index: currentScenario - 1,
                      children: [
                        answerInput(
                          controller: answer1Controller,
                          hintText: 'Sagot sa larawan 1',
                          size: size,
                        ),
                        answerInput(
                          controller: answer2Controller,
                          hintText: 'Sagot sa larawan 2',
                          size: size,
                        ),
                      ],
                    ),

                    SizedBox(height: clampDouble(size.height * 0.025, 14, 22)),

                    SizedBox(
                      width: clampDouble(size.width * 0.45, 140, 190),
                      child: currentScenario == 1
                          ? Button(label: 'NEXT', press: nextScenario)
                          : Button(label: 'SUBMIT', press: submitAnswers),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
