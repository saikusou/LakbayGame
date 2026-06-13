import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson2.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonTwoDayTwoActFour extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayTwoActFour({super.key, required this.user});

  @override
  State<LessonTwoDayTwoActFour> createState() => _LessonTwoDayTwoActFourState();
}

class _LessonTwoDayTwoActFourState extends State<LessonTwoDayTwoActFour> {
  int currentQuestion = 0;
  late List<int?> selectedAnswers;

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
          'Sa panahong ito,\nginamit ang Pilipinas bilang\nimbakan ng kagamitang pandigma.',
      'answer': 1,
    },
    {
      'question':
          'Sa panahong ito naitayo\nang mga base militar\nsa bansang Pilipinas.',
      'answer': 1,
    },
    {
      'question':
          'Sa panahong ito\nnaipakilala ang\nKristiyanismo sa Pilipinas.',
      'answer': 0,
    },
    {
      'question':
          'Sa panahon na ito ay\nwala na ang mga base military\nsa Pilipinas.',
      'answer': 2,
    },
    {
      'question':
          'Sinakop ang Pilipinas\ndahil sa kanilang alitan\nsa mga Amerikano.',
      'answer': 2,
    },
  ];

  final List<Map<String, dynamic>> answers = [
    {'color': Colors.transparent, 'image': 'assets/flg1.png'},
    {'color': Colors.transparent, 'image': 'assets/flg2.png'},
    {'color': Colors.transparent, 'image': 'assets/flg3.png'},
  ];

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.filled(questions.length, null);
  }

  void nextQuestion() {
    // Prevent moving if no answer selected
    if (selectedAnswers[currentQuestion] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pumili muna ng sagot bago magpatuloy.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Lesson2Screen(user: widget.user)),
      );
    }
  }

  void previousQuestion() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
      });
    }
  }

  void selectAnswer(int index) {
    setState(() {
      selectedAnswers[currentQuestion] = index;
    });
  }

  Widget circleButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(2, 4),
              blurRadius: 5,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double questionFont = clampDouble(size.width * 0.04, 16, 22);
    final double cardWidth = clampDouble(size.width * 0.25, 85, 135);
    final double cardHeight = clampDouble(size.height * 0.22, 115, 155);
    final double buttonHeight = clampDouble(size.height * 0.07, 42, 55);
    final double buttonFont = clampDouble(size.width * 0.04, 14, 18);
    final double iconSize = clampDouble(size.width * 0.12, 42, 58);
    final double iconTop = clampDouble(size.height * 0.03, 18, 35);
    final double sidePadding = clampDouble(size.width * 0.04, 14, 25);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/lesson-two-day2-act4-f.png'),
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xfffff1bd),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    questions[currentQuestion]['question'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: questionFont,
                      height: 1.1,
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
                        isSelected: selectedAnswers[currentQuestion] == index,
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
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: selectedAnswers[currentQuestion] == null
                            ? null
                            : nextQuestion,
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
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: iconTop,
                right: sidePadding,
                child: circleButton(
                  icon: Icons.home,
                  color: Colors.orange,
                  size: iconSize,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Lesson2Screen(user: widget.user),
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
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.transparent,
            width: isSelected ? 4 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.yellow.withOpacity(0.9)
                  : Colors.black45,
              offset: const Offset(2, 4),
              blurRadius: isSelected ? 14 : 4,
              spreadRadius: isSelected ? 3 : 0,
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
