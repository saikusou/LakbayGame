import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/level_card.dart';
import 'package:provider/provider.dart';
import 'package:lakbay_game/Components/daily_reward_popup.dart';
import 'package:lakbay_game/Components/side_navigation.dart';
import 'package:lakbay_game/User/data/points_provider.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson1.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson2.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson3.dart';
import 'package:lakbay_game/Views/main_screen/lessons/lesson4.dart';
import 'package:lakbay_game/services/api_service.dart';

class MainScreen extends StatefulWidget {
  final UserModel user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showMenu = false;
  bool rewardPopupShown = false;
  bool isClaimingReward = false;

  int claimedStreak = 0;
  double lesson1Progress = 0;
  double lesson2Progress = 0;
  double lesson3Progress = 0;
  double lesson4Progress = 0;

  double clampDouble(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  int? get userId => widget.user.id;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeProfile();
    });
  }

  Future<void> loadLesson1Progress() async {
    final int? id = userId;

    if (id == null) return;

    try {
      final lesson1 = await ApiService.getLessonProgress(id, "Lesson 1");
      final lesson2 = await ApiService.getLessonProgress(id, "Lesson 2");
      final lesson3 = await ApiService.getLessonProgress(id, "Lesson 3");
      final lesson4 = await ApiService.getLessonProgress(id, "Lesson 4");

      setState(() {
        lesson1Progress = (lesson1['percentageCompleted'] as num).toDouble();
        lesson2Progress = (lesson2['percentageCompleted'] as num).toDouble();
        lesson3Progress = (lesson3['percentageCompleted'] as num).toDouble();
        lesson4Progress = (lesson4['percentageCompleted'] as num).toDouble();
      });
    } catch (e) {
      debugPrint("Failed to load Lesson 1 progress: $e");
    }
  }

  Future<void> initializeProfile() async {
    await loadUserPoints();
    await loadLesson1Progress();

    if (!mounted) return;

    await checkDailyReward();
  }

  Future<void> loadUserPoints() async {
    final int? id = userId;

    if (id == null) {
      debugPrint('Unable to load points because the user ID is null.');
      return;
    }

    try {
      await context.read<PointsProvider>().loadPoints(id);
    } catch (error) {
      debugPrint('Unable to load user points: $error');
    }
  }

  Future<void> checkDailyReward() async {
    final int? id = userId;

    if (id == null) {
      debugPrint(
        'Unable to check the daily reward because the user ID is null.',
      );
      return;
    }

    try {
      final Map<String, dynamic> status = await ApiService.getDailyRewardStatus(
        id,
      );

      if (!mounted) return;

      final int claimedDays =
          (status['claimedDaysSoFar'] as num?)?.toInt() ?? 0;

      final bool alreadyClaimed = status['alreadyClaimed'] as bool? ?? false;

      setState(() {
        claimedStreak = claimedDays;
      });

      if (!alreadyClaimed) {
        showDailyRewardPopup();
      }
    } catch (error) {
      debugPrint('Error checking daily reward: $error');
    }
  }

  Future<void> claimDailyReward({
    required BuildContext dialogContext,
    required StateSetter setDialogState,
  }) async {
    final int? id = userId;

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hindi makita ang user ID.')),
      );
      return;
    }

    if (isClaimingReward) return;

    setState(() {
      isClaimingReward = true;
    });

    setDialogState(() {});

    try {
      final Map<String, dynamic> result = await ApiService.claimDailyReward(id);

      if (!mounted) return;

      final int newStreak =
          (result['streakDay'] as num?)?.toInt() ??
          (result['claimedDaysSoFar'] as num?)?.toInt() ??
          claimedStreak;

      setState(() {
        claimedStreak = newStreak;
      });

      await context.read<PointsProvider>().loadPoints(id);

      if (!mounted) return;

      if (dialogContext.mounted && Navigator.of(dialogContext).canPop()) {
        Navigator.of(dialogContext).pop();
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nakuha mo na ang iyong daily reward!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      debugPrint('Error claiming daily reward: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hindi nakuha ang daily reward. Subukan muli.'),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isClaimingReward = false;
        });
      }

      if (dialogContext.mounted) {
        setDialogState(() {});
      }
    }
  }

  void toggleMenu() {
    setState(() {
      showMenu = !showMenu;
    });
  }

  void showDailyRewardPopup() {
    if (!mounted || rewardPopupShown) return;

    rewardPopupShown = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            final Size size = MediaQuery.of(context).size;

            final double popupWidth = clampDouble(size.width * 0.92, 300, 470);

            final double popupHeight = clampDouble(
              size.height * 0.86,
              500,
              780,
            );

            final double closeSize = clampDouble(size.width * 0.10, 36, 48);

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 18,
              ),
              child: SizedBox(
                width: popupWidth,
                height: popupHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: LakbayDailyRewardCard(
                        claimedDays: claimedStreak,
                        totalDays: 7,
                        onClaim: () {
                          claimDailyReward(
                            dialogContext: dialogContext,
                            setDialogState: setDialogState,
                          );
                        },
                      ),
                    ),

                    Positioned(
                      top: popupHeight * 0.015,
                      right: popupWidth * 0.025,
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
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
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
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
    final Size size = MediaQuery.of(context).size;

    final int totalPoints = context.watch<PointsProvider>().totalPoints;

    final bool lessonTwoUnlocked = lesson1Progress >= 100;
    final bool lessonThreeUnlocked = lesson2Progress >= 100;
    final bool lessonFourUnlocked = lesson3Progress >= 100;

    final double levelWidth = clampDouble(size.width * 0.50, 190, 320);

    final double imageHeight = clampDouble(size.height * 0.24, 180, 300);

    final double starSize = clampDouble(size.width * 0.065, 20, 36);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/profile.png', fit: BoxFit.cover),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double height = constraints.maxHeight;
                final double width = constraints.maxWidth;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
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

                    Positioned(
                      top: height * 0.10,
                      left: width * 0.02,
                      child: LevelCard(
                        imagePath: 'assets/ship.png',
                        width: levelWidth,
                        imageHeight: imageHeight,
                        starSize: starSize,
                        enabled: true,
                        progress: lesson1Progress,
                        onTap: openLessonOne,
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
                        enabled: lessonTwoUnlocked,
                        progress: lesson2Progress,
                        onTap: openLessonTwo,
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
                        enabled: lessonThreeUnlocked,
                        progress: lesson3Progress,
                        onTap: openLessonThree,
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
                        enabled: lessonFourUnlocked,
                        progress: lesson4Progress,
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
