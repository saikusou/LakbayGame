import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonThreeDayTwoActThree extends StatefulWidget {
  final UserModel user;

  const LessonThreeDayTwoActThree({super.key, required this.user});

  @override
  State<LessonThreeDayTwoActThree> createState() =>
      _LessonThreeDayTwoActThreeState();
}

class _LessonThreeDayTwoActThreeState extends State<LessonThreeDayTwoActThree> {
  final List<int?> selectedAnswers = List.generate(5, (_) => null);

  bool popupShown = false;

  /// CHANGE THIS VALUE TO MOVE THE WHOLE LIST DOWN
  final double listMarginTop = 20;

  /// 0 = Ilaya, 1 = Ilawud
  final List<int> correctAnswers = [0, 0, 0, 1, 1];

  final List<String> questions = [
    'Isa itong pamayanan\nna nasa looban o bundok.',
    'Ang pamayanang\nnakikipagkalakalan sa\nmalapit na lugar lamang.',
    'Ang pamayanang ang\npangunahing hanapbuhay\nay pagtatanim at pangangaso.',
    'Ang pamayanang ang\npangunahing hanapbuhay\nay pangingisda.',
    'Ang pamayanang malapit\nsa dagat o malalaking ilog.',
  ];

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Lesson3Screen(user: widget.user)),
    );
  }

  int getScore() {
    int score = 0;

    for (int i = 0; i < correctAnswers.length; i++) {
      if (selectedAnswers[i] == correctAnswers[i]) {
        score += 2;
      }
    }

    return score;
  }

  void checkIfCompleted() {
    if (popupShown) return;

    final allAnswered = selectedAnswers.every((answer) => answer != null);

    if (allAnswered) {
      popupShown = true;

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          showScorePopup();
        }
      });
    }
  }

  void showScorePopup() {
    final score = getScore();
    final totalScore = correctAnswers.length * 2;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final size = MediaQuery.of(context).size;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: clampDouble(size.width * 0.85, 280, 380),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.orange, width: 4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Congratulations!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.07, 24, 32),
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Score: $score / $totalScore',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.06, 22, 28),
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Each correct answer is 2 points.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.038, 13, 16),
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: clampDouble(size.width * 0.38, 130, 180),
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      goHome();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void selectAnswer(int index, int answer) {
    setState(() {
      selectedAnswers[index] = answer;
    });

    checkIfCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    final homeSize = clampDouble(size.width * 0.11, 42, 62);
    final homeIconSize = clampDouble(size.width * 0.06, 23, 34);

    final horizontalPadding = clampDouble(size.width * 0.06, 18, 42);

    final questionTop = clampDouble(
      size.height * 0.53,
      size.height * 0.42,
      size.height * 0.58,
    );

    final fontSize = clampDouble(size.width * 0.034, 11, 14);
    final numberFontSize = clampDouble(size.width * 0.045, 15, 19);
    final checkScale = clampDouble(size.width * 0.0024, 0.78, 1.0);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/lesson-three-day1-act2.png',
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
            top: safeTop + 8,
            right: 10,
            child: GestureDetector(
              onTap: goHome,
              child: Container(
                width: homeSize,
                height: homeSize,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: homeIconSize,
                ),
              ),
            ),
          ),

          Positioned(
            top: questionTop,
            left: horizontalPadding,
            right: horizontalPadding,
            bottom: safeBottom + 10,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(top: listMarginTop),
                child: Column(
                  children: List.generate(
                    questions.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: clampDouble(size.height * 0.012, 6, 12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: clampDouble(size.width * 0.055, 20, 28),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: numberFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),

                          SizedBox(
                            width: clampDouble(size.width * 0.02, 5, 10),
                          ),

                          Expanded(
                            child: Text(
                              questions[index],
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w700,
                                height: 1.08,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          Transform.scale(
                            scale: checkScale,
                            child: Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              value: selectedAnswers[index] == 0,
                              onChanged: (_) {
                                selectAnswer(index, 0);
                              },
                            ),
                          ),

                          Transform.scale(
                            scale: checkScale,
                            child: Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              value: selectedAnswers[index] == 1,
                              onChanged: (_) {
                                selectAnswer(index, 1);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
