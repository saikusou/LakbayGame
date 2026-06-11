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

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  String get currentImage {
    if (currentRound == 1) return 'assets/lesson-one-day3-act3a.png';
    if (currentRound == 2) return 'assets/lesson-one-day3-act3b.png';
    return 'assets/lesson-one-day3-act3c.png';
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
      Navigator.pop(context);
    }
  }

  void backRound() {
    if (currentRound > 1) {
      setState(() => currentRound--);
    } else {
      Navigator.pop(context);
    }
  }

  Widget topButton({
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
  }) {
    final bool selected = groupValue == index;

    return Expanded(
      child: InkWell(
        onTap: () => onChanged(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: EdgeInsets.symmetric(
            vertical: clampDouble(fontSize * 0.7, 5, 8),
            horizontal: 4,
          ),
          decoration: BoxDecoration(
            color: selected ? const Color(0xffffdf7e) : const Color(0xfffff6cf),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xffc28a2c), width: 1.4),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: fontSize + 4,
                color: const Color(0xff7a4b10),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  Widget questionCard({
    required int number,
    required IconData icon,
    required String question,
    required List<String> choices,
    required int? groupValue,
    required Function(int) onChanged,
    required double width,
  }) {
    final double choiceFont = clampDouble(width * 0.026, 8, 12);
    final double questionFont = clampDouble(width * 0.034, 12, 16);

    return Container(
      padding: EdgeInsets.all(clampDouble(width * 0.018, 7, 12)),
      decoration: BoxDecoration(
        color: const Color(0xffffeaa5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffa96c19), width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(1, 2)),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: clampDouble(width * 0.13, 45, 70),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: clampDouble(width * 0.032, 11, 16),
                  backgroundColor: const Color(0xff8b4b12),
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: clampDouble(width * 0.01, 3, 6)),
                Icon(icon, size: clampDouble(width * 0.08, 28, 44)),
              ],
            ),
          ),
          SizedBox(width: clampDouble(width * 0.015, 5, 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: questionFont,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3d2408),
                  ),
                ),
                SizedBox(height: clampDouble(width * 0.015, 5, 9)),
                Row(
                  children: List.generate(
                    choices.length,
                    (index) => choiceButton(
                      text: choices[index],
                      index: index,
                      groupValue: groupValue,
                      onChanged: onChanged,
                      fontSize: choiceFont,
                    ),
                  ),
                ),
              ],
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
        icon: Icons.landscape,
        question: 'Ano ang ipinapakita ng mapa?',
        choices: const [
          'Mga hayop\nsa Pilipinas',
          'Ruta ng\npaglalakbay',
          'Mga ninuno\nng Pilipino',
          'Uri ng\npagkain noon',
        ],
        groupValue: answer1,
        onChanged: setCurrentAnswer,
        width: screenW,
      );
    }

    if (currentRound == 2) {
      return questionCard(
        number: 2,
        icon: Icons.directions_boat,
        question: 'Ano ang ginamit sa paglalakbay?',
        choices: const ['Bangka', 'Kotse', 'Tren', 'Bisikleta'],
        groupValue: answer2,
        onChanged: setCurrentAnswer,
        width: screenW,
      );
    }

    return questionCard(
      number: 3,
      icon: Icons.groups,
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
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: clampDouble(fontSize * 3.3, 34, 42),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xff8b4b12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xffffb33b), width: 2),
        ),
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
    );
  }

  void goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenW = constraints.maxWidth;
          final double screenH = constraints.maxHeight;

          const double designW = 430;
          final double scale = (screenW / designW).clamp(0.75, 1.25);

          final double horizontalPadding = clampDouble(screenW * 0.025, 8, 14);
          final double topButtonSize = clampDouble(screenW * 0.09, 34, 45);
          final double cardTop = screenH * 0.69;
          final double bottomFont = clampDouble(screenW * 0.03, 10, 12);

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
                      child: topButton(
                        icon: Icons.arrow_back,
                        size: topButtonSize,
                        onTap: backRound,
                      ),
                    ),

                    Positioned(
                      top: clampDouble(screenH * 0.015, 8, 16),
                      right: horizontalPadding,
                      child: topButton(
                        icon: Icons.home,
                        size: topButtonSize,
                        onTap: goHome,
                      ),
                    ),

                    Positioned(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      top: cardTop,
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            currentQuestionCard(screenW),
                            SizedBox(
                              height: clampDouble(screenH * 0.012, 7, 12),
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
