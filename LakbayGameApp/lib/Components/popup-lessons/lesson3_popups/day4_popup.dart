import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/game/lesson-three/day-one/act4.dart';
import 'package:lakbay_game/Views/game/lesson-three/day-three/act2.dart';
import 'package:lakbay_game/Views/game/lesson-three/day-three/act3.dart';
import 'package:lakbay_game/Views/game/lesson-three/day-three/act4.dart';
import 'package:lakbay_game/Views/game/lesson-three/day-two/act1.dart';

class Day4Popup extends StatelessWidget {
  final String title;

  const Day4Popup({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    /// 1. LEARNING OBJECTIVES
    if (title.contains('Learning Objectives')) {
      return const _LearningObjectivesPopup();
    }

    /// 2. GAWAIN
    if (title.contains('2. Pagsusulit')) {
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LessonThreeDayOneActTwo()),
        );
      });

      return const SizedBox.shrink();
    }

    /// 3. KONSEPTO
    if (title.contains('3. Katanungan')) {
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LessonThreeDayOneActThree()),
        );
      });

      return const SizedBox.shrink();
    }

    /// 4. TAMA O MALI
    if (title.contains('Katanungan')) {
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LessonThreeDayOneActFour()),
        );
      });

      return const SizedBox.shrink();
    }

    /// 5. TAKDANG ARALIN
    if (title.contains('Takdang Aralin')) {
      return const _TakdangAralinPopup();
    }

    return const SizedBox();
  }
}

/// =========================================================
/// 1. LEARNING OBJECTIVES
/// =========================================================
class _LearningObjectivesPopup extends StatelessWidget {
  const _LearningObjectivesPopup();

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
            image: AssetImage('assets/lesson-three-day3-act1.png'),
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
  const _GawainPopup();

  @override
  Widget build(BuildContext context) {
    return _CustomPopupContainer(
      borderColor: Colors.green,
      child: const Text(
        "Dito ilalagay ang konsepto ng aralin.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

/// =========================================================
/// 3. KONSEPTO
/// =========================================================
class _KonseptoPopup extends StatelessWidget {
  const _KonseptoPopup();

  @override
  Widget build(BuildContext context) {
    return _CustomPopupContainer(
      borderColor: Colors.green,
      child: const Text(
        "Dito ilalagay ang konsepto ng aralin.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

/// =========================================================
/// 4. TAMA O MALI
/// =========================================================

class _TamaOMaliPopup extends StatelessWidget {
  const _TamaOMaliPopup();

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
            image: AssetImage('assets/lesson-three-day1-act5.png'),
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
          ],
        ),
      ),
    );
  }
}

/// =========================================================
/// 5. TAKDANG ARALIN
/// =========================================================

class _TakdangAralinPopup extends StatelessWidget {
  const _TakdangAralinPopup();

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
            image: AssetImage('assets/lesson-three-day3-act5.png'),
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

            /// OPTIONAL SPACE
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

/// =========================================================
/// REUSABLE POPUP CONTAINER
/// =========================================================
class _CustomPopupContainer extends StatelessWidget {
  final Color borderColor;
  final Widget child;

  const _CustomPopupContainer({required this.borderColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),

      child: Container(
        width: 360,
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: const Color(0xFFFFF6D8),
          borderRadius: BorderRadius.circular(28),

          border: Border.all(color: borderColor, width: 5),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,

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

                  child: const Icon(Icons.close, color: Colors.white, size: 26),
                ),
              ),
            ),

            const SizedBox(height: 10),

            child,
          ],
        ),
      ),
    );
  }
}
