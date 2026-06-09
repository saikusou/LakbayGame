import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-three/act3-a.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-three/act3-b.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-three/act3-c.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-three/act3-d.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/models/user_model.dart';

/// ADD YOUR MISSION PAGES HERE

class LessonOneDayThreeActThree extends StatelessWidget {
  final UserModel user;

  const LessonOneDayThreeActThree({super.key, required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void openMission(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double w = constraints.maxWidth;
          final double h = constraints.maxHeight;

          final bool smallScreen = w < 380;

          final double homeSize = clampDouble(w * 0.13, 45, 65);

          final double buttonWidth = smallScreen
              ? clampDouble(w * 0.34, 105, 130)
              : clampDouble(w * 0.38, 130, 165);

          final double buttonHeight = clampDouble(h * 0.064, 43, 58);

          final double rightPosition = smallScreen
              ? clampDouble(w * 0.055, 12, 25)
              : clampDouble(w * 0.08, 18, 45);

          final List<double> missionTops = [
            h * 0.49,
            h * 0.60,
            h * 0.71,
            h * 0.815,
          ];

          final List<Widget> missionPages = [
            LessonOneDayThreeActThreeA(user: user),
            LessonOneDayThreeActThreeB(user: user),
            LessonOneDayThreeActThreeC(user: user),
            LessonOneDayThreeActThreeD(user: user),
          ];

          return SizedBox.expand(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/lesson-two-day3-act3.png',
                    fit: BoxFit.fill,
                  ),
                ),

                Positioned(
                  top: clampDouble(h * 0.025, 12, 22),
                  right: clampDouble(w * 0.035, 10, 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Lesson1Screen(user: user),
                        ),
                      );
                    },
                    child: Container(
                      width: homeSize,
                      height: homeSize,
                      decoration: BoxDecoration(
                        color: Colors.orange,
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
                        Icons.home,
                        color: Colors.white,
                        size: clampDouble(homeSize * 0.55, 24, 36),
                      ),
                    ),
                  ),
                ),

                for (int i = 0; i < 4; i++)
                  Positioned(
                    top: missionTops[i],
                    right: rightPosition,
                    child: missionButton(
                      width: buttonWidth,
                      height: buttonHeight,
                      smallScreen: smallScreen,
                      onTap: () {
                        openMission(context, missionPages[i]);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget missionButton({
    required double width,
    required double height,
    required bool smallScreen,
    required VoidCallback onTap,
  }) {
    final double iconSize = clampDouble(height * 0.52, 20, 30);
    final double playSize = clampDouble(height * 0.38, 16, 24);
    final double fontSize = smallScreen
        ? clampDouble(height * 0.21, 9, 11)
        : clampDouble(height * 0.24, 10.5, 14);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: smallScreen ? 5 : clampDouble(width * 0.055, 6, 10),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFB7F300), Color(0xFF5EAE00)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: const Color(0xFF3D7500), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Color(0xFF5EAE00),
                size: playSize,
              ),
            ),
            SizedBox(width: smallScreen ? 3 : 6),
            Flexible(
              child: Text(
                'BUKSAN\nANG MISYON',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: fontSize,
                  height: 0.95,
                  shadows: const [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
