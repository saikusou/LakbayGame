import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/leaderboard_screen.dart';
import 'package:lakbay_game/Views/auths/login.dart';
import 'package:lakbay_game/User/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lakbay_game/User/data/points_provider.dart';

class SideNavigation extends StatelessWidget {
  final double width;
  final double height;
  final bool showMenu;
  final VoidCallback onBack;
  final UserModel user;

  const SideNavigation({
    super.key,
    required this.width,
    required this.height,
    required this.showMenu,
    required this.onBack,
    required this.user,
  });

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  void showAboutUsPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: clampDouble(width * 0.05, 14, 24),
          ),
          child: Container(
            width: clampDouble(width * 0.88, 300, 400),
            padding: EdgeInsets.all(clampDouble(width * 0.05, 16, 22)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D6),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.brown, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: clampDouble(width * 0.22, 70, 90),
                  height: clampDouble(width * 0.22, 70, 90),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Icon(
                    Icons.info,
                    color: Colors.white,
                    size: clampDouble(width * 0.12, 38, 50),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "About Us",
                  style: TextStyle(
                    fontSize: clampDouble(width * 0.06, 22, 28),
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Lakbay Game is a Digital-Based Learning Strategy on the Attention Span and Academic Achievement in Araling Panlipunan.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(width * 0.038, 14, 16),
                    fontWeight: FontWeight.w600,
                    color: Colors.brown,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Developed for meaningful and enjoyable learning.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(width * 0.035, 13, 15),
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: clampDouble(width * 0.10, 32, 45),
                      vertical: clampDouble(width * 0.03, 10, 14),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: clampDouble(width * 0.04, 15, 18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDailyRewardPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: clampDouble(width * 0.04, 12, 20),
          ),
          child: Container(
            width: clampDouble(width * 0.90, 300, 420),
            padding: EdgeInsets.all(clampDouble(width * 0.04, 12, 18)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D6),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.brown, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/active_star4.png',
                    height: clampDouble(height * 0.42, 280, 420),
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Daily Rewards",
                    style: TextStyle(
                      fontSize: clampDouble(width * 0.06, 22, 28),
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Every day you can claim daily rewards. "
                    "The reward increases when you continue playing daily!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: clampDouble(width * 0.038, 14, 16),
                      fontWeight: FontWeight.w600,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _dailyRewardRow("Day 1", "10 Points"),
                  _dailyRewardRow("Day 2", "15 Points"),
                  _dailyRewardRow("Day 3", "20 Points"),
                  _dailyRewardRow("Day 4", "25 Points"),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: clampDouble(width * 0.12, 40, 55),
                        vertical: clampDouble(width * 0.035, 11, 15),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "CLAIM",
                      style: TextStyle(
                        fontSize: clampDouble(width * 0.05, 18, 22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dailyRewardRow(String day, String points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: EdgeInsets.symmetric(
        horizontal: clampDouble(width * 0.04, 14, 18),
        vertical: clampDouble(width * 0.025, 8, 11),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              day,
              style: TextStyle(
                fontSize: clampDouble(width * 0.04, 15, 18),
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ),
          Text(
            points,
            style: TextStyle(
              fontSize: clampDouble(width * 0.04, 15, 18),
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  void showIslandsPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: clampDouble(width * 0.04, 12, 20),
          ),
          child: Container(
            width: clampDouble(width * 0.92, 320, 450),
            padding: EdgeInsets.all(clampDouble(width * 0.04, 12, 18)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D6),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.brown, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Lakbay Islands",
                    style: TextStyle(
                      fontSize: clampDouble(width * 0.06, 22, 28),
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Explore the four islands of Lakbay Game. Each island contains lessons and activities.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: clampDouble(width * 0.035, 13, 15),
                      fontWeight: FontWeight.w600,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _islandCard(
                    image: "assets/ship.png",
                    title: "Lesson 1",
                    subtitle: "Pinagmulan ng Sinaunang Pilipino",
                  ),
                  _islandCard(
                    image: "assets/rocks.png",
                    title: "Lesson 2",
                    subtitle: "Lokasyon ng Pilipinas",
                  ),
                  _islandCard(
                    image: "assets/citizen.png",
                    title: "Lesson 3",
                    subtitle: "Pamayanan",
                  ),
                  _islandCard(
                    image: "assets/government.png",
                    title: "Lesson 4",
                    subtitle: "Lipunan at Politika sa Sinaunang Pilipinas",
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: clampDouble(width * 0.10, 32, 45),
                        vertical: clampDouble(width * 0.03, 10, 14),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontSize: clampDouble(width * 0.04, 15, 18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _islandCard({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: clampDouble(width * 0.18, 65, 80),
              height: clampDouble(width * 0.18, 65, 80),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: clampDouble(width * 0.045, 16, 19),
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: clampDouble(width * 0.033, 12, 14),
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showPointsPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: clampDouble(width * 0.06, 16, 28),
          ),
          child: Container(
            width: clampDouble(width * 0.82, 280, 360),
            padding: EdgeInsets.all(clampDouble(width * 0.055, 16, 22)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D6),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.brown, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: clampDouble(width * 0.20, 65, 80),
                  height: clampDouble(width * 0.20, 65, 80),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC928),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.brown, width: 3),
                  ),
                  child: Icon(
                    Icons.stars,
                    color: Colors.white,
                    size: clampDouble(width * 0.12, 38, 48),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Your Points",
                  style: TextStyle(
                    fontSize: clampDouble(width * 0.06, 21, 25),
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 10),
                Consumer<PointsProvider>(
                  builder: (context, pointsProvider, child) {
                    return Text(
                      pointsProvider.totalPoints.toString(),
                      style: TextStyle(
                        fontSize: clampDouble(width * 0.11, 38, 48),
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  "Keep playing lessons to earn more points!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: clampDouble(width * 0.038, 14, 16),
                    color: Colors.brown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: clampDouble(width * 0.09, 28, 36),
                      vertical: clampDouble(width * 0.035, 10, 14),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: clampDouble(width * 0.04, 15, 17),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final navWidth = clampDouble(width * 0.78, 240, 330);
    final backSize = clampDouble(width * 0.12, 42, 50);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      top: 0,
      bottom: 0,
      right: showMenu ? 0 : -navWidth,
      child: Container(
        width: navWidth,
        padding: EdgeInsets.only(
          top: clampDouble(height * 0.025, 14, 22),
          left: clampDouble(width * 0.04, 12, 18),
          right: clampDouble(width * 0.025, 8, 12),
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFFFC928),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            bottomLeft: Radius.circular(35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: navWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      width: backSize,
                      height: backSize,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: clampDouble(width * 0.06, 22, 26),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: clampDouble(height * 0.018, 8, 14)),
            Flexible(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      MenuItem(
                        icon: Icons.stars,
                        text: 'Points',
                        screenWidth: width,
                        onTap: () => showPointsPopup(context),
                      ),
                      MenuItem(
                        icon: Icons.calendar_month,
                        text: 'Daily Rewards',
                        screenWidth: width,
                        onTap: () => showDailyRewardPopup(context),
                      ),
                      MenuItem(
                        icon: Icons.beach_access,
                        text: 'Islands',
                        screenWidth: width,
                        onTap: () => showIslandsPopup(context),
                      ),
                      MenuItem(
                        icon: Icons.emoji_events,
                        text: 'Leaderboard',
                        screenWidth: width,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LeaderboardScreen(user: user),
                            ),
                          );
                        },
                      ),
                      MenuItem(
                        icon: Icons.info,
                        text: 'About Us',
                        screenWidth: width,
                        onTap: () => showAboutUsPopup(context),
                      ),
                      MenuItem(
                        icon: Icons.logout,
                        text: 'Logout',
                        screenWidth: width,
                        onTap: () => handleLogout(context),
                      ),
                      const SizedBox(height: 20),
                    ],
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

class MenuProfile extends StatelessWidget {
  final double screenWidth;
  final UserModel user;

  const MenuProfile({super.key, required this.screenWidth, required this.user});

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final avatarRadius = clampDouble(screenWidth * 0.07, 22, 30);

    return Row(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: avatarRadius + 4,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            user.userName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: clampDouble(screenWidth * 0.04, 14, 18),
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final double screenWidth;
  final VoidCallback? onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.screenWidth,
    this.onTap,
  });

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: clampDouble(screenWidth * 0.025, 8, 12),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: clampDouble(screenWidth * 0.035, 10, 14),
          vertical: clampDouble(screenWidth * 0.03, 9, 13),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3D6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.brown, width: 2),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.brown,
              size: clampDouble(screenWidth * 0.065, 22, 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: clampDouble(screenWidth * 0.038, 14, 17),
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
