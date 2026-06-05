import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';

class LessonThreeDayFourActTwo extends StatefulWidget {
  const LessonThreeDayFourActTwo({super.key});

  @override
  State<LessonThreeDayFourActTwo> createState() =>
      _LessonThreeDayFourActTwoState();
}

class _LessonThreeDayFourActTwoState extends State<LessonThreeDayFourActTwo> {
  int currentPage = 0;

  final List<List<String>> questions = [
    [
      'Ang Ilaya ay matatagpuan malapit sa dagat.',
      'Ang pangunahing hanapbuhay sa Ilawud ay pangingisda.',
      'Ang Ilaya ay pamayanang nasa bundok o looban.',
      'Ang Ilawud ay walang kaugnayan sa kalakalan.',
      'Ang mga tao sa Ilaya ay nagsasaka at nangangaso.',
    ],
    [
      'Pamayanang malapit sa ilog o dagat.',
      'Ang mga tao ay nagtatanim at nangangaso.',
      'May mga bangka at mangingisda, Nasa Kabundukan o looban.',
      'Nakikipagkalakalan gamit ang mga producto, tulad ng bigas at Kayo.',
      'Nakikipagkalakalan gamit ang mga produkto, tulad ng isda at iba pang yamang-dagat.',
    ],
  ];

  final List<String> backgrounds = [
    'assets/lesson-three-day4-act2.png',
    'assets/lesson-three-day4-act2b.png',
  ];

  late final List<List<TextEditingController>> answers;

  @override
  void initState() {
    super.initState();
    answers = List.generate(
      questions.length,
      (page) =>
          List.generate(questions[page].length, (_) => TextEditingController()),
    );
  }

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  void dispose() {
    for (final page in answers) {
      for (final controller in page) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Widget answerBox(int index) {
    return Container(
      width: 85,
      height: 38,
      margin: const EdgeInsets.only(left: 8),
      child: TextField(
        controller: answers[currentPage][index],
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.characters,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
        ),
      ),
    );
  }

  Widget questionItem(int index, double fontSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: clampDouble(fontSize * 1.2, 18, 28)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}.',
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              questions[currentPage][index],
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          answerBox(index),
        ],
      ),
    );
  }

  Widget circleButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: clampDouble(size.width * 0.14, 50, 70),
        height: clampDouble(size.width * 0.14, 50, 70),
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
          size: clampDouble(size.width * 0.08, 28, 40),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final questionTop = clampDouble(size.height * 0.34, 250, 330);
    final horizontalPadding = clampDouble(size.width * 0.09, 28, 55);
    final fontSize = clampDouble(size.width * 0.038, 14, 18);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(backgrounds[currentPage], fit: BoxFit.fill),
          ),

          Positioned(
            top: questionTop,
            left: horizontalPadding,
            right: horizontalPadding,
            bottom: 100,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  questions[currentPage].length,
                  (index) => questionItem(index, fontSize),
                ),
              ),
            ),
          ),

          /// HOME BUTTON
          Positioned(
            top: clampDouble(size.height * 0.025, 14, 22),
            right: clampDouble(size.width * 0.04, 12, 20),
            child: circleButton(
              icon: Icons.home,
              color: Colors.orange,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Lesson3Screen()),
                );
              },
            ),
          ),

          /// BACK BUTTON
          if (currentPage == 1)
            Positioned(
              bottom: 25,
              left: 30,
              child: circleButton(
                icon: Icons.arrow_back,
                color: Colors.blue,
                onTap: () {
                  setState(() {
                    currentPage = 0;
                  });
                },
              ),
            ),

          /// NEXT BUTTON
          if (currentPage == 0)
            Positioned(
              bottom: 25,
              right: 30,
              child: circleButton(
                icon: Icons.arrow_forward,
                color: Colors.green,
                onTap: () {
                  setState(() {
                    currentPage = 1;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
