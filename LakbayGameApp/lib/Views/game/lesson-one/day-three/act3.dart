import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson1.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonOneDayThreeActThree extends StatefulWidget {
  final UserModel user;

  const LessonOneDayThreeActThree({super.key, required this.user});

  @override
  State<LessonOneDayThreeActThree> createState() =>
      _LessonOneDayThreeActThreeState();
}

class _LessonOneDayThreeActThreeState extends State<LessonOneDayThreeActThree> {
  int currentImageIndex = 0;

  // Answers for all 9 questions
  List<int?> answers = List.filled(9, null);

  bool isSaving = false;

  final List<String> images = [
    'assets/lesson-one-day3-act3a.png',
    'assets/lesson-one-day3-act3b.png',
    'assets/lesson-one-day3-act3c.png',
  ];

  final List<Map<String, dynamic>> allQuestions = [
    // Round 1 - Image 1 (Questions 1-3)
    {
      'number': 1,
      'question': 'Ano ang ipinapakita ng mapa?',
      'choices': [
        'Mga hayop sa Pilipinas',
        'Ruta ng paglalakbay',
        'Mga ninuno ng Pilipino',
        'Uri ng pagkain noon',
      ],
      'correct': 1,
      'imageIndex': 0,
    },
    {
      'number': 2,
      'question': 'Bakit naging posible ang paglalakbay noon?',
      'choices': [
        'Dahil may eroplano',
        'Dahil magkakalapit ang mga pulo',
        'Dahil may tulay',
        'Dahil may kotse',
      ],
      'correct': 1,
      'imageIndex': 0,
    },
    {
      'number': 3,
      'question': 'Anong ebidensya ang ginagamit sa gawaing ito?',
      'choices': ['Timeline', 'Larawan', 'Mapa', 'Awit'],
      'correct': 2,
      'imageIndex': 0,
    },
    // Round 2 - Image 2 (Questions 4-6)
    {
      'number': 4,
      'question': 'Ano ang dapat mauna sa timeline?',
      'choices': ['24,000 taon', '67,000 taon', '709,000 taon', '2025 taon'],
      'correct': 2,
      'imageIndex': 1,
    },
    {
      'number': 5,
      'question': 'Ano ang ipinapakita ng timeline?',
      'choices': [
        'Ayos ng pangyayari ayon sa panahon',
        'Uri ng hayop',
        'Lokasyon ng dagat',
        'Mga pagkain noon',
      ],
      'correct': 0,
      'imageIndex': 1,
    },
    {
      'number': 6,
      'question': 'Ano ang pinapatutunayan ng mga ebidensya?',
      'choices': [
        'Walang tao noon',
        'Matagal nang may tao sa Pilipinas',
        'Bagong bansa ang pilipinas',
        'Walang sinaunang kultura',
      ],
      'correct': 1,
      'imageIndex': 1,
    },

    // Round 3 - Image 3 (Questions 7-9)
    {
      'number': 7,
      'question': 'Ano ang ipinapakita ng mga simbolong ito?',
      'choices': [
        'Kulturang Pilipino',
        'Modernong teknolohiya',
        'Mga sasakyan',
        'Mga gusali',
      ],
      'correct': 0,
      'imageIndex': 2,
    },
    {
      'number': 8,
      'question': 'Bakit mahalaga ang kaalamang bayan?',
      'choices': [
        'Dahil nagpapakita ito ng tradisyon at paniniwala',
        'Dahil ginagamit sa laro',
        'Dahil modernong imbensyon ito',
        'Dahil gawa it ng ibang bansa',
      ],
      'correct': 0,
      'imageIndex': 2,
    },
    {
      'number': 9,
      'question': 'Anong ebidensya ang ginamit sa gawaing ito?',
      'choices': ['Mapa', 'Timeline', 'Larawan at simbulo', 'Numero'],
      'correct': 2,
      'imageIndex': 2,
    },
  ];

  double clampDouble(double value, double min, double max) {
    final double low = min < max ? min : max;
    final double high = min < max ? max : min;
    return value.clamp(low, high).toDouble();
  }

  String get currentImage => images[currentImageIndex];

  List<Map<String, dynamic>> get currentQuestions {
    return allQuestions
        .where((q) => q['imageIndex'] == currentImageIndex)
        .toList();
  }

  int get startIndex => currentImageIndex * 3;
  int get endIndex => startIndex + 3;

  Future<void> handleSavePoints({required int totalScore}) async {
    await ApiService.savePoints(
      userId: widget.user.id,
      countedPoints: totalScore,
      lesson: 'Lesson 1',
      day: 'Day 3',
      act: 'Act 3',
    );
  }

  void goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)),
    );
  }

  bool isRoundComplete() {
    for (int i = startIndex; i < endIndex; i++) {
      if (answers[i] == null) return false;
    }
    return true;
  }

  bool isAllQuestionsAnswered() {
    return answers.every((answer) => answer != null);
  }

  int getTotalScore() {
    int score = 0;
    for (int i = 0; i < allQuestions.length; i++) {
      if (answers[i] == allQuestions[i]['correct']) {
        score += 5;
      }
    }
    return score;
  }

  void nextRound() {
    if (!isRoundComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sagutin muna ang lahat ng tanong bago magpatuloy.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (currentImageIndex < 2) {
      setState(() => currentImageIndex++);
    } else {
      showResultPopup();
    }
  }

  void previousRound() {
    if (currentImageIndex > 0) {
      setState(() => currentImageIndex--);
    }
  }

  void showResultPopup() {
    final int score = getTotalScore();
    final int maxScore = 45;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;
        final popupWidth = clampDouble(size.width * 0.82, 260, 360);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(18),
              child: Container(
                width: popupWidth,
                padding: EdgeInsets.all(
                  clampDouble(size.width * 0.045, 14, 20),
                ),
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
                      'Kabuuang Iskor: $score / $maxScore',
                      style: TextStyle(
                        fontSize: clampDouble(size.width * 0.048, 17, 22),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff5a310b),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 130,
                      child: bottomButton(
                        isSaving ? 'Saving...' : 'OK',
                        14,
                        isSaving
                            ? () {}
                            : () async {
                                setDialogState(() => isSaving = true);

                                try {
                                  await handleSavePoints(totalScore: score);

                                  if (!mounted) return;

                                  Navigator.pop(dialogContext);
                                  goHome();
                                } catch (e) {
                                  setDialogState(() => isSaving = false);

                                  if (!mounted) return;

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
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: compact ? double.infinity : null,
        margin: EdgeInsets.symmetric(
          horizontal: compact ? 0 : 2,
          vertical: compact ? 1 : 0,
        ),
        padding: EdgeInsets.symmetric(
          vertical: clampDouble(fontSize * 0.35, 3, 6),
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xffffdf7e) : const Color(0xfffff6cf),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xffc28a2c), width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: fontSize + 1,
              color: const Color(0xff7a4b10),
            ),
            const SizedBox(width: 3),
            Flexible(
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
    final double questionFont = clampDouble(width * 0.026, 10, 14);
    final double choiceFont = clampDouble(width * 0.022, 9, 12);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(clampDouble(width * 0.018, 6, 10)),
      decoration: BoxDecoration(
        color: const Color(0xffffeaa5).withOpacity(0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffa96c19), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(1, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff3d2408),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: clampDouble(width * 0.01, 3, 6)),
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
              : Wrap(
                  spacing: 3,
                  runSpacing: 3,
                  children: List.generate(
                    choices.length,
                    (index) => choiceButton(
                      text: choices[index],
                      index: index,
                      groupValue: groupValue,
                      onChanged: onChanged,
                      fontSize: choiceFont,
                      compact: false,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget bottomButton(String text, double fontSize, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: clampDouble(fontSize * 2.8, 30, 38),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xff8b4b12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xffffb33b), width: 1.5),
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
          final bool smallWidth = screenW < 400;

          final double horizontalPadding = clampDouble(screenW * 0.025, 6, 14);
          final double topButtonSize = clampDouble(screenW * 0.07, 28, 38);
          final double bottomFont = clampDouble(screenW * 0.024, 9, 12);

          final double bottomCardPadding = smallHeight ? 4 : 8;
          final double maxCardHeight = screenH * (smallHeight ? 0.35 : 0.38);

          final questions = currentQuestions;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(currentImage, fit: BoxFit.fill),
              ),
              SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: clampDouble(screenH * 0.008, 4, 10),
                      left: horizontalPadding,
                      child: circleButton(
                        icon: Icons.arrow_back,
                        size: topButtonSize,
                        onTap: currentImageIndex > 0 ? previousRound : goHome,
                      ),
                    ),
                    Positioned(
                      top: clampDouble(screenH * 0.008, 4, 10),
                      right: horizontalPadding,
                      child: circleButton(
                        icon: Icons.home,
                        size: topButtonSize,
                        onTap: goHome,
                      ),
                    ),
                    // Round indicator
                    Positioned(
                      top: clampDouble(screenH * 0.008, 4, 10),
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            'Round ${currentImageIndex + 1} of 3',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: clampDouble(screenW * 0.03, 10, 14),
                            ),
                          ),
                        ),
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
                              // Display 3 questions for current image
                              for (int i = 0; i < questions.length; i++)
                                Column(
                                  children: [
                                    questionCard(
                                      number: questions[i]['number'],
                                      question: questions[i]['question'],
                                      choices: List<String>.from(
                                        questions[i]['choices'],
                                      ),
                                      groupValue: answers[startIndex + i],
                                      onChanged: (value) {
                                        setState(() {
                                          answers[startIndex + i] = value;
                                        });
                                      },
                                      width: screenW,
                                    ),
                                    if (i < questions.length - 1)
                                      SizedBox(
                                        height: clampDouble(
                                          screenH * 0.006,
                                          3,
                                          6,
                                        ),
                                      ),
                                  ],
                                ),
                              SizedBox(
                                height: clampDouble(screenH * 0.006, 3, 6),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: bottomButton(
                                      currentImageIndex == 0 ? 'BACK' : 'PREV',
                                      bottomFont,
                                      currentImageIndex > 0
                                          ? previousRound
                                          : goHome,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    flex: 2,
                                    child: bottomButton(
                                      currentImageIndex == 2
                                          ? 'FINISH'
                                          : 'NEXT →',
                                      bottomFont,
                                      nextRound,
                                    ),
                                  ),
                                ],
                              ),
                              // Progress indicator
                              SizedBox(
                                height: clampDouble(screenH * 0.004, 2, 4),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  bool isCompleted = true;
                                  for (
                                    int i = index * 3;
                                    i < (index * 3) + 3;
                                    i++
                                  ) {
                                    if (answers[i] == null) {
                                      isCompleted = false;
                                      break;
                                    }
                                  }
                                  return Row(
                                    children: [
                                      Container(
                                        width: clampDouble(
                                          screenW * 0.04,
                                          14,
                                          20,
                                        ),
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: currentImageIndex == index
                                              ? Colors.orange
                                              : isCompleted
                                              ? Colors.green
                                              : Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                      if (index < 2) SizedBox(width: 5),
                                    ],
                                  );
                                }),
                              ),
                              SizedBox(
                                height: clampDouble(screenH * 0.003, 1, 3),
                              ),
                              Text(
                                '${answers.where((a) => a != null).length} of 9 answered',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: clampDouble(screenW * 0.02, 8, 11),
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.8),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: clampDouble(screenH * 0.003, 1, 3),
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
