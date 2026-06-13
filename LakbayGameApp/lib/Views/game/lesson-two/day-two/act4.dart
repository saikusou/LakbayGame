import 'package:flutter/material.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonTwoDayTwoActFour extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayTwoActFour({super.key, required this.user});

  @override
  State<LessonTwoDayTwoActFour> createState() => _LessonTwoDayTwoActFourState();
}

class _LessonTwoDayTwoActFourState extends State<LessonTwoDayTwoActFour> {
  int currentQuestion = 0;
  int? selectedAnswer;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'Nagkaroon ito ng interes\ndahil malapit ang bansa\nsa Spice Islands.',
      'answer': 0,
    },
    {
      'question':
          'Dumating sila sa Pilipinas\nupang palaganapin ang\nKristiyanismo.',
      'answer': 0,
    },
    {
      'question':
          'Sinakop nila ang Pilipinas\npagkatapos ng pananakop\nng mga Espanyol.',
      'answer': 1,
    },
    {
      'question':
          'Sinakop nila ang Pilipinas\nnoong panahon ng\nIkalawang Digmaang Pandaigdig.',
      'answer': 2,
    },
    {
      'question':
          'Sinakop nila ang Pilipinas\nnoong panahon ng\nIkalawang Digmaang Pandaigdig.',
      'answer': 2,
    },
  ];

  final List<Map<String, dynamic>> answers = [
    {'color': Color.fromARGB(0, 198, 40, 40), 'image': 'assets/flg1.png'},
    {'color': Color.fromARGB(0, 21, 101, 192), 'image': 'assets/flg2.png'},
    {'color': Color.fromARGB(0, 46, 125, 50), 'image': 'assets/flg3.png'},
  ];

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void previousQuestion() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
        selectedAnswer = null;
      });
    }
  }

  void selectAnswer(int index) {
    setState(() {
      selectedAnswer = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double questionFont = clampDouble(size.width * 0.04, 16, 22);
    final double cardWidth = clampDouble(size.width * 0.25, 85, 135);
    final double cardHeight = clampDouble(size.height * 0.22, 115, 155);
    final double buttonHeight = clampDouble(size.height * 0.07, 42, 55);
    final double buttonFont = clampDouble(size.width * 0.04, 14, 18);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/spice_background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: size.height * 0.22,
                left: size.width * 0.11,
                right: size.width * 0.11,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xfffff1bd),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xff8b4b16),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    questions[currentQuestion]['question'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: questionFont,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xff092f52),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: size.height * 0.50,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(answers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: answerCard(
                        width: cardWidth,
                        height: cardHeight,
                        color: answers[index]['color'],
                        image: answers[index]['image'],
                        isSelected: selectedAnswer == index,
                        onTap: () => selectAnswer(index),
                      ),
                    );
                  }),
                ),
              ),

              Positioned(
                bottom: size.height * 0.035,
                left: size.width * 0.05,
                right: size.width * 0.05,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: currentQuestion == 0 ? null : previousQuestion,
                        child: Container(
                          height: buttonHeight,
                          decoration: BoxDecoration(
                            color: currentQuestion == 0
                                ? Colors.grey
                                : const Color(0xffd35400),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.yellow, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '⬅ PREVIOUS',
                              style: TextStyle(
                                fontSize: buttonFont,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(1.5, 1.5),
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: GestureDetector(
                        onTap: nextQuestion,
                        child: Container(
                          height: buttonHeight,
                          decoration: BoxDecoration(
                            color: const Color(0xff188b2c),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.yellow, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              currentQuestion == questions.length - 1
                                  ? 'DONE'
                                  : 'NEXT ➜',
                              style: TextStyle(
                                fontSize: buttonFont,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(1.5, 1.5),
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget answerCard({
    required double width,
    required double height,
    required Color color,
    required String image,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.yellow.withOpacity(0.8)
                  : Colors.black45,
              offset: const Offset(2, 4),
              blurRadius: isSelected ? 10 : 4,
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
