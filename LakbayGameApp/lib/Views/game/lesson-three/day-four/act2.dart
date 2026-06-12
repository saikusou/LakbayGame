import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonThreeDayFourActTwo extends StatefulWidget {
  final UserModel user;

  const LessonThreeDayFourActTwo({super.key, required this.user});

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
      'May mga bangka at mangingisda, nasa kabundukan o looban.',
      'Nakikipagkalakalan gamit ang mga produkto, tulad ng bigas at kahoy.',
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

  @override
  void dispose() {
    for (final page in answers) {
      for (final controller in page) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  Widget answerBox({
    required int index,
    required double width,
    required double height,
    required double fontSize,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: answers[currentPage][index],
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.characters,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
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

  Widget questionItem({
    required int index,
    required double fontSize,
    required double answerWidth,
    required double answerHeight,
    required double answerFontSize,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: clampDouble(fontSize * 1.25, 14, 24)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}.',
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 6),

          Expanded(
            child: Text(
              questions[currentPage][index],
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),

          SizedBox(width: clampDouble(answerWidth * 0.08, 5, 10)),

          answerBox(
            index: index,
            width: answerWidth,
            height: answerHeight,
            fontSize: answerFontSize,
          ),
        ],
      ),
    );
  }

  Widget circleButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    required double buttonSize,
    required double iconSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
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
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final bool isSmallScreen = size.height < 700;
    final bool isVerySmallWidth = size.width < 380;

    final double questionTop = clampDouble(
      size.height * (isSmallScreen ? 0.30 : 0.34),
      isSmallScreen ? 205 : 245,
      isSmallScreen ? 255 : 330,
    );

    final double horizontalPadding = clampDouble(
      size.width * 0.075,
      isVerySmallWidth ? 18 : 24,
      55,
    );

    final double fontSize = clampDouble(
      size.width * 0.036,
      isVerySmallWidth ? 12.5 : 14,
      18,
    );

    final double answerWidth = clampDouble(
      size.width * 0.19,
      isVerySmallWidth ? 58 : 68,
      88,
    );

    final double answerHeight = clampDouble(size.height * 0.048, 32, 40);

    final double answerFontSize = clampDouble(size.width * 0.038, 13, 16);

    final double buttonSize = clampDouble(size.width * 0.13, 45, 64);
    final double iconSize = clampDouble(size.width * 0.07, 25, 36);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(backgrounds[currentPage], fit: BoxFit.fill),
          ),

          Positioned(
            top: questionTop,
            left: horizontalPadding,
            right: horizontalPadding,
            bottom: keyboardHeight > 0
                ? keyboardHeight + 20
                : clampDouble(size.height * 0.12, 85, 115),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: List.generate(
                  questions[currentPage].length,
                  (index) => questionItem(
                    index: index,
                    fontSize: fontSize,
                    answerWidth: answerWidth,
                    answerHeight: answerHeight,
                    answerFontSize: answerFontSize,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: clampDouble(size.height * 0.025, 14, 24),
            right: clampDouble(size.width * 0.04, 12, 22),
            child: circleButton(
              icon: Icons.home,
              color: Colors.orange,
              buttonSize: buttonSize,
              iconSize: iconSize,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Lesson3Screen(user: widget.user),
                  ),
                );
              },
            ),
          ),

          if (currentPage == 1)
            Positioned(
              bottom: clampDouble(size.height * 0.035, 18, 30),
              left: clampDouble(size.width * 0.07, 20, 35),
              child: circleButton(
                icon: Icons.arrow_back,
                color: Colors.blue,
                buttonSize: buttonSize,
                iconSize: iconSize,
                onTap: () {
                  setState(() {
                    currentPage = 0;
                  });
                },
              ),
            ),

          if (currentPage == 0)
            Positioned(
              bottom: clampDouble(size.height * 0.035, 18, 30),
              right: clampDouble(size.width * 0.07, 20, 35),
              child: circleButton(
                icon: Icons.arrow_forward,
                color: Colors.green,
                buttonSize: buttonSize,
                iconSize: iconSize,
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
