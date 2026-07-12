import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lakbay_game/User/data/points_provider.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/services/api_service.dart';

import 'package:lakbay_game/Components/side_navigation.dart';
import 'package:lakbay_game/Views/lesson1.dart';
import 'package:lakbay_game/Views/lesson2.dart';
import 'package:lakbay_game/Views/lesson3.dart';
import 'package:lakbay_game/Views/lesson4.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showMenu = false;
  bool rewardPopupShown = false;
  bool isClaimingReward = false;

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  int? get userId => widget.user.id;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await loadUserPoints();

      if (!mounted) return;

      await checkDailyReward();
    });
  }

  Future<void> loadUserPoints() async {
    final id = userId;

    if (id == null) {
      debugPrint('Unable to load points: User ID is null.');
      return;
    }

    try {
      await context.read<PointsProvider>().loadPoints(id);
    } catch (error) {
      debugPrint('Error loading points: $error');
    }
  }

  Future<void> checkDailyReward() async {
    final id = userId;

    if (id == null || !mounted) {
      return;
    }

    try {
      final alreadyClaimed = await ApiService.hasClaimedToday(id);

      if (!alreadyClaimed && mounted) {
        showDailyRewardPopup();
      }
    } catch (error) {
      debugPrint('Error checking daily reward: $error');
    }
  }

  Future<void> claimDailyReward(BuildContext dialogContext) async {
    final id = userId;

    if (id == null || isClaimingReward) {
      return;
    }

    setState(() {
      isClaimingReward = true;
    });

    try {
      await ApiService.claimDailyReward(id);

      if (!mounted) return;

      if (Navigator.of(dialogContext).canPop()) {
        Navigator.of(dialogContext).pop();
      }

      await context.read<PointsProvider>().loadPoints(id);
    } catch (error) {
      debugPrint('Error claiming daily reward: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hindi nakuha ang daily reward. Subukan muli.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isClaimingReward = false;
        });
      }
    }
  }

  void toggleMenu() {
    setState(() {
      showMenu = !showMenu;
    });
  }

  void showDailyRewardPopup() {
    if (rewardPopupShown || !mounted) {
      return;
    }

    rewardPopupShown = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;

        final popupWidth = clampDouble(size.width * 0.92, 300, 470);

        final popupHeight = clampDouble(size.height * 0.86, 500, 760);

        final closeSize = clampDouble(size.width * 0.10, 36, 48);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          child: SizedBox(
            width: popupWidth,
            height: popupHeight,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/active_star1.png',
                  width: popupWidth,
                  height: popupHeight,
                  fit: BoxFit.contain,
                ),

                // Invisible claim button placed on top of the
                // claim button already included in the image.
                Positioned(
                  bottom: popupHeight * 0.04,
                  left: popupWidth * 0.30,
                  child: SizedBox(
                    width: popupWidth * 0.40,
                    height: popupHeight * 0.09,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: isClaimingReward
                            ? null
                            : () {
                                claimDailyReward(dialogContext);
                              },
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: popupHeight * 0.04,
                  right: popupWidth * 0.08,
                  child: GestureDetector(
                    onTap: isClaimingReward
                        ? null
                        : () {
                            Navigator.of(dialogContext).pop();
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

                if (isClaimingReward)
                  Container(
                    width: popupWidth,
                    height: popupHeight,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      rewardPopupShown = false;

      if (mounted && isClaimingReward) {
        setState(() {
          isClaimingReward = false;
        });
      }
    });
  }

  void openLessonOne() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => Lesson1Screen(user: widget.user)));
  }

  void openLessonTwo() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => Lesson2Screen(user: widget.user)));
  }

  void openLessonThree() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => Lesson3Screen(user: widget.user)));
  }

  void openLessonFour() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => Lesson4Screen(user: widget.user)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final totalPoints = context.watch<PointsProvider>().totalPoints;

    // Lesson unlocking requirements.
    const int lessonTwoRequiredPoints = 100;
    const int lessonThreeRequiredPoints = 200;
    const int lessonFourRequiredPoints = 300;

    // Lesson 1 is always unlocked.
    const bool lessonOneUnlocked = true;

    // Each lesson now uses its correct point requirement.
    final bool lessonTwoUnlocked = totalPoints >= lessonTwoRequiredPoints;

    final bool lessonThreeUnlocked = totalPoints >= lessonThreeRequiredPoints;

    final bool lessonFourUnlocked = totalPoints >= lessonFourRequiredPoints;

    final levelWidth = clampDouble(size.width * 0.50, 190, 320);

    final imageHeight = clampDouble(size.height * 0.24, 180, 300);

    final starSize = clampDouble(size.width * 0.065, 20, 36);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
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
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 139, 41, 5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            showMenu ? Icons.close : Icons.menu,
                            color: Colors.white,
                            size: clampDouble(width * 0.075, 26, 34),
                          ),
                        ),
                      ),
                    ),

                    // Lesson 1
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

                    // Lesson 2 - unlocks at 100 points
                    Positioned(
                      top: height * 0.28,
                      right: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/rocks.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        enabled: lessonTwoUnlocked,
                        requiredPoints: lessonTwoRequiredPoints,
                        onTap: openLessonTwo,
                      ),
                    ),

                    // Lesson 3 - unlocks at 200 points
                    Positioned(
                      top: height * 0.48,
                      left: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/citizen.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        enabled: lessonThreeUnlocked,
                        requiredPoints: lessonThreeRequiredPoints,
                        onTap: openLessonThree,
                      ),
                    ),

                    // Lesson 4 - unlocks at 300 points
                    Positioned(
                      top: height * 0.66,
                      right: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/government.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        enabled: lessonFourUnlocked,
                        requiredPoints: lessonFourRequiredPoints,
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
  bool isOpening = false;

  double clampValue(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  void setHighlight(bool value) {
    if (!widget.enabled) return;
    if (!mounted) return;
    if (isHighlighted == value) return;

    setState(() {
      isHighlighted = value;
    });
  }

  void showLockedMessage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Kailangan mo ng ${widget.requiredPoints} points '
          'para ma-unlock ang araling ito.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> handleTap() async {
    if (!widget.enabled) {
      showLockedMessage();
      return;
    }

    // Prevent opening the same page twice from rapid taps.
    if (isOpening) {
      return;
    }

    setState(() {
      isOpening = true;
      isHighlighted = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;

    setState(() {
      isHighlighted = false;
    });

    widget.onTap();

    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      setState(() {
        isOpening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockSize = clampValue(widget.width * 0.22, 48, 70);

    final lockIconSize = clampValue(widget.width * 0.11, 25, 38);

    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: (_) {
        setHighlight(true);
      },
      onExit: (_) {
        setHighlight(false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: handleTap,
        onTapDown: (_) {
          setHighlight(true);
        },
        onTapCancel: () {
          setHighlight(false);
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
                      width: lockSize,
                      height: lockSize,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.60),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: lockIconSize,
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
}
