import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/daily_reward_popup.dart';
import 'package:lakbay_game/User/data/points_provider.dart';
import 'package:lakbay_game/services/api_service.dart';
import 'package:provider/provider.dart';

import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/Components/side_navigation.dart';
import 'package:lakbay_game/Views/lesson2.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/Views/lesson4.dart';
import 'package:lakbay_game/User/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showMenu = false;
  bool rewardPopupShown = false;

<<<<<<< Updated upstream
  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
=======
  int claimedStreak = 1;

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
>>>>>>> Stashed changes
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;

      await context.read<PointsProvider>().loadPoints(widget.user.id!);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkDailyReward();
    });
  }

  Future<void> checkDailyReward() async {
    try {
      final status = await ApiService.getDailyRewardStatus(widget.user.id!);

      setState(() {
        claimedStreak = status['claimedDaysSoFar'];
      });

      final alreadyClaimed = status['alreadyClaimed'] ?? false;
      if (!alreadyClaimed && mounted) {
        showDailyRewardPopup();
      }
    } catch (error) {
      debugPrint('Error checking daily reward: $error');
    }
  }

  Future<void> claimDailyReward() async {
<<<<<<< Updated upstream
    try {
      await ApiService.claimDailyReward(widget.user.id!);

      if (!mounted) return;

=======
    final result = await ApiService.claimDailyReward(widget.user.id!);

    if (mounted) {
      setState(() {
        claimedStreak = result['streakDay'] ?? claimedStreak;
      });
>>>>>>> Stashed changes
      Navigator.pop(context);

      await context.read<PointsProvider>().loadPoints(widget.user.id!);
    } catch (error) {
      debugPrint('Error claiming daily reward: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hindi nakuha ang daily reward. Subukan muli.'),
        ),
      );
    }
  }

  void toggleMenu() {
    setState(() {
      showMenu = !showMenu;
    });
  }

  void showDailyRewardPopup() {
    if (rewardPopupShown || !mounted) return;

    rewardPopupShown = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;

        final popupWidth = clampDouble(size.width * 0.92, 300, 470);
<<<<<<< Updated upstream

        final popupHeight = clampDouble(size.height * 0.86, 500, 760);

=======
        final popupHeight = clampDouble(size.height * 0.86, 500, 780);
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                Image.asset(
                  'assets/active_star1.png',
                  width: popupWidth,
                  height: popupHeight,
                  fit: BoxFit.contain,
                ),

                // Invisible claim button placed above the
                // button already included in the image.
                Positioned(
                  bottom: popupHeight * 0.04,
                  left: popupWidth * 0.30,
                  child: SizedBox(
                    width: popupWidth * 0.40,
                    height: popupHeight * 0.09,
                    child: ElevatedButton(
                      onPressed: claimDailyReward,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
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
=======
                // NEW: the 7-day reward card replaces the static image.
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: LakbayDailyRewardCard(
                    claimedDays: claimedStreak,
                    totalDays: 7,
                    onClaim: claimDailyReward,
>>>>>>> Stashed changes
                  ),
                ),

                Positioned(
                  top: popupHeight * 0.02,
                  right: popupWidth * 0.06,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(dialogContext);
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
    ).whenComplete(() {
      rewardPopupShown = false;
    });
  }

  void openLessonOne() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Lesson1Screen(user: widget.user);
        },
      ),
    );
  }

  void openLessonTwo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Lesson2Screen(user: widget.user);
        },
      ),
    );
  }

  void openLessonThree() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Lesson3Screen(user: widget.user);
        },
      ),
    );
  }

  void openLessonFour() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Lesson4Screen(user: widget.user);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final totalPoints = context.watch<PointsProvider>().totalPoints;

    // Ship is always unlocked.
    const bool lessonOneUnlocked = true;

    // The remaining islands unlock when the user reaches 200 points.
    final bool lessonTwoUnlocked = totalPoints >= 200;
    final bool lessonThreeUnlocked = totalPoints >= 200;
    final bool lessonFourUnlocked = totalPoints >= 200;

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
                    // User information
                    Positioned(
                      top: height * 0.02,
                      left: width * 0.03,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: width * 0.55),
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03,
                          vertical: height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.user.userName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 17,
                                      ),
                                      const SizedBox(width: 4),
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
                          ],
                        ),
                      ),
                    ),

                    // Menu button
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

                    // Lesson 1 - always enabled
                    Positioned(
                      top: height * 0.10,
                      left: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/ship.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        enabled: lessonOneUnlocked,
                        requiredPoints: 0,
                        onTap: openLessonOne,
                      ),
                    ),

                    // Lesson 2 - visible but locked below 200 points
                    Positioned(
                      top: height * 0.28,
                      right: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/rocks.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        enabled: lessonTwoUnlocked,
                        requiredPoints: 200,
                        onTap: openLessonTwo,
                      ),
                    ),

                    // Lesson 3 - visible but locked below 200 points
                    Positioned(
                      top: height * 0.48,
                      left: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/citizen.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        enabled: lessonThreeUnlocked,
                        requiredPoints: 200,
                        onTap: openLessonThree,
                      ),
                    ),

                    // Lesson 4 - visible but locked below 200 points
                    Positioned(
                      top: height * 0.66,
                      right: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/government.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        enabled: lessonFourUnlocked,
                        requiredPoints: 200,
                        onTap: openLessonFour,
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
  final bool enabled;
  final int requiredPoints;

  const LevelCard({
    super.key,
    required this.imagePath,
    required this.width,
    required this.imageHeight,
    required this.starSize,
    required this.onTap,
    required this.enabled,
    required this.requiredPoints,
  });

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard> {
  bool isHighlighted = false;

  void setHighlight(bool value) {
    if (!widget.enabled) return;
    if (!mounted || isHighlighted == value) return;

    setState(() {
      isHighlighted = value;
    });
  }

  void handleTap() {
    if (!widget.enabled) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kailangan mo ng ${widget.requiredPoints} points para ma-unlock ito.',
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      return;
    }

    widget.onTap();
  }

  void handleTapUp(TapUpDetails details) {
    if (!widget.enabled) return;

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setHighlight(false);
      }
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,

      // Locked islands can still detect a tap so the
      // required-points message can be displayed.
      onTap: widget.enabled ? null : handleTap,

      onTapDown: (_) {
        if (widget.enabled) {
          setHighlight(true);
        }
      },
      onTapUp: widget.enabled ? handleTapUp : null,
      onTapCancel: () {
        if (widget.enabled) {
          setHighlight(false);
        }
      },
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        onEnter: (_) {
          if (widget.enabled) {
            setHighlight(true);
          }
        },
        onExit: (_) {
          if (widget.enabled) {
            setHighlight(false);
          }
        },
        child: AnimatedScale(
          scale: isHighlighted && widget.enabled ? 1.07 : 1.0,
          duration: const Duration(milliseconds: 180),
          child: AnimatedOpacity(
            opacity: widget.enabled ? 1.0 : 0.48,
            duration: const Duration(milliseconds: 250),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: widget.width,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: isHighlighted && widget.enabled
                    ? Colors.yellow.withValues(alpha: 0.18)
                    : Colors.transparent,
                border: Border.all(
                  color: isHighlighted && widget.enabled
                      ? Colors.yellow
                      : Colors.transparent,
                  width: 4,
                ),
                boxShadow: isHighlighted && widget.enabled
                    ? [
                        BoxShadow(
                          color: Colors.yellow.withValues(alpha: 0.90),
                          blurRadius: 26,
                          spreadRadius: 4,
                        ),
                      ]
                    : const [],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: widget.enabled
                        ? const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.dst,
                          )
                        : const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
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
                          children: List.generate(3, (index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: widget.starSize * 0.08,
                              ),
                              child: Image.asset(
                                'assets/star.png',
                                width: widget.starSize,
                                height: widget.starSize,
                                fit: BoxFit.contain,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  if (!widget.enabled)
                    Container(
                      width: clampValue(widget.width * 0.22, 48, 70),
                      height: clampValue(widget.width * 0.22, 48, 70),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.60),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: clampValue(widget.width * 0.11, 25, 38),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double clampValue(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }
}
