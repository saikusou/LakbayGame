import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/game/lesson-three/day-one/act4.dart';
import 'package:lakbay_game/Views/game/lesson-two/day-one/act2.dart';

import 'package:lakbay_game/Views/game/lesson-two/day-one/act5.dart';
import 'package:lakbay_game/Views/game/lesson-two/day-two/act2.dart';
import 'package:lakbay_game/Views/game/lesson-two/day-two/act3.dart';
import 'package:lakbay_game/Views/game/lesson-two/day-two/act4.dart';
import 'package:lakbay_game/Views/game/lesson-two/day-two/act5.dart';
import 'package:lakbay_game/models/user_model.dart';

class Day2Popup extends StatelessWidget {
  final String title;
  final UserModel user;

  const Day2Popup({super.key, required this.title, required this.user});

  @override
  Widget build(BuildContext context) {
    if (title.contains('Learning Objectives')) {
      return _LearningObjectivesPopup(user: user);
    }

    if (title.contains('Ayusin mo ako')) {
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LessonTwoDayOneActTwo(user: user)),
        );
      });

      return const SizedBox.shrink();
    }

    if (title.contains('I-Konek mo ako')) {
      return _SubukanPopup(user: user);
    }

    if (title.contains('Picture mining')) {
      return _TamaOMaliPopup(user: user);
    }

    if (title.contains('Piliin ang tamang panahon')) {
      return _TamangPanahonPopup(user: user);
    }

    /// 5. TAKDANG ARALIN
    if (title.contains('Takdang Aralin')) {
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LessonTwoDayTwoActFive(user: user)),
        );
      });

      return const SizedBox.shrink();
    }

    return const SizedBox();
  }
}

/// =========================================================
/// 1. LEARNING OBJECTIVES
/// =========================================================
class _LearningObjectivesPopup extends StatelessWidget {
  final UserModel user;

  const _LearningObjectivesPopup({required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final popupHeight = clampDouble(size.height * 0.75, 450, 500);
    final popupWidth = clampDouble(size.width * 0.90, 350, 550);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),

      child: Container(
        width: popupWidth,
        height: popupHeight,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),

          border: Border.all(color: Colors.blue, width: 5),

          /// BACKGROUND IMAGE
          image: const DecorationImage(
            image: AssetImage('assets/lesson-two-day2-act1.png'),
            fit: BoxFit.fill,
          ),
        ),

        child: Column(
          children: [
            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,

              child: Padding(
                padding: const EdgeInsets.all(14),

                child: GestureDetector(
                  onTap: () => Navigator.pop(context),

                  child: Container(
                    width: 44,
                    height: 44,

                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,

                      border: Border.all(color: Colors.white, width: 3),
                    ),

                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),

            /// OPTIONAL SPACE
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _GawainPopup extends StatelessWidget {
  final UserModel user;
  const _GawainPopup({required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final popupHeight = clampDouble(size.height * 0.75, 450, 530);
    final popupWidth = clampDouble(size.width * 0.90, 350, 550);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),

      child: Container(
        width: popupWidth,
        height: popupHeight,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),

          border: Border.all(color: Colors.blue, width: 5),

          /// BACKGROUND IMAGE
          image: const DecorationImage(
            image: AssetImage('assets/lesson3-day2.png'),
            fit: BoxFit.cover,
          ),
        ),

        child: Column(
          children: [
            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,

              child: Padding(
                padding: const EdgeInsets.all(14),

                child: GestureDetector(
                  onTap: () => Navigator.pop(context),

                  child: Container(
                    width: 44,
                    height: 44,

                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,

                      border: Border.all(color: Colors.white, width: 3),
                    ),

                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),

            /// PUSH BUTTON TO BOTTOM
            const Spacer(),

            /// SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.only(bottom: 20),

              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonThreeActFour(user: user),
                    ),
                  );
                },

                child: Container(
                  width: 70,
                  height: 70,

                  decoration: BoxDecoration(
                    color: Colors.green,
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

                  child: const Icon(Icons.send, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TamaOMaliPopup extends StatelessWidget {
  final UserModel user;

  const _TamaOMaliPopup({required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final popupHeight = clampDouble(size.height * 0.75, 450, 530);
    final popupWidth = clampDouble(size.width * 0.90, 350, 550);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: Container(
        width: popupWidth,
        height: popupHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.blue, width: 5),

          /// IMAGE FILLS ENTIRE POPUP
          image: const DecorationImage(
            image: AssetImage('assets/lesson-two-day1-act3.png'),
            fit: BoxFit.fill,
          ),
        ),

        child: Column(
          children: [
            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            /// SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonTwoDayTwoActThree(user: user),
                    ),
                  );
                },

                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.green,
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
                  child: const Icon(Icons.send, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TamangPanahonPopup extends StatelessWidget {
  final UserModel user;

  const _TamangPanahonPopup({required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final popupHeight = clampDouble(size.height * 0.75, 450, 530);
    final popupWidth = clampDouble(size.width * 0.90, 350, 550);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: Container(
        width: popupWidth,
        height: popupHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.blue, width: 5),

          /// IMAGE FILLS ENTIRE POPUP
          image: const DecorationImage(
            image: AssetImage('assets/lesson-two-day2-act4t.png'),
            fit: BoxFit.fill,
          ),
        ),

        child: Column(
          children: [
            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            /// SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonTwoDayTwoActFour(user: user),
                    ),
                  );
                },

                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.green,
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
                  child: const Icon(Icons.send, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubukanPopup extends StatelessWidget {
  final UserModel user;

  const _SubukanPopup({required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final popupHeight = clampDouble(size.height * 0.75, 450, 530);
    final popupWidth = clampDouble(size.width * 0.90, 350, 550);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: Container(
        width: popupWidth,
        height: popupHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.blue, width: 5),

          /// IMAGE FILLS ENTIRE POPUP
          image: const DecorationImage(
            image: AssetImage('assets/lesson-two-day2-act2.png'),
            fit: BoxFit.fill,
          ),
        ),

        child: Column(
          children: [
            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            /// SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonTwoDayTwoActTwo(user: user),
                    ),
                  );
                },

                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.green,
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
                  child: const Icon(Icons.send, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TakdangAralinPopup extends StatelessWidget {
  final UserModel user;

  const _TakdangAralinPopup({required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final popupHeight = clampDouble(size.height * 0.75, 450, 530);
    final popupWidth = clampDouble(size.width * 0.90, 350, 550);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: Container(
        width: popupWidth,
        height: popupHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.blue, width: 5),

          /// IMAGE FILLS ENTIRE POPUP
          image: const DecorationImage(
            image: AssetImage('assets/lesson-two-day1-act5.png'),
            fit: BoxFit.fill,
          ),
        ),

        child: Column(
          children: [
            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            /// SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LessonThreeDayOneActFive(user: user),
                    ),
                  );
                },

                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.green,
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
                  child: const Icon(Icons.send, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
