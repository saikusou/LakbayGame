import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-two/act1.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-two/act3.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-two/act4.dart';
import 'package:lakbay_game/models/user_model.dart';

class Day2Popup extends StatelessWidget {
  final String title;
  final UserModel user;

  const Day2Popup({super.key, required this.title, required this.user});

  @override
  Widget build(BuildContext context) {
    if (title.contains('Learning Objectives')) {
      return ImagePopup(imagePath: 'assets/lesson-two-day1-act1.png');
    }

    if (title.contains('Fact O Kuwento')) {
      return ImagePopup(
        imagePath: 'assets/lesson-two-day1-act2.png',
        buttonText: 'NEXT',
        onButtonTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonOneDayTwoActTwo(user: user),
            ),
          );
        },
      );
    }

    if (title.contains('Crack the Code')) {
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LessonOneDayTwoActThree(user: user),
          ),
        );
      });

      return const SizedBox.shrink();
    }

    if (title.contains('Pagtataya')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LessonOneDayTwoActFour(user: user)),
        );
      });

      return const SizedBox.shrink();
    }

    if (title.contains('Takdang Aralin')) {
      return ImagePopup(imagePath: 'assets/lesson-two-day2-act5.png');
    }

    return const SizedBox();
  }
}

/// =========================================================
/// REUSABLE IMAGE POPUP
/// =========================================================

class ImagePopup extends StatelessWidget {
  final String imagePath;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const ImagePopup({
    super.key,
    required this.imagePath,
    this.buttonText,
    this.onButtonTap,
  });

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
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            buildCloseButton(context),

            const Spacer(),

            if (buttonText != null && onButtonTap != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: buildTextButton(),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCloseButton(BuildContext context) {
    return Align(
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
            child: const Icon(Icons.close, color: Colors.white, size: 26),
          ),
        ),
      ),
    );
  }

  Widget buildTextButton() {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        width: 90,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          buttonText!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
