import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson4.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

class LessonFourDayTwoActThree extends StatefulWidget {
  final UserModel user;

  const LessonFourDayTwoActThree({super.key, required this.user});

  @override
  State<LessonFourDayTwoActThree> createState() =>
      _LessonFourDayTwoActThreeState();
}

class _LessonFourDayTwoActThreeState extends State<LessonFourDayTwoActThree> {
  int score = 0;
  bool isSaving = false;
  bool alreadySubmitted = false;

  static const double designW = 690;
  static const double designH = 1034;

  final Map<String, String> correctAnswers = {
    'Maginoo': 'assets/MAGINOO.jpg',
    'Maharlika': 'assets/MAHARLIKA.jpg',
    'Timawa': 'assets/TIMAWA.jpg',
    'Alipin': 'assets/ALIPIN.jpg',
  };

  final Map<String, String?> placedCards = {
    'Maginoo': null,
    'Maharlika': null,
    'Timawa': null,
    'Alipin': null,
  };

  Future<void> handleSavePoints({required int totalScore}) async {
    await ApiService.savePoints(
      userId: widget.user.id,
      countedPoints: totalScore,
      lesson: 'Lesson 4',
      day: 'Day 2',
      act: 'Act 3',
    );
  }

  void placeCard(String house, String image) {
    if (isSaving) return;

    setState(() {
      alreadySubmitted = false;

      placedCards.updateAll((key, value) {
        if (value == image) return null;
        return value;
      });

      placedCards[house] = image;
    });
  }

  Future<void> submitAnswers() async {
    if (isSaving || alreadySubmitted) return;

    int total = 0;

    placedCards.forEach((house, image) {
      if (image == correctAnswers[house]) {
        total += 5;
      }
    });

    setState(() {
      score = total;
      isSaving = true;
    });

    try {
      await handleSavePoints(totalScore: total);

      if (!mounted) return;

      setState(() {
        isSaving = false;
        alreadySubmitted = true;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Resulta'),
          content: Text('Nakakuha ka ng $total puntos!\nNa-save na ang score.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Hindi na-save ang score.\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void resetGame() {
    if (isSaving) return;

    setState(() {
      score = 0;
      alreadySubmitted = false;
      placedCards.updateAll((key, value) => null);
    });
  }

  Widget circleButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isSaving ? null : onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      ),
    );
  }

  Widget dropBox({
    required String house,
    required double left,
    required double top,
    required double width,
    required double height,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: DragTarget<String>(
        onAcceptWithDetails: (details) {
          placeCard(house, details.data);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            color: Colors.transparent,
            child: placedCards[house] == null
                ? null
                : Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      placedCards[house]!,
                      fit: BoxFit.contain,
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget draggableCard(String image) {
    final bool alreadyPlaced = placedCards.containsValue(image);

    if (alreadyPlaced) {
      return Opacity(opacity: 0.25, child: cardImage(image));
    }

    return Draggable<String>(
      data: image,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 85, height: 85, child: cardImage(image)),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: cardImage(image)),
      child: cardImage(image),
    );
  }

  Widget cardImage(String image) {
    return Container(
      width: 82,
      height: 82,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Image.asset(image, fit: BoxFit.contain),
    );
  }

  Widget actionButton({required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: 95,
      height: 38,
      child: ElevatedButton(
        onPressed: isSaving ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.orange.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isSaving && text == 'Isumite'
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget gameCanvas() {
    final double size = 55;
    final double sidePadding = 15;
    final double iconTop = 15;

    return SizedBox(
      width: designW,
      height: designH,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/lesson-four-day2-act3.png',
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
            top: iconTop,
            right: sidePadding,
            child: circleButton(
              icon: Icons.home,
              color: Colors.orange,
              size: size,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Lesson4Screen(user: widget.user),
                  ),
                );
              },
            ),
          ),

          dropBox(house: 'Maginoo', left: 42, top: 560, width: 176, height: 94),
          dropBox(
            house: 'Maharlika',
            left: 470,
            top: 560,
            width: 176,
            height: 94,
          ),
          dropBox(house: 'Timawa', left: 43, top: 846, width: 176, height: 92),
          dropBox(house: 'Alipin', left: 470, top: 846, width: 176, height: 92),

          Positioned(
            left: 130,
            right: 130,
            bottom: 28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                draggableCard('assets/MAGINOO.jpg'),
                draggableCard('assets/MAHARLIKA.jpg'),
                draggableCard('assets/TIMAWA.jpg'),
                draggableCard('assets/ALIPIN.jpg'),
              ],
            ),
          ),

          Positioned(
            left: 10,
            bottom: 22,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                'Puntos: $score',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          Positioned(
            right: 10,
            bottom: 15,
            child: Column(
              children: [
                actionButton(text: 'Isumite', onPressed: submitAnswers),
                const SizedBox(height: 6),
                actionButton(text: 'Ulitin', onPressed: resetGame),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: FittedBox(fit: BoxFit.contain, child: gameCanvas()),
        ),
      ),
    );
  }
}
