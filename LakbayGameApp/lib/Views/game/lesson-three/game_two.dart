import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/models/user_model.dart';

class HiddenPopup extends StatelessWidget {
  final UserModel users;
  final String image;

  const HiddenPopup({super.key, required this.image, required this.users});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final popupW = clampDouble(size.width * 0.86, 280, 380);
    final popupH = clampDouble(size.height * 0.62, 360, 520);
    final closeSize = clampDouble(size.width * 0.10, 34, 45);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: clampDouble(size.width * 0.04, 12, 24),
        vertical: clampDouble(size.height * 0.03, 12, 28),
      ),
      child: Container(
        width: popupW,
        height: popupH,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
          border: Border.all(
            color: Colors.orange,
            width: clampDouble(size.width * 0.012, 3, 5),
          ),
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(clampDouble(size.width * 0.025, 7, 12)),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: closeSize,
                height: closeSize,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Center(
                  child: Text(
                    "X",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: clampDouble(size.width * 0.05, 16, 22),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
  final Set<int> clickedHiddenImages = {};
  bool congratulationsShown = false;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  Future<void> showHiddenPopup(int id, String image) async {
    if (!clickedHiddenImages.contains(id)) {
      setState(() {
        clickedHiddenImages.add(id);
      });
    }

    await showDialog(
      context: context,
      builder: (_) => HiddenPopup(image: image, users: widget.user),
    );

    if (clickedHiddenImages.length == 4 && !congratulationsShown) {
      congratulationsShown = true;
      showCongratulationsPopup();
    }
  }

  void showCongratulationsPopup() {
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: clampDouble(size.width * 0.82, 280, 380),
            padding: EdgeInsets.all(clampDouble(size.width * 0.06, 18, 28)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D6),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.orange, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Congratulations!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.075, 24, 34),
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Nahanap mo ang lahat ng hidden images!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.045, 16, 20),
                    fontWeight: FontWeight.w600,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "+20 Points",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.07, 24, 32),
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Lesson3Screen(user: widget.user),
                      ),
                    );
                  },
                  child: Container(
                    width: clampDouble(size.width * 0.36, 130, 170),
                    height: clampDouble(size.height * 0.055, 42, 52),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: clampDouble(size.width * 0.045, 16, 20),
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget hiddenCircle({
    required int id,
    required double x,
    required double y,
    required double size,
    required double scaleX,
    required double scaleY,
    required String popupImage,
  }) {
    final circleWidth = size * scaleX;
    final circleHeight = size * scaleY;

    return Positioned(
      left: (x * scaleX) - (circleWidth / 2),
      top: (y * scaleY) - (circleHeight / 2),
      child: GestureDetector(
        onTap: () => showHiddenPopup(id, popupImage),
        child: Container(
          width: circleWidth,
          height: circleHeight,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(0, 90, 11, 11),
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

          final scaleX = screenW / imageW;
          final scaleY = screenH / imageH;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/lesson-three-game2.png',
                  fit: BoxFit.fill,
                ),
              ),

              hiddenCircle(
                id: 1,
                x: 389,
                y: 565,
                size: 90,
                scaleX: scaleX,
                scaleY: scaleY,
                popupImage: "assets/lesson-three-game2b.png",
              ),

              hiddenCircle(
                id: 2,
                x: 500,
                y: 1054,
                size: 70,
                scaleX: scaleX,
                scaleY: scaleY,
                popupImage: "assets/lesson-three-game2d.png",
              ),

              hiddenCircle(
                id: 3,
                x: 599,
                y: 1138,
                size: 70,
                scaleX: scaleX,
                scaleY: scaleY,
                popupImage: "assets/lesson-three-game2c.png",
              ),

              hiddenCircle(
                id: 4,
                x: 30,
                y: 1260,
                size: 70,
                scaleX: scaleX,
                scaleY: scaleY,
                popupImage: "assets/lesson-three-game2a.png",
              ),

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
                      border: Border.all(
                        color: const Color.fromARGB(255, 105, 69, 69),
                        width: 4,
                      ),
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
