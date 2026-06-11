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

  String? answer1;
  String? answer2;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  String? get currentAnswer => currentScenario == 1 ? answer1 : answer2;

  List<Map<String, String>> get currentChoices {
    if (currentScenario == 1) {
      return [
        {'letter': 'A', 'text': 'Pananaw ng may-akda'},
        {'letter': 'B', 'text': 'Austronesyano'},
        {'letter': 'C', 'text': 'Core Population'},
        {'letter': 'D', 'text': 'Kaalamang Bayan'},
      ];
    }

    return [
      {'letter': 'A', 'text': 'Kaalamang Bayan'},
      {'letter': 'B', 'text': 'Austronesyano'},
      {'letter': 'C', 'text': 'Pananaw ng mambabasa'},
      {'letter': 'D', 'text': 'Core Population'},
    ];
  }

  void selectAnswer(String value) {
    setState(() {
      if (currentScenario == 1) {
        answer1 = value;
      } else {
        answer2 = value;
      }
    });
  }

  void nextScenario() {
    if (answer1 == null) return;

    setState(() {
      currentScenario = 2;
    });
  }

  void previousScenario() {
    setState(() {
      currentScenario = 1;
    });
  }

  void submitAnswers() {
    if (answer2 == null) return;

    debugPrint('Picture 1 Answer: $answer1');
    debugPrint('Picture 2 Answer: $answer2');

    showCompletionPopup();
  }

  void showCompletionPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final Size size = MediaQuery.of(context).size;
        final bool shortScreen = size.height < 700;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: clampDouble(size.width * 0.04, 14, 24),
            vertical: clampDouble(size.height * 0.03, 18, 30),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  'assets/lesson-one-day3-act2.png',
                  fit: BoxFit.contain,
                ),
              ),

              Positioned(
                right: 10,
                top: 10,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: clampDouble(size.width * 0.10, 34, 44),
                    height: clampDouble(size.width * 0.10, 34, 44),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: clampDouble(size.width * 0.055, 20, 28),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: shortScreen ? 14 : 22,
                child: SizedBox(
                  width: clampDouble(size.width * 0.34, 120, 170),
                  height: shortScreen ? 38 : 45,
                  child: Button(
                    label: 'OK',
                    press: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Lesson1Screen(user: widget.user),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required Size size,
  }) {
    final double btnSize = clampDouble(size.width * 0.12, 42, 58);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnSize,
        height: btnSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 7,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: clampDouble(btnSize * 0.55, 23, 33),
        ),
      ),
    );
  }

  Widget answerChoice({
    required String letter,
    required String text,
    required Size size,
    required bool shortScreen,
  }) {
    final bool selected = currentAnswer == letter;

    final double choiceWidth = clampDouble(size.width * 0.88, 275, 420);

    final double choiceHeight = shortScreen
        ? clampDouble(size.height * 0.052, 38, 44)
        : clampDouble(size.height * 0.06, 45, 58);

    final double circleSize = shortScreen
        ? clampDouble(size.width * 0.065, 25, 31)
        : clampDouble(size.width * 0.075, 29, 37);

    final double textSize = shortScreen
        ? clampDouble(size.width * 0.034, 12, 15)
        : clampDouble(size.width * 0.04, 14, 18);

    return GestureDetector(
      onTap: () => selectAnswer(letter),
      child: Container(
        width: choiceWidth,
        height: choiceHeight,
        margin: EdgeInsets.only(bottom: shortScreen ? 5 : 8),
        padding: EdgeInsets.symmetric(
          horizontal: clampDouble(size.width * 0.025, 7, 11),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: selected ? Colors.green : Colors.blue,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: selected ? Colors.green : Colors.blue.shade800,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: clampDouble(circleSize * 0.55, 14, 19),
                  ),
                ),
              ),
            ),
            SizedBox(width: clampDouble(size.width * 0.025, 8, 12)),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: textSize,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget choicesPanel({required Size size, required bool shortScreen}) {
    final double titleSize = shortScreen
        ? clampDouble(size.width * 0.034, 11, 14)
        : clampDouble(size.width * 0.038, 12, 16);

    final double buttonWidth = clampDouble(size.width * 0.44, 135, 180);
    final double buttonGap = shortScreen ? 4 : 10;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: clampDouble(size.width * 0.88, 275, 420),
          child: Text(
            'PILIIN ANG TAMANG SAGOT.',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: titleSize,
            ),
          ),
        ),
        SizedBox(height: shortScreen ? 3 : 7),
        Column(
          children: currentChoices.map((choice) {
            return answerChoice(
              letter: choice['letter']!,
              text: choice['text']!,
              size: size,
              shortScreen: shortScreen,
            );
          }).toList(),
        ),
        SizedBox(height: buttonGap),
        SizedBox(
          width: buttonWidth,
          height: shortScreen ? 38 : 45,
          child: currentScenario == 1
              ? Button(label: 'NEXT', press: nextScenario)
              : Button(label: 'ISUMITE', press: submitAnswers),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final Size size = Size(constraints.maxWidth, constraints.maxHeight);

          final bool shortScreen = size.height < 700;

          final String backgroundImage = currentScenario == 1
              ? 'assets/lesson-two-day3-act2a.png'
              : 'assets/lesson-two-day3-act2b.png';

          final double topPadding = MediaQuery.of(context).padding.top;

          final double iconTop =
              topPadding + clampDouble(size.height * 0.012, 6, 14);

          final double sidePadding = clampDouble(size.width * 0.04, 12, 20);

          final double bottomPosition = shortScreen
              ? clampDouble(size.height * 0.025, 12, 20)
              : clampDouble(size.height * 0.05, 30, 55);

          return SizedBox.expand(
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
                  left: 0,
                  right: 0,
                  bottom: bottomPosition,
                  child: choicesPanel(size: size, shortScreen: shortScreen),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
