import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-two/act1.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-two/act3.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-two/act4.dart';
import 'package:lakbay_game/User/models/user_model.dart';

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

    final popupHeight = clampDouble(size.height * 0.80, 450, 650);
    final popupWidth = clampDouble(size.width * 0.90, 350, 550);

    final hasButton = buttonText != null && onButtonTap != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Container(
        width: popupWidth,
        height: popupHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.blue, width: 5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Image not found',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      child: buildCloseButton(context),
                    ),
                  ],
                ),
              ),

              if (hasButton)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.black12, width: 1),
                    ),
                  ),
                  child: Center(child: buildTextButton()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 26),
      ),
    );
  }

  Widget buildTextButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onButtonTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          constraints: const BoxConstraints(minWidth: 120),
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 3),
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
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
