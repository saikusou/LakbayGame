import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson2.dart';
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

class CongratsPopup extends StatelessWidget {
  const CongratsPopup({super.key});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: clampDouble(size.width * 0.85, 280, 390),
        padding: EdgeInsets.symmetric(
          horizontal: clampDouble(size.width * 0.06, 18, 28),
          vertical: clampDouble(size.height * 0.035, 22, 35),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3D6),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.orange, width: 5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: clampDouble(size.width * 0.20, 70, 95),
            ),
            SizedBox(height: clampDouble(size.height * 0.015, 10, 18)),
            Text(
              "Congratulations!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: clampDouble(size.width * 0.075, 25, 34),
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: clampDouble(size.height * 0.015, 10, 18)),
            Text(
              "50 points total",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: clampDouble(size.width * 0.055, 20, 26),
                fontWeight: FontWeight.w700,
                color: Colors.orange.shade900,
              ),
            ),
            SizedBox(height: clampDouble(size.height * 0.03, 20, 30)),
            SizedBox(
              width: double.infinity,
              height: clampDouble(size.height * 0.065, 48, 60),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "OK",
                  style: TextStyle(
                    fontSize: clampDouble(size.width * 0.045, 16, 22),
                    fontWeight: FontWeight.bold,
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

class LessonTwoDayOneActThree extends StatefulWidget {
  final UserModel user;

  const LessonTwoDayOneActThree({super.key, required this.user});

  @override
  State<LessonTwoDayOneActThree> createState() =>
      _LessonTwoDayOneActThreeState();
}

class _LessonTwoDayOneActThreeState extends State<LessonTwoDayOneActThree> {
  final Set<int> clickedHiddenCircles = {};
  bool congratulationsShown = false;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  Future<void> showHiddenPopup(int id, String image) async {
    if (!clickedHiddenCircles.contains(id)) {
      setState(() {
        clickedHiddenCircles.add(id);
      });
    }

    await showDialog(
      context: context,
      builder: (_) => HiddenPopup(image: image, users: widget.user),
    );

    if (clickedHiddenCircles.length == 7 && !congratulationsShown) {
      congratulationsShown = true;

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const CongratsPopup(),
      );
    }
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

          final scaleX = screenW / imageW;
          final scaleY = screenH / imageH;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/lesson-two-day1-act3m.png',
                  fit: BoxFit.fill,
                ),
              ),

              hiddenCircle(
                id: 1,
                x: 495,
                y: 1238,
                size: 190,
                scaleX: scaleX,
                scaleY: scaleY,
                popupImage: "assets/lesson-two-day1-act3-pic1.png",
              ),

              hiddenCircle(
                id: 2,
                x: 240,
                y: 1084,
                size: 190,
                scaleX: scaleX,
                scaleY: scaleY,
                popupImage: "assets/lesson-two-day1-act3-pic2.png",
              ),

              hiddenCircle(
                id: 3,
                x: 799,
                y: 1138,
                size: 190,
                scaleX: scaleX,
                scaleY: scaleY,
                popupImage: "assets/lesson-two-day1-act3-pic3.png",
              ),

              hiddenCircle(
                id: 4,
                x: 350,
                y: 1310,
                size: 150,
                scaleX: scaleX,
                scaleY: scaleY,
                popupImage: "assets/lesson-two-day1-act3-pic4.png",
              ),

              hiddenCircle(
                id: 5,
                x: 230,
                y: 1550,
                size: 160,
                scaleX: scaleX,
                scaleY: scaleY,
                popupImage: "assets/lesson-two-day1-act3-pic5.png",
              ),

              hiddenCircle(
                id: 6,
                x: 700,
                y: 1550,
                size: 160,
                scaleX: scaleX,
                scaleY: scaleY,
                popupImage: "assets/lesson-two-day1-act3-pic6.png",
              ),

              hiddenCircle(
                id: 7,
                x: 880,
                y: 1350,
                size: 140,
                scaleX: scaleX,
                scaleY: scaleY,
                popupImage: "assets/lesson-two-day1-act3-pic7.png",
              ),

              Positioned(
                top: clampDouble(screenH * 0.025, 14, 22),
                right: clampDouble(screenW * 0.04, 12, 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Lesson2Screen(user: widget.user),
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
