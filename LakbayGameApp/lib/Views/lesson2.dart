import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/side_navigation.dart';
import 'package:lakbay_game/Views/profile.dart';

/// POPUPS
import 'package:lakbay_game/Components/popup-lessons/lesson2_popups/day1_popup.dart';

import 'package:lakbay_game/models/user_model.dart';

import '../Components/popup-lessons/lesson2_popups/day2_popup.dart';
import '../Components/popup-lessons/lesson2_popups/day3_popup.dart';
import '../Components/popup-lessons/lesson2_popups/day4_popup.dart';

class Lesson2Screen extends StatefulWidget {
  final UserModel user;

  const Lesson2Screen({super.key, required this.user});

  @override
  State<Lesson2Screen> createState() => _Lesson2ScreenState();
}

class _Lesson2ScreenState extends State<Lesson2Screen> {
  bool showMenu = false;
  int? selectedDay;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void toggleMenu() {
    if (!mounted) return;

    setState(() {
      showMenu = !showMenu;
    });
  }

  Widget getPopup({required int dayNumber, required String title}) {
    switch (dayNumber) {
      case 1:
        return Day1Popup(title: title, user: widget.user);
      case 2:
        return Day2Popup(title: title, user: widget.user);
      case 3:
        return Day3Popup(title: title, user: widget.user);
      case 4:
        return Day4Popup(title: title, user: widget.user);
      default:
        return Day1Popup(title: title, user: widget.user);
    }
  }

  Future<void> showLessonPopup({
    required BuildContext dialogContext,
    required int dayNumber,
    required String title,
  }) async {
    if (!mounted) return;

    final popup = getPopup(dayNumber: dayNumber, title: title);

    Navigator.of(dialogContext).pop();

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => popup,
    );

    if (!mounted) return;

    showDayModal(dayNumber: dayNumber);
  }

  void showDayModal({required int dayNumber}) {
    if (!mounted) return;

    setState(() {
      selectedDay = dayNumber;
    });

    List<Map<String, dynamic>> contents = [];
    String headerImage = '';
    String title = '';

    switch (dayNumber) {
      case 1:
        title = "Unang Araw";
        headerImage = 'assets/stone-1.png';
        contents = [
          {"icon": Icons.track_changes, "title": "1. Learning Objectives"},
          {"icon": Icons.extension, "title": "2. Ayusin mo ako!"},
          {"icon": Icons.lightbulb, "title": "3. Picture mining"},
          {"icon": Icons.check_circle, "title": "4. Subukan natin partner"},
          {"icon": Icons.assignment, "title": "5. Takdang Aralin"},
        ];
        break;

      case 2:
        title = "Ikalawang Araw";
        headerImage = 'assets/stone-2.png';
        contents = [
          {"icon": Icons.menu_book, "title": "1. Learning Objectives"},
          {"icon": Icons.quiz, "title": "2. I-Konek mo ako"},
          {"icon": Icons.groups, "title": "3. Picture mining"},
          {"icon": Icons.assignment, "title": "4. Piliin ang tamang panahon"},
          {"icon": Icons.assignment, "title": "5. Takdang Aralin"},
        ];
        break;

      case 3:
        title = "Ikatlong Araw";
        headerImage = 'assets/stone-3.png';
        contents = [
          {"icon": Icons.history_edu, "title": "1. Learning Objectives"},
          {"icon": Icons.public, "title": "2. Tama o Mali E-React Mo"},
          {"icon": Icons.public, "title": "3. Guhit mo Ibahagi mo"},
          {"icon": Icons.edit, "title": "4. Pagninilay"},
          {"icon": Icons.edit, "title": "5. Takdang Aralin"},
        ];
        break;

      case 4:
        title = "Ika-apat na Araw";
        headerImage = 'assets/stone-4.png';
        contents = [
          {"icon": Icons.star, "title": "1. Learning Objectives"},
          {"icon": Icons.workspace_premium, "title": "2. Pagsusulit"},
          {"icon": Icons.edit, "title": "3. Pagninilay"},
          {"icon": Icons.assignment, "title": "4. Takdang Aralin"},
        ];
        break;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(14),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 380,
              maxHeight: size.height * 0.82,
            ),
            child: SingleChildScrollView(
              child: Container(
                width: size.width * 0.88,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.brown, width: 4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),

                    Image.asset(headerImage, height: 90, fit: BoxFit.contain),

                    const SizedBox(height: 10),

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...contents.map(
                      (item) => buildLessonButton(
                        icon: item["icon"],
                        title: item["title"],
                        onTap: () async {
                          await showLessonPopup(
                            dialogContext: dialogContext,
                            dayNumber: dayNumber,
                            title: item["title"],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      if (!mounted) return;

      setState(() {
        selectedDay = null;
      });
    });
  }

  Widget buildLessonButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF6C8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.brown, width: 2),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.green,
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.brown,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileBox(double width, double height) {
    return Positioned(
      top: height * 0.02,
      left: width * 0.03,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.01,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: clampDouble(width * 0.055, 18, 24),
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: width * 0.025),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: clampDouble(width * 0.032, 11, 14),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "202,000",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: clampDouble(width * 0.032, 11, 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: height * 0.015),

          GestureDetector(
            onTap: () {
              if (!mounted) return;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(user: widget.user),
                ),
              );
            },
            child: Container(
              width: clampDouble(width * 0.13, 45, 58),
              height: clampDouble(width * 0.13, 45, 58),
              decoration: BoxDecoration(
                color: const Color(0xFF8B2905),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: clampDouble(width * 0.055, 20, 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton(double width, double height) {
    return Positioned(
      top: height * 0.02,
      right: width * 0.04,
      child: GestureDetector(
        onTap: toggleMenu,
        child: Container(
          width: clampDouble(width * 0.12, 44, 55),
          height: clampDouble(width * 0.12, 44, 55),
          decoration: BoxDecoration(
            color: const Color(0xFF8B2905),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            showMenu ? Icons.close : Icons.menu,
            color: Colors.white,
            size: clampDouble(width * 0.075, 26, 34),
          ),
        ),
      ),
    );
  }

  Widget buildStone({
    required double bottom,
    required double left,
    required double width,
    required String imagePath,
    required int dayNumber,
  }) {
    return Positioned(
      bottom: bottom,
      left: left,
      child: DayStoneImage(
        imagePath: imagePath,
        width: width,
        isSelected: selectedDay == dayNumber,
        onTap: () {
          showDayModal(dayNumber: dayNumber);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.asset('assets/lesson2.png', fit: BoxFit.fill),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;
                final width = constraints.maxWidth;

                final stoneWidth = clampDouble(width * 0.30, 85, 170);

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    buildProfileBox(width, height),
                    buildMenuButton(width, height),

                    buildStone(
                      bottom: height * 0.03,
                      left: width * 0.36,
                      width: stoneWidth,
                      imagePath: 'assets/stone-1.png',
                      dayNumber: 1,
                    ),

                    buildStone(
                      bottom: height * 0.17,
                      left: width * 0.20,
                      width: stoneWidth,
                      imagePath: 'assets/stone-2.png',
                      dayNumber: 2,
                    ),

                    buildStone(
                      bottom: height * 0.31,
                      left: width * 0.42,
                      width: stoneWidth,
                      imagePath: 'assets/stone-3.png',
                      dayNumber: 3,
                    ),

                    buildStone(
                      bottom: height * 0.45,
                      left: width * 0.25,
                      width: stoneWidth,
                      imagePath: 'assets/stone-4.png',
                      dayNumber: 4,
                    ),

                    SideNavigation(
                      width: width,
                      height: height,
                      showMenu: showMenu,
                      onBack: toggleMenu,
                      user: widget.user,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DayStoneImage extends StatefulWidget {
  final String imagePath;
  final double width;
  final bool isSelected;
  final VoidCallback onTap;

  const DayStoneImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<DayStoneImage> createState() => _DayStoneImageState();
}

class _DayStoneImageState extends State<DayStoneImage> {
  bool isHovering = false;
  bool isPressed = false;

  bool get isHighlighted => widget.isSelected || isHovering || isPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!mounted) return;

        setState(() {
          isHovering = true;
        });
      },
      onExit: (_) {
        if (!mounted) return;

        setState(() {
          isHovering = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) {
          if (!mounted) return;

          setState(() {
            isPressed = true;
          });
        },
        onTapUp: (_) {
          if (!mounted) return;

          setState(() {
            isPressed = false;
          });
        },
        onTapCancel: () {
          if (!mounted) return;

          setState(() {
            isPressed = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.9),
                      blurRadius: 30,
                      spreadRadius: 8,
                    ),
                  ]
                : [],
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 180),
            scale: isHighlighted ? 1.12 : 1.0,
            child: Image.asset(
              widget.imagePath,
              width: widget.width,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
