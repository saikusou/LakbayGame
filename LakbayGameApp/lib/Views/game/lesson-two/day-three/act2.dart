import 'package:flutter/material.dart';
import 'package:lakbay_game/models/user_model.dart';
import 'package:lakbay_game/Views/lesson1.dart';

class LessonThreeDayThreeActTwo extends StatefulWidget {
  final UserModel user;

  const LessonThreeDayThreeActTwo({super.key, required this.user});

  @override
  State<LessonThreeDayThreeActTwo> createState() =>
      _LessonThreeDayThreeActTwoState();
}

class _LessonThreeDayThreeActTwoState extends State<LessonThreeDayThreeActTwo> {
  int currentQuestion = 0;
  final List<int?> answers = List.filled(10, null);

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  final List<String> questions = [
    'Ang Pilipinas ay isang arkipelago na binubuo ng mahigit 7,641 na pulo',
    'Ang arkipelago ay mga lugar na binubuo ng malalawak na disyerto',
    'Mas malawak ang katubigan kaysa kalupaan ng Pilipinas',
    'Ang Pilipinas ay binubuo lamang ng isang malaking pulo',
    'Ang lokasyon ng Pilipinas ay nakatulong sa kalakalan at transportasyon sa Asya',
    'Ang Pilipinas ay naging daanan ng migrasyon ng mga unang tao',
    'Naging limitado ang ambag ng lokasyon ng Pilipinas sa pandaigdigang ugnayan',
    'Ang Pilipinas ay naging sentro ng pinaghalong kulturang Silangan at Kanluran',
    'Ang kalupaan ng Pilipinas ay pinagkukunan ng yamang-dagat',
    'Ang konsepto ng global citizenship ay nagpapakita ng ugnayan ng mga tao sa buong mundo',
  ];

  final List<int> correctAnswers = [
    1, // TAMA
    1, // TAMA
    1, // TAMA
    0, // Mali
    1, // Tama
    1, // TAMA
    1, // TAMA
    1, // Tama
    1, // TAMA
    1, // TAMA
  ];

  Widget circleButton({
    required IconData icon,
    required Color color,
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
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      ),
    );
  }

  int getScore() {
    int score = 0;

    for (int i = 0; i < questions.length; i++) {
      if (answers[i] == correctAnswers[i]) {
        score++;
      }
    }

    return score;
  }

  void nextQuestion() {
    if (answers[currentQuestion] == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pumili muna ng sagot.')));
      return;
    }

    if (currentQuestion == questions.length - 1) {
      final int score = getScore();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text(
            'RESULT',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 75),
              const SizedBox(height: 12),
              Text(
                '$score / ${questions.length}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Nakakuha ka ng $score tamang sagot.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        currentQuestion++;
      });
    }
  }

  void previousQuestion() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
      });
    }
  }

  Widget questionContainer({required Size size, required double questionFont}) {
    return Expanded(
      child: Center(
        child: Container(
          width: double.infinity,
          height: clampDouble(size.height * 0.35, 10, 310),
          margin: EdgeInsets.symmetric(
            horizontal: clampDouble(size.width * 0.04, 12, 28),
            vertical: clampDouble(size.height * 0.01, 6, 14),
          ),
          padding: EdgeInsets.all(clampDouble(size.width * 0.05, 16, 30)),
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                questions[currentQuestion],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: questionFont,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.35,
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget answerButton({
    required String text,
    required IconData icon,
    required int value,
    required Color color,
    required double fontSize,
  }) {
    final bool selected = answers[currentQuestion] == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            answers[currentQuestion] = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: clampDouble(
            MediaQuery.of(context).size.height * 0.075,
            48,
            65,
          ),
          decoration: BoxDecoration(
            color: selected ? color : color.withOpacity(0.38),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? Colors.black : Colors.white,
              width: selected ? 4 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(selected ? 0.30 : 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: fontSize * 1.45),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget navButton({
    required String text,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: Colors.grey,
          padding: EdgeInsets.symmetric(
            vertical: clampDouble(
              MediaQuery.of(context).size.height * 0.018,
              12,
              18,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double questionFont = clampDouble(size.width * 0.052, 18, 32);
    final double buttonFont = clampDouble(size.width * 0.045, 16, 26);

    final double homeButtonSize = clampDouble(size.width * 0.12, 45, 60);
    final double iconTop = clampDouble(size.height * 0.015, 10, 20);
    final double sidePadding = clampDouble(size.width * 0.04, 14, 28);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/lesson-two-day3-act2m.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: clampDouble(size.width * 0.04, 14, 28),
                  vertical: clampDouble(size.height * 0.015, 8, 18),
                ),
                child: Column(
                  children: [
                    Text(
                      '${currentQuestion + 1} / ${questions.length}',
                      style: TextStyle(
                        fontSize: clampDouble(size.width * 0.045, 16, 24),
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),

                    questionContainer(size: size, questionFont: questionFont),

                    Row(
                      children: [
                        answerButton(
                          text: 'TAMA',
                          icon: Icons.star,
                          value: 1,
                          color: Colors.green,
                          fontSize: buttonFont,
                        ),
                        SizedBox(
                          width: clampDouble(size.width * 0.035, 10, 20),
                        ),
                        answerButton(
                          text: 'MALI',
                          icon: Icons.favorite,
                          value: 0,
                          color: Colors.red,
                          fontSize: buttonFont,
                        ),
                      ],
                    ),

                    SizedBox(height: clampDouble(size.height * 0.025, 14, 28)),

                    Row(
                      children: [
                        navButton(
                          text: 'PREVIOUS',
                          onPressed: currentQuestion == 0
                              ? null
                              : previousQuestion,
                          color: Colors.orange,
                        ),
                        SizedBox(
                          width: clampDouble(size.width * 0.035, 10, 18),
                        ),
                        navButton(
                          text: currentQuestion == questions.length - 1
                              ? 'DONE'
                              : 'NEXT',
                          onPressed: nextQuestion,
                          color: const Color(0xFF005DCC),
                        ),
                      ],
                    ),

                    SizedBox(height: clampDouble(size.height * 0.015, 8, 18)),
                  ],
                ),
              ),

              Positioned(
                top: iconTop,
                right: sidePadding,
                child: circleButton(
                  icon: Icons.home,
                  color: Colors.orange,
                  size: homeButtonSize,
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
            ],
          ),
        ),
      ),
    );
  }
}
