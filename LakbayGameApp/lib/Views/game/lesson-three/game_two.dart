import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/models/user_model.dart';

class HiddenPopup extends StatelessWidget {
  final UserModel users;
  final String image;

  const HiddenPopup({super.key, required this.image, required this.users});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),

      child: Container(
        width: 330,
        height: 420,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),

          /// FULL IMAGE BACKGROUND
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),

          border: Border.all(color: Colors.orange, width: 5),
        ),

        child: Column(
          children: [
            /// CLOSE BUTTON
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },

                  child: Container(
                    width: 40,
                    height: 40,

                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),

                    child: const Center(
                      child: Text(
                        "X",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonThreeGameTwo extends StatefulWidget {
  final UserModel user;

  const LessonThreeGameTwo({super.key, required this.user});

  @override
  State<LessonThreeGameTwo> createState() => _LessonThreeGameTwoState();
}

class _LessonThreeGameTwoState extends State<LessonThreeGameTwo> {
  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void showHiddenPopup(String image) {
    showDialog(
      context: context,
      builder: (_) => HiddenPopup(image: image, users: widget.user),
    );
  }

  Widget hiddenCircle({
    required double x,
    required double y,
    required double size,
    required double scale,
    required double offsetX,
    required double offsetY,
    required String popupImage,
  }) {
    return Positioned(
      left: offsetX + (x * scale) - ((size * scale) / 2),
      top: offsetY + (y * scale) - ((size * scale) / 2),

      child: GestureDetector(
        onTap: () {
          showHiddenPopup(popupImage);
        },

        child: Container(
          width: size * scale,
          height: size * scale,

          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenW = constraints.maxWidth;
          final screenH = constraints.maxHeight;

          const imageW = 1024.0;
          const imageH = 1792.0;

          final scale = (screenW / imageW > screenH / imageH)
              ? screenW / imageW
              : screenH / imageH;

          final displayW = imageW * scale;
          final displayH = imageH * scale;

          final offsetX = (screenW - displayW) / 2;
          final offsetY = (screenH - displayH) / 2;

          return Stack(
            children: [
              /// BACKGROUND
              Positioned.fill(
                child: Image.asset(
                  'assets/lesson-three-game2.png',
                  fit: BoxFit.cover,
                ),
              ),

              /// HIDDEN 1
              hiddenCircle(
                x: 410,
                y: 556,
                size: 70,
                scale: scale,
                offsetX: offsetX,
                offsetY: offsetY,
                popupImage: "assets/lesson-three-game2b.png",
              ),

              /// HIDDEN 2
              hiddenCircle(
                x: 500,
                y: 1054,
                size: 70,
                scale: scale,
                offsetX: offsetX,
                offsetY: offsetY,
                popupImage: "assets/lesson-three-game2d.png",
              ),

              /// HIDDEN 3
              hiddenCircle(
                x: 586,
                y: 1138,
                size: 70,
                scale: scale,
                offsetX: offsetX,
                offsetY: offsetY,
                popupImage: "assets/lesson-three-game2c.png",
              ),

              /// HIDDEN 4
              hiddenCircle(
                x: 110,
                y: 1260,
                size: 50,
                scale: scale,
                offsetX: offsetX,
                offsetY: offsetY,
                popupImage: "assets/lesson-three-game2a.png",
              ),

              /// HOME BUTTON
              Positioned(
                top: clampDouble(screenH * 0.025, 14, 22),

                right: clampDouble(screenW * 0.04, 12, 20),

                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Lesson3Screen(user: widget.user),
                      ),
                    );
                  },

                  child: Container(
                    width: clampDouble(screenW * 0.14, 50, 70),

                    height: clampDouble(screenW * 0.14, 50, 70),

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

                      size: clampDouble(screenW * 0.08, 28, 40),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
