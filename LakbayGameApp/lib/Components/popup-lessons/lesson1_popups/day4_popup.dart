import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/game/lesson-two/day-four/act2.dart';
import 'package:lakbay_game/Views/game/lesson-two/day-four/act3.dart';
import 'package:lakbay_game/Views/game/lesson-two/day-four/act4.dart';
import 'package:lakbay_game/models/user_model.dart';

class Day4Popup extends StatelessWidget {
  final String title;
  final UserModel user;

  const Day4Popup({super.key, required this.title, required this.user});

  @override
  Widget build(BuildContext context) {
    /// 1. LEARNING OBJECTIVES
    if (title.contains('Learning Objectives')) {
      return _LearningObjectivesPopup(user: user);
    }

    if (title.contains('Pagtukoy sa Pamantayan')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LessonTwoDayFourActTwo(user: user)),
        );
      });

      return const SizedBox.shrink();
    }

    if (title.contains('Pagsusulit')) {
      return _GawainPopup(user: user);
    }

    /// 5. TAKDANG ARALIN
    if (title.contains('Takdang Aralin')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LessonTwoDayFourActFour(user: user),
          ),
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
            image: AssetImage('assets/lesson-one-day4-act1.png'),
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

/// =========================================================
/// 2. GAWAIN
/// =========================================================

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
            image: AssetImage('assets/lesson-one-day4-act3a.png'),
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
                      builder: (context) =>
                          LessonTwoDayFourActThree(user: user),
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
