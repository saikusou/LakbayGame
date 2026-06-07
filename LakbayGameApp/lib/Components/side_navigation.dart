import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/login.dart';
import 'package:lakbay_game/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                      // MenuProfile(screenWidth: width, user: user),

                      // SizedBox(height: clampDouble(height * 0.025, 12, 18)),
                      MenuItem(
                        icon: Icons.stars,
                        text: 'Points',
                        screenWidth: width,
                      ),
                      MenuItem(
                        icon: Icons.calendar_month,
                        text: 'Daily Rewards',
                        screenWidth: width,
                      ),
                      MenuItem(
                        icon: Icons.beach_access,
                        text: 'Islands',
                        screenWidth: width,
                      ),
                      MenuItem(
                        icon: Icons.emoji_events,
                        text: 'Leaderboard',
                        screenWidth: width,
                      ),
                      MenuItem(
                        icon: Icons.info,
                        text: 'About Us',
                        screenWidth: width,
                      ),
                      MenuItem(
                        icon: Icons.settings,
                        text: 'Settings',
                        screenWidth: width,
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
