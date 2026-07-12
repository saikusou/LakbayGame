import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/game/lesson-two/day-two/act23.dart';
import 'package:lakbay_game/Views/lesson2.dart';
import 'package:lakbay_game/User/models/user_model.dart';

// CHANGE THIS IMPORT TO THE ACTUAL LOCATION OF YOUR NEXT PAGE.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LessonTwoDayTwoActTwoD(
        user: UserModel(id: null, userName: '', email: '', gender: ''),
      ),
    );
  }
}

class LessonTwoDayTwoActTwoD extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayTwoActTwoD({super.key, required this.user});

  @override
  State<LessonTwoDayTwoActTwoD> createState() => _LessonTwoDayTwoActTwoDState();
}

class _LessonTwoDayTwoActTwoDState extends State<LessonTwoDayTwoActTwoD> {
  bool isNavigating = false;

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  void goToLessonHome() {
    if (isNavigating) return;

    setState(() {
      isNavigating = true;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => Lesson2Screen(user: widget.user)),
    );
  }

  void goToNextPage() {
    if (isNavigating) return;

    setState(() {
      isNavigating = true;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LessonTwoDayTwoActTwo3(user: widget.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final padding = mediaQuery.padding;

    final screenWidth = size.width;
    final screenHeight = size.height;

    final homeButtonSize = clampDouble(screenWidth * 0.13, 46, 68);

    final nextButtonWidth = clampDouble(screenWidth * 0.42, 170, 250);

    final nextButtonHeight = clampDouble(screenHeight * 0.072, 50, 64);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/konek-longhitud.png', fit: BoxFit.fill),

          // HOME BUTTON
          Positioned(
            top: padding.top + clampDouble(screenHeight * 0.015, 8, 16),
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

          // NEXT BUTTON
          Positioned(
            left: 0,
            right: 0,
            bottom: padding.bottom + clampDouble(screenHeight * 0.025, 16, 28),
            child: Center(
              child: SizedBox(
                width: nextButtonWidth,
                height: nextButtonHeight,
                child: ElevatedButton(
                  onPressed: isNavigating ? null : goToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    disabledBackgroundColor: const Color(
                      0xFFFF9800,
                    ).withValues(alpha: 0.65),
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                      side: const BorderSide(color: Colors.white, width: 4),
                    ),
                    padding: EdgeInsets.zero,
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
                              'NEXT',
                              style: TextStyle(
                                fontSize: clampDouble(
                                  screenWidth * 0.05,
                                  18,
                                  24,
                                ),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: clampDouble(screenWidth * 0.065, 24, 32),
                            ),
                          ],
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
