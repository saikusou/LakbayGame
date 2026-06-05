import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/side_navigation.dart';
import 'package:lakbay_game/Views/profile.dart';

/// POPUPS
import 'package:lakbay_game/Components/popup-lessons/lesson3_popups/day1_popup.dart';
import 'package:lakbay_game/Components/popup-lessons/lesson3_popups/day2_popup.dart';
import 'package:lakbay_game/Components/popup-lessons/lesson3_popups/day3_popup.dart';
import 'package:lakbay_game/Components/popup-lessons/lesson3_popups/day4_popup.dart';

class Lesson3Screen extends StatefulWidget {
  const Lesson3Screen({super.key});

  @override
  State<Lesson3Screen> createState() => _Lesson3ScreenState();
}

class _Lesson3ScreenState extends State<Lesson3Screen> {
  bool showMenu = false;

  /// KEEP STONE HIGHLIGHTED
  int? selectedDay;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void toggleMenu() {
    setState(() {
      showMenu = !showMenu;
    });
  }

  /// =========================================================
  /// OPEN CONTENT POPUP
  /// =========================================================
  Future<void> showLessonPopup({
    required BuildContext context,
    required int dayNumber,
    required String title,
  }) async {
    Widget popup;

    switch (dayNumber) {
      case 1:
        popup = Day1Popup(title: title);
        break;

      case 2:
        popup = Day2Popup(title: title);
        break;

      case 3:
        popup = Day3Popup(title: title);
        break;

      case 4:
        popup = Day4Popup(title: title);
        break;

      default:
        popup = Day1Popup(title: title);
    }

    /// CLOSE DAY MENU POPUP
    Navigator.pop(context);

    /// OPEN CONTENT POPUP
    await showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (_) => popup,
    );

    /// REOPEN DAY MENU POPUP
    if (mounted) {
      showDayModal(context: this.context, dayNumber: dayNumber);
    }
  }

  /// =========================================================
  /// DAY MODAL
  /// =========================================================
  void showDayModal({required BuildContext context, required int dayNumber}) {
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
          {"icon": Icons.extension, "title": "2. GAWAIN 1:Hularawan"},
          {"icon": Icons.lightbulb, "title": "3. Konsepto"},
          {"icon": Icons.check_circle, "title": "4. Tama o Mali"},
          {"icon": Icons.assignment, "title": "5. Takdang Aralin"},
        ];
        break;

      case 2:
        title = "Ikalawang Araw";
        headerImage = 'assets/stone-2.png';

        contents = [
          {"icon": Icons.menu_book, "title": "1. Learning Objectives"},
          {"icon": Icons.quiz, "title": "2. GAWAIN 2: Ilaya o Ilawud"},
          {"icon": Icons.groups, "title": "3. Presentasyon"},
          {"icon": Icons.assignment, "title": "4. Katanungan"},
          {"icon": Icons.assignment, "title": "5. Takdang Aralin"},
        ];
        break;

      case 3:
        title = "Ikatlong Araw";
        headerImage = 'assets/stone-3.png';

        contents = [
          {"icon": Icons.history_edu, "title": "1. Learning Objectives"},
          {"icon": Icons.public, "title": "2. GAWAIN 3: Kilalanin Mo Ako!"},
          {"icon": Icons.school, "title": "3. Ang Aking Pamilya sa Pamayanan"},
          {"icon": Icons.edit, "title": "4. Katanungan"},
          {"icon": Icons.assignment, "title": "5. Takdang Aralin"},
        ];
        break;

      case 4:
        title = "Ika-apat na Araw";
        headerImage = 'assets/stone-4.png';

        contents = [
          {"icon": Icons.star, "title": "1. Learning Objectives"},
          {"icon": Icons.workspace_premium, "title": "2. Pagsusulit"},
          {"icon": Icons.edit, "title": "3. Katanungan"},
          {"icon": Icons.assignment, "title": "4. Takdang Aralin"},
        ];
        break;
    }

    showDialog(
      context: context,
      builder: (context) {
        final size = MediaQuery.of(context).size;

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
                    /// CLOSE BUTTON
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
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

                    /// HEADER IMAGE
                    Image.asset(headerImage, height: 90, fit: BoxFit.contain),

                    const SizedBox(height: 10),

                    /// TITLE
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// LESSON BUTTONS
                    ...contents.map(
                      (item) => buildLessonButton(
                        icon: item["icon"],
                        title: item["title"],
                        onTap: () async {
                          await showLessonPopup(
                            context: context,
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
      setState(() {
        selectedDay = null;
      });
    });
  }

  /// =========================================================
  /// LESSON BUTTON
  /// =========================================================
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

  /// =========================================================
  /// PROFILE BOX
  /// =========================================================
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
                      "Guest_668013",
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
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

  /// =========================================================
  /// MENU BUTTON
  /// =========================================================
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

  /// =========================================================
  /// STONES
  /// =========================================================
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
          showDayModal(context: context, dayNumber: dayNumber);
        },
      ),
    );
  }

  /// =========================================================
  /// MAIN BUILD
  /// =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.asset('assets/lesson3.png', fit: BoxFit.fill),
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

/// =========================================================
/// STONE IMAGE
/// =========================================================
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
        setState(() {
          isHovering = true;
        });
      },

      onExit: (_) {
        setState(() {
          isHovering = false;
        });
      },

      child: GestureDetector(
        onTap: widget.onTap,

        onTapDown: (_) {
          setState(() {
            isPressed = true;
          });
        },

        onTapUp: (_) {
          setState(() {
            isPressed = false;
          });
        },

        onTapCancel: () {
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
