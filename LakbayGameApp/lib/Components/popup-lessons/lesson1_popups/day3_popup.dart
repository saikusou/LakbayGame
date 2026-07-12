import 'package:flutter/material.dart';

import 'package:lakbay_game/Views/game/lesson-one/day-three/act2.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-three/act3.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-three/act4.dart';
import 'package:lakbay_game/Views/game/lesson-one/day-three/act5.dart';
import 'package:lakbay_game/User/models/user_model.dart';

/// Closes the current popup/dialog before opening the activity page.
///
/// Do not use pushReplacement directly from inside the dialog because the
/// dialog is its own route. Closing it first prevents the modal from remaining
/// visible above the new page.
void closePopupAndOpenPage(BuildContext context, Widget page) {
  final NavigatorState navigator = Navigator.of(context, rootNavigator: true);

  // Close the popup first.
  if (navigator.canPop()) {
    navigator.pop();
  }

  // Open the new page after the popup route has been removed.
  Future.microtask(() {
    navigator.push(MaterialPageRoute(builder: (_) => page));
  });
}

class Day3Popup extends StatelessWidget {
  final String title;
  final UserModel user;

  const Day3Popup({super.key, required this.title, required this.user});

  @override
  Widget build(BuildContext context) {
    /// 1. LEARNING OBJECTIVES
    if (title.contains('Learning Objectives')) {
      return _LearningObjectivesPopup(user: user);
    }

    /// 2. TUKUYIN ANG EBIDENSYA
    if (title.contains('Tukuyin ang Ebidensya')) {
      return ImagePopup(
        imagePath: 'assets/lesson-two-day3-act2.png',
        buttonText: 'NEXT',
        onButtonTap: () {
          closePopupAndOpenPage(context, LessonOneDayThreeActTwo(user: user));
        },
      );
    }

    /// 3. GROUP MISSION
    if (title.contains('Lakbay Ground')) {
      return _GroupPopup(user: user);
    }

    /// 4. TAMA O MALI
    if (title.contains('Tama o Mali')) {
      return _TamaOMaliPopup(user: user);
    }

    /// 5. PAGSUSURI
    if (title.contains('Pagsusuri')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        closePopupAndOpenPage(context, LessonOneDayThreeActFour(user: user));
      });

      return const SizedBox.shrink();
    }

    /// 6. TAKDANG ARALIN
    if (title.contains('Takdang Aralin')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        closePopupAndOpenPage(context, LessonOneDayThreeActFive(user: user));
      });

      return const SizedBox.shrink();
    }

    return const SizedBox.shrink();
  }
}

/// =========================================================
/// LEARNING OBJECTIVES POPUP
/// =========================================================
class _LearningObjectivesPopup extends StatelessWidget {
  final UserModel user;

  const _LearningObjectivesPopup({required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    final double popupHeight = clampDouble(screenSize.height * 0.75, 450, 500);

    final double popupWidth = clampDouble(screenSize.width * 0.90, 300, 550);

    final double closeButtonSize = clampDouble(popupWidth * 0.09, 40, 46);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: Container(
        width: popupWidth,
        height: popupHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.blue, width: 5),
          image: const DecorationImage(
            image: AssetImage('assets/lesson-two-day3-act1.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: _CloseButton(size: closeButtonSize),
            ),
          ],
        ),
      ),
    );
  }
}

/// =========================================================
/// GROUP MISSION POPUP
/// =========================================================
class _GroupPopup extends StatelessWidget {
  final UserModel user;

  const _GroupPopup({required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void _openActivity(BuildContext context) {
    closePopupAndOpenPage(context, LessonOneDayThreeActThree(user: user));
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    final double popupHeight = clampDouble(screenSize.height * 0.75, 450, 530);

    final double popupWidth = clampDouble(screenSize.width * 0.90, 300, 550);

    final double closeButtonSize = clampDouble(popupWidth * 0.09, 40, 46);

    final double submitButtonSize = clampDouble(popupWidth * 0.12, 50, 58);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: Container(
        width: popupWidth,
        height: popupHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.blue, width: 5),
          image: const DecorationImage(
            image: AssetImage('assets/lesson-one-day3-act3.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: _CloseButton(size: closeButtonSize),
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: _CircularNextButton(
                  size: submitButtonSize,
                  onTap: () => _openActivity(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =========================================================
/// TAMA O MALI POPUP
/// =========================================================
class _TamaOMaliPopup extends StatelessWidget {
  final UserModel user;

  const _TamaOMaliPopup({required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void _openActivity(BuildContext context) {
    closePopupAndOpenPage(context, LessonOneDayThreeActFour(user: user));
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    final double popupHeight = clampDouble(screenSize.height * 0.75, 450, 530);

    final double popupWidth = clampDouble(screenSize.width * 0.90, 300, 550);

    final double closeButtonSize = clampDouble(popupWidth * 0.09, 40, 46);

    final double submitButtonSize = clampDouble(popupWidth * 0.12, 50, 58);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: Container(
        width: popupWidth,
        height: popupHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.blue, width: 5),
          image: const DecorationImage(
            image: AssetImage('assets/lesson-three-day1-act4.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: _CloseButton(size: closeButtonSize),
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: _CircularNextButton(
                  size: submitButtonSize,
                  onTap: () => _openActivity(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
    final Size screenSize = MediaQuery.sizeOf(context);

    final double popupHeight = clampDouble(screenSize.height * 0.80, 450, 650);

    final double popupWidth = clampDouble(screenSize.width * 0.90, 300, 550);

    final double closeButtonSize = clampDouble(popupWidth * 0.09, 40, 46);

    final bool hasButton =
        buttonText != null &&
        buttonText!.trim().isNotEmpty &&
        onButtonTap != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Container(
        width: popupWidth,
        height: popupHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.blue, width: 5),
        ),
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
                        errorBuilder:
                            (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
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
                    child: _CloseButton(size: closeButtonSize),
                  ),
                ],
              ),
            ),

            /// The button has its own area below the image.
            /// This prevents it from covering the image content.
            if (hasButton)
              SafeArea(
                top: false,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.black12, width: 1),
                    ),
                  ),
                  child: Center(
                    child: _PopupTextButton(
                      text: buttonText!,
                      onTap: onButtonTap!,
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

/// =========================================================
/// REUSABLE CLOSE BUTTON
/// =========================================================
class _CloseButton extends StatelessWidget {
  final double size;

  const _CloseButton({required this.size});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
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
          child: Icon(Icons.close, color: Colors.white, size: size * 0.58),
        ),
      ),
    );
  }
}

/// =========================================================
/// REUSABLE CIRCULAR NEXT BUTTON
/// =========================================================
class _CircularNextButton extends StatelessWidget {
  final double size;
  final VoidCallback onTap;

  const _CircularNextButton({required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.green,
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
          child: Icon(Icons.send, color: Colors.white, size: size * 0.50),
        ),
      ),
    );
  }
}

/// =========================================================
/// REUSABLE TEXT BUTTON
/// =========================================================
class _PopupTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PopupTextButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
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
            text,
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
