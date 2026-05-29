import 'package:flutter/material.dart';

class SideNavigation extends StatelessWidget {
  final double width;
  final double height;
  final bool showMenu;
  final VoidCallback onBack;

  const SideNavigation({
    super.key,
    required this.width,
    required this.height,
    required this.showMenu,
    required this.onBack,
  });

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
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

            SizedBox(height: clampDouble(height * 0.018, 8, 14)),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MenuProfile(screenWidth: width),

                    SizedBox(height: clampDouble(height * 0.025, 12, 18)),

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

                    const SizedBox(height: 20),
                  ],
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

  const MenuProfile({super.key, required this.screenWidth});

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
            'Guest_668013',
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
