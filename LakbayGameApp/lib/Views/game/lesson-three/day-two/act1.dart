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

  /// CHANGE THIS VALUE TO MOVE THE WHOLE LIST DOWN
  final double listMarginTop = 20;

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
                                setState(() {
                                  selectedAnswers[index] = 0;
                                });
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
                                setState(() {
                                  selectedAnswers[index] = 1;
                                });
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
