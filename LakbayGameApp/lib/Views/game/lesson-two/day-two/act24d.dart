import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson2.dart';
import 'package:lakbay_game/User/models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LessonTwoDayTwoActTwoE(
        user: UserModel(id: null, userName: '', email: '', gender: ''),
      ),
    );
  }
}

class LessonTwoDayTwoActTwoE extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayTwoActTwoE({super.key, required this.user});

  @override
  State<LessonTwoDayTwoActTwoE> createState() => _LessonTwoDayTwoActTwoEState();
}

class _LessonTwoDayTwoActTwoEState extends State<LessonTwoDayTwoActTwoE> {
  bool isNavigating = false;

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  void goToLessonHome() {
    if (isNavigating) return;

    setState(() {
      isNavigating = true;
    });

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Lesson2Screen(user: widget.user)),
      (route) => false,
    );
  }

  void goToLessonTwoScreen() {
    if (isNavigating) return;

    setState(() {
      isNavigating = true;
    });

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Lesson2Screen(user: widget.user)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;

    final screenWidth = size.width;
    final screenHeight = size.height;

    final homeButtonSize = clampDouble(screenWidth * 0.13, 46, 68);

    final doneButtonWidth = clampDouble(screenWidth * 0.42, 170, 250);

    final doneButtonHeight = clampDouble(screenHeight * 0.072, 50, 64);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3D6),

      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/konek-globo.png', fit: BoxFit.fill),

            // HOME BUTTON
            Positioned(
              top: clampDouble(screenHeight * 0.015, 8, 16),
              right: clampDouble(screenWidth * 0.04, 12, 22),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isNavigating ? null : goToLessonHome,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: homeButtonSize,
                    height: homeButtonSize,
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
                      Icons.home_rounded,
                      color: Colors.white,
                      size: clampDouble(screenWidth * 0.075, 26, 38),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // DONE BUTTON BELOW THE IMAGE
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            16,
            clampDouble(screenHeight * 0.012, 8, 12),
            16,
            clampDouble(screenHeight * 0.018, 12, 20),
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFFFF3D6),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Center(
            heightFactor: 1,
            child: SizedBox(
              width: doneButtonWidth,
              height: doneButtonHeight,
              child: ElevatedButton(
                onPressed: isNavigating ? null : goToLessonTwoScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  disabledBackgroundColor: const Color(
                    0xFFFF9800,
                  ).withValues(alpha: 0.65),
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: Colors.black45,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                    side: const BorderSide(color: Colors.white, width: 4),
                  ),
                ),
                child: isNavigating
                    ? SizedBox(
                        width: clampDouble(screenWidth * 0.06, 22, 28),
                        height: clampDouble(screenWidth * 0.06, 22, 28),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'DONE',
                            style: TextStyle(
                              fontSize: clampDouble(screenWidth * 0.05, 18, 24),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.check_circle_rounded,
                            size: clampDouble(screenWidth * 0.065, 24, 32),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
