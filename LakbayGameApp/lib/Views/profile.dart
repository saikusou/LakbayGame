import 'package:flutter/material.dart';
import 'package:lakbay_game/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/Components/side_navigation.dart';
import 'package:lakbay_game/Views/lesson2.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/Views/lesson4.dart';
import 'package:lakbay_game/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showMenu = false;
  bool rewardPopupShown = false;
  int totalPoints = 0;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  void initState() {
    super.initState();

    loadTotalPoints();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkDailyReward();
    });
  }

  Future<void> loadTotalPoints() async {
    try {
      final points = await ApiService.getTotalPoints(widget.user.id!);

      if (mounted) {
        setState(() {
          totalPoints = points;
        });
      }
    } catch (e) {
      debugPrint('Error loading points: $e');
    }
  }

  Future<void> checkDailyReward() async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final today = "${now.year}-${now.month}-${now.day}";
    final lastShownDate = prefs.getString('daily_reward_date');

    if (lastShownDate != today && mounted) {
      showDailyRewardPopup();
    }
  }

  Future<void> claimDailyReward() async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final today = "${now.year}-${now.month}-${now.day}";

    await prefs.setString('daily_reward_date', today);

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reward Claimed!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void toggleMenu() {
    setState(() {
      showMenu = !showMenu;
    });
  }

  void showDailyRewardPopup() {
    if (rewardPopupShown) return;
    rewardPopupShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) {
        final size = MediaQuery.of(context).size;

        final popupWidth = clampDouble(size.width * 0.92, 300, 470);
        final popupHeight = clampDouble(size.height * 0.86, 500, 760);
        final closeSize = clampDouble(size.width * 0.10, 36, 48);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: SizedBox(
            width: popupWidth,
            height: popupHeight,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/floating-rewards.png',
                  width: popupWidth,
                  height: popupHeight,
                  fit: BoxFit.contain,
                ),

                /// CLAIM BUTTON SAME PLACE AS IMAGE BUTTON
                Positioned(
                  bottom: popupHeight * 0.04,
                  left: popupWidth * 0.30,
                  child: SizedBox(
                    width: popupWidth * 0.40,
                    height: popupHeight * 0.09,
                    child: ElevatedButton(
                      onPressed: claimDailyReward,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),

                Positioned(
                  top: popupHeight * 0.04,
                  right: popupWidth * 0.08,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: closeSize,
                      height: closeSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F5C8F),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: closeSize * 0.65,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      rewardPopupShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final levelWidth = clampDouble(size.width * 0.50, 190, 320);
    final imageHeight = clampDouble(size.height * 0.24, 180, 300);
    final starSize = clampDouble(size.width * 0.065, 20, 36);

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/profile.png', fit: BoxFit.cover),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;
                final width = constraints.maxWidth;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: height * 0.02,
                      left: width * 0.03,
                      child: Container(
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
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: width * 0.025),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.user.userName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: clampDouble(
                                      width * 0.032,
                                      11,
                                      14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  totalPoints.toString(),
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: clampDouble(
                                      width * 0.032,
                                      11,
                                      14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: height * 0.02,
                      right: width * 0.04,
                      child: GestureDetector(
                        onTap: toggleMenu,
                        child: Container(
                          width: clampDouble(width * 0.12, 44, 55),
                          height: clampDouble(width * 0.12, 44, 55),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 139, 41, 5),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            showMenu ? Icons.close : Icons.menu,
                            color: Colors.white,
                            size: clampDouble(width * 0.075, 26, 34),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: height * 0.10,
                      left: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/ship.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Lesson1Screen(user: widget.user),
                            ),
                          );
                        },
                      ),
                    ),

                    Positioned(
                      top: height * 0.28,
                      right: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/rocks.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Lesson2Screen(user: widget.user),
                            ),
                          );
                        },
                      ),
                    ),

                    Positioned(
                      top: height * 0.48,
                      left: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/citizen.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Lesson3Screen(user: widget.user),
                            ),
                          );
                        },
                      ),
                    ),

                    Positioned(
                      top: height * 0.66,
                      right: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/government.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Lesson4Screen(user: widget.user),
                            ),
                          );
                        },
                      ),
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

class LevelCard extends StatefulWidget {
  final String imagePath;
  final double width;
  final double imageHeight;
  final double starSize;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.imagePath,
    required this.width,
    required this.imageHeight,
    required this.starSize,
    required this.onTap,
  });

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard> {
  bool isHighlighted = false;

  void setHighlight(bool value) {
    setState(() {
      isHighlighted = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) {
        setHighlight(true);
      },
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setHighlight(false);
          }
        });

        widget.onTap();
      },
      onTapCancel: () {
        setHighlight(false);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setHighlight(true);
        },
        onExit: (_) {
          setHighlight(false);
        },
        child: AnimatedScale(
          scale: isHighlighted ? 1.07 : 1.0,
          duration: const Duration(milliseconds: 180),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: widget.width,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: isHighlighted
                  ? Colors.yellow.withValues(alpha: 0.18)
                  : Colors.transparent,
              border: Border.all(
                color: isHighlighted ? Colors.yellow : Colors.transparent,
                width: 4,
              ),
              boxShadow: isHighlighted
                  ? [
                      BoxShadow(
                        color: Colors.yellow.withValues(alpha: 0.9),
                        blurRadius: 26,
                        spreadRadius: 4,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  widget.imagePath,
                  width: widget.width,
                  height: widget.imageHeight,
                  fit: BoxFit.contain,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.starSize * 0.08,
                      ),
                      child: Image.asset(
                        'assets/star.png',
                        width: widget.starSize,
                        height: widget.starSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
