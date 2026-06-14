import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/lesson4.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonFourDayTwoActThree extends StatefulWidget {
  final UserModel user;

  const LessonFourDayTwoActThree({super.key, required this.user});

  @override
  State<LessonFourDayTwoActThree> createState() =>
      _LessonFourDayTwoActThreeState();
}

class _LessonFourDayTwoActThreeState extends State<LessonFourDayTwoActThree> {
  int score = 0;

  static const double designW = 690;
  static const double designH = 1034;

  final Map<String, String> correctAnswers = {
    'Maginoo': 'assets/maginoo_card.png',
    'Maharlika': 'assets/maharlika_card.png',
    'Timawa': 'assets/timawa_card.png',
    'Alipin': 'assets/alipin_card.png',
  };

  final Map<String, String?> placedCards = {
    'Maginoo': null,
    'Maharlika': null,
    'Timawa': null,
    'Alipin': null,
  };

  void placeCard(String house, String image) {
    setState(() {
      placedCards.updateAll((key, value) {
        if (value == image) return null;
        return value;
      });
      placedCards[house] = image;
    });
  }

  void submitAnswers() {
    int total = 0;

    placedCards.forEach((house, image) {
      if (image == correctAnswers[house]) {
        total += 5;
      }
    });

    setState(() => score = total);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Resulta'),
        content: Text('Nakakuha ka ng $total puntos!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
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
      onTap: onTap,
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                draggableCard('assets/maginoo_card.png'),
                draggableCard('assets/maharlika_card.png'),
                draggableCard('assets/timawa_card.png'),
                draggableCard('assets/alipin_card.png'),
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
