import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneDayThreeActThree extends StatefulWidget {
  final UserModel user;

  const LessonOneDayThreeActThree({super.key, required this.user});

  @override
  State<LessonOneDayThreeActThree> createState() =>
      _LessonOneDayThreeActThreeState();
}

class _LessonOneDayThreeActThreeState extends State<LessonOneDayThreeActThree> {
  int currentRound = 1;

  int? answer1;
  int? answer2;
  int? answer3;

  final List<String> images = [
    'assets/lesson-one-day3-act3a.png',
    'assets/lesson-one-day3-act3b.png',
    'assets/lesson-one-day3-act3c.png',
  ];

  double clampDouble(double value, double min, double max) {
    final double low = min < max ? min : max;
    final double high = min < max ? max : min;
    return value.clamp(low, high).toDouble();
  }

  String get currentImage => images[currentRound - 1];

  int? get currentAnswer {
    if (currentRound == 1) return answer1;
    if (currentRound == 2) return answer2;
    return answer3;
  }

  void setCurrentAnswer(int value) {
    setState(() {
      if (currentRound == 1) {
        answer1 = value;
      } else if (currentRound == 2) {
        answer2 = value;
      } else {
        answer3 = value;
      }
    });
  }

  void nextRound() {
    if (currentRound < 3) {
      setState(() => currentRound++);
    } else {
      showResultPopup();
    }
  }

  void backRound() {
    if (currentRound > 1) {
      setState(() => currentRound--);
    } else {
      Navigator.pop(context);
    }
  }

  void goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
    );
  }

  int getScore() {
    int score = 0;
    if (answer1 == 1) score++;
    if (answer2 == 0) score++;
    if (answer3 == 0) score++;
    return score;
  }

  void showResultPopup() {
    final int score = getScore();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final size = MediaQuery.of(context).size;
        final popupWidth = clampDouble(size.width * 0.82, 260, 360);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(18),
          child: Container(
            width: popupWidth,
            padding: EdgeInsets.all(clampDouble(size.width * 0.045, 14, 20)),
            decoration: BoxDecoration(
              color: const Color(0xfffff1b8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xff8b4b12), width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tapos Na!',
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.065, 22, 28),
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff5a310b),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tamang Sagot: $score / 3',
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.048, 17, 22),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff5a310b),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: 130,
                  child: bottomButton('OK', 14, () {
                    Navigator.pop(context);
                    goHome();
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget circleButton({
    required IconData icon,
    required double size,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xff8b4b12),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xffffc24b), width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      ),
    );
  }

  Widget choiceButton({
    required String text,
    required int index,
    required int? groupValue,
    required Function(int) onChanged,
    required double fontSize,
    required bool compact,
  }) {
    final bool selected = groupValue == index;

    return InkWell(
      onTap: () => onChanged(index),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: compact ? double.infinity : null,
        margin: EdgeInsets.symmetric(
          horizontal: compact ? 0 : 4,
          vertical: compact ? 3 : 0,
        ),
        padding: EdgeInsets.symmetric(
          vertical: clampDouble(fontSize * 0.75, 7, 11),
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xffffdf7e) : const Color(0xfffff6cf),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xffc28a2c), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: fontSize + 5,
              color: const Color(0xff7a4b10),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                text.replaceAll('\n', ' '),
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff4b2a08),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget questionCard({
    required int number,
    required String question,
    required List<String> choices,
    required int? groupValue,
    required Function(int) onChanged,
    required double width,
  }) {
    final bool compact = width < 390;
    final double questionFont = clampDouble(width * 0.042, 14, 20);
    final double choiceFont = clampDouble(width * 0.032, 11, 15);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(clampDouble(width * 0.03, 10, 18)),
      decoration: BoxDecoration(
        color: const Color(0xffffeaa5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffa96c19), width: 2.5),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(1, 3)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number. ',
                style: TextStyle(
                  fontSize: questionFont,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff3d2408),
                ),
              ),
              Expanded(
                child: Text(
                  question,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: questionFont,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff3d2408),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: clampDouble(width * 0.022, 8, 13)),
          compact
              ? Column(
                  children: List.generate(
                    choices.length,
                    (index) => choiceButton(
                      text: choices[index],
                      index: index,
                      groupValue: groupValue,
                      onChanged: onChanged,
                      fontSize: choiceFont,
                      compact: true,
                    ),
                  ),
                )
              : Row(
                  children: List.generate(
                    choices.length,
                    (index) => Expanded(
                      child: choiceButton(
                        text: choices[index],
                        index: index,
                        groupValue: groupValue,
                        onChanged: onChanged,
                        fontSize: choiceFont,
                        compact: false,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget currentQuestionCard(double screenW) {
    if (currentRound == 1) {
      return questionCard(
        number: 1,
        question: 'Ano ang ipinapakita ng mapa?',
        choices: const [
          'Mga hayop sa Pilipinas',
          'Ruta ng paglalakbay',
          'Mga ninuno ng Pilipino',
          'Uri ng pagkain noon',
        ],
        groupValue: answer1,
        onChanged: setCurrentAnswer,
        width: screenW,
      );
    }

    if (currentRound == 2) {
      return questionCard(
        number: 2,
        question: 'Ano ang ginamit sa paglalakbay?',
        choices: const ['Bangka', 'Kotse', 'Tren', 'Bisikleta'],
        groupValue: answer2,
        onChanged: setCurrentAnswer,
        width: screenW,
      );
    }

    return questionCard(
      number: 3,
      question: 'Sino ang tinutukoy sa aralin?',
      choices: const [
        'Mga ninuno',
        'Mga turista',
        'Mga sundalo',
        'Mga mangangalakal',
      ],
      groupValue: answer3,
      onChanged: setCurrentAnswer,
      width: screenW,
    );
  }

  Widget bottomButton(String text, double fontSize, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: clampDouble(fontSize * 3.6, 40, 50),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xff8b4b12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffffb33b), width: 2),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenW = constraints.maxWidth;
          final double screenH = constraints.maxHeight;

          final bool smallHeight = screenH < 700;

          final double horizontalPadding = clampDouble(screenW * 0.035, 10, 18);
          final double topButtonSize = clampDouble(screenW * 0.095, 34, 46);
          final double bottomFont = clampDouble(screenW * 0.033, 11, 15);

          final double bottomCardPadding = smallHeight ? 10 : 20;
          final double maxCardHeight = screenH * (smallHeight ? 0.40 : 0.36);

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(currentImage, fit: BoxFit.fill),
              ),

              SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: clampDouble(screenH * 0.015, 8, 16),
                      left: horizontalPadding,
                      child: circleButton(
                        icon: Icons.arrow_back,
                        size: topButtonSize,
                        onTap: backRound,
                      ),
                    ),

                    Positioned(
                      top: clampDouble(screenH * 0.015, 8, 16),
                      right: horizontalPadding,
                      child: circleButton(
                        icon: Icons.home,
                        size: topButtonSize,
                        onTap: goHome,
                      ),
                    ),

                    Positioned(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: bottomCardPadding,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: maxCardHeight),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              currentQuestionCard(screenW),

                              SizedBox(
                                height: clampDouble(screenH * 0.014, 7, 14),
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: bottomButton(
                                      'BABALIK',
                                      bottomFont,
                                      backRound,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: bottomButton(
                                      'Round $currentRound / 3',
                                      bottomFont,
                                      () {},
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: bottomButton(
                                      currentRound == 3 ? 'SUBMIT' : 'SUSUNOD',
                                      bottomFont,
                                      nextRound,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
