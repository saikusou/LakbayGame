import 'package:flutter/material.dart';

void main() => runApp(const LakbayDailyRewardDemo());

class LakbayDailyRewardDemo extends StatelessWidget {
  const LakbayDailyRewardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lakbay Daily Reward',
      theme: ThemeData(fontFamily: 'Arial'),
      home: Scaffold(
        backgroundColor: const Color(0xFF1B1B1B),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: LakbayDailyRewardCard(
              // Day 1 already claimed, like the reference image.
              claimedDays: 1,
              totalDays: 7,
              onClaim: () {},
            ),
          ),
        ),
      ),
    );
  }
}

/// The full daily-reward card widget.
class LakbayDailyRewardCard extends StatefulWidget {
  final int claimedDays; // how many days are already filled (gold star)
  final int totalDays; // total days in the streak (7 for a week)
  final VoidCallback? onClaim;

  const LakbayDailyRewardCard({
    super.key,
    this.claimedDays = 1,
    this.totalDays = 7,
    this.onClaim,
  });

  @override
  State<LakbayDailyRewardCard> createState() => _LakbayDailyRewardCardState();
}

class _LakbayDailyRewardCardState extends State<LakbayDailyRewardCard> {
  static const Color woodDark = Color(0xFF7A3E1D);
  static const Color woodMid = Color(0xFFA85A2A);
  static const Color woodLight = Color(0xFFD97C3E);
  static const Color cream = Color(0xFFFCE8B4);
  static const Color gold = Color(0xFFFFC93C);
  static const Color goldDark = Color(0xFFE8940C);
  static const Color leafGreen = Color(0xFF4CAF50);
  static const Color leafDark = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    final cardWidth = 380.0;

    return SizedBox(
      width: cardWidth,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // ---- Main frame ----
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Container(
              width: cardWidth,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: woodMid,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: woodDark, width: 4),
                ),
                child: Column(
                  children: [
                    _buildDayGrid(),
                    const SizedBox(height: 20),
                    _buildClaimButton(),
                  ],
                ),
              ),
            ),
          ),

          // ---- Foliage / decoration behind banner ----
          Positioned(top: 0, child: _buildTopDecoration(cardWidth)),

          // ---- Ribbon banner with title (overlaps frame) ----
          Positioned(top: 108, child: _buildBanner(cardWidth)),

          // ---- Mascot chick, bottom-left ----
          Positioned(left: -18, bottom: 4, child: _buildMascot()),
        ],
      ),
    );
  }

  // Simple stand-in for the leafy/flag/kids header illustration.
  Widget _buildTopDecoration(double width) {
    return SizedBox(
      width: width,
      height: 145,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // leafy blob background
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 110,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [leafGreen.withOpacity(0.95), leafDark],
                radius: 0.9,
              ),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          // sun
          Positioned(
            top: 0,
            right: width * 0.32,
            child: const Icon(Icons.wb_sunny, color: gold, size: 34),
          ),
          // PH flag stand-in
          Positioned(
            top: 6,
            left: width * 0.18,
            child: Column(
              children: [
                Container(width: 3, height: 70, color: const Color(0xFF6D4C1E)),
              ],
            ),
          ),
          Positioned(
            top: 8,
            left: width * 0.18 + 3,
            child: ClipPath(
              clipper: _FlagClipper(),
              child: Container(
                width: 60,
                height: 36,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0038A8), Color(0xFFCE1126)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.star, color: gold, size: 14),
                ),
              ),
            ),
          ),
          // two "explorer" avatars (simple stand-ins)
          Positioned(
            bottom: 34,
            left: width * 0.30,
            child: _explorerAvatar(const Color(0xFFFFD54F)),
          ),
          Positioned(
            bottom: 34,
            left: width * 0.50,
            child: _explorerAvatar(Colors.white),
          ),
          // treasure chest stand-in
          Positioned(
            bottom: 30,
            right: 6,
            child: Icon(Icons.inventory_2, color: gold, size: 42),
          ),
          // map/book stand-in
          Positioned(
            bottom: 26,
            left: 4,
            child: Icon(
              Icons.menu_book,
              color: const Color(0xFF3B6FC4),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _explorerAvatar(Color shirtColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFFF3C08B),
          child: const Icon(Icons.face, color: Color(0xFF5C3A21), size: 18),
        ),
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 26,
          height: 18,
          decoration: BoxDecoration(
            color: shirtColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
      ],
    );
  }

  Widget _buildMascot() {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // green blob body
          Container(
            width: 80,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFC5E17A),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          // chick
          Positioned(
            top: 0,
            left: 6,
            child: Container(
              width: 46,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD84D),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 10,
                    top: 14,
                    child: Icon(Icons.circle, size: 5, color: Colors.black),
                  ),
                  Positioned(
                    right: 2,
                    top: 18,
                    child: Container(
                      width: 12,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(double width) {
    return SizedBox(
      width: width * 0.92,
      child: CustomPaint(
        painter: _RibbonPainter(dark: woodDark, mid: woodMid, light: woodLight),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _outlinedText('LAKBAY', 34),
              _outlinedText('DAILY REWARD', 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _outlinedText(String text, double size) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = woodDark,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: gold,
          ),
        ),
      ],
    );
  }

  Widget _buildDayGrid() {
    // 7 days -> 4 columns on first row, 3 on second (matches a weekly feel
    // and keeps tiles a nice size); adjust crossAxisCount freely.
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.totalDays,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final dayNumber = index + 1;
        final isClaimed = dayNumber <= widget.claimedDays;
        // last day (Day 7) gets a slightly bigger "bonus" treatment
        final isBonus = dayNumber == widget.totalDays;
        return _DayTile(
          dayNumber: dayNumber,
          isClaimed: isClaimed,
          isBonus: isBonus,
        );
      },
    );
  }

  Widget _buildClaimButton() {
    return GestureDetector(
      onTap: widget.onClaim,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8A3D), Color(0xFFE8590C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: woodDark, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'CLAIM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A single "Day N" tile with a star that's gold when claimed, gray otherwise.
class _DayTile extends StatelessWidget {
  final int dayNumber;
  final bool isClaimed;
  final bool isBonus;

  const _DayTile({
    required this.dayNumber,
    required this.isClaimed,
    this.isBonus = false,
  });

  @override
  Widget build(BuildContext context) {
    final starColor = isClaimed
        ? const Color(0xFFFFC93C)
        : const Color(0xFFB0B0B0);
    final starShadow = isClaimed
        ? const Color(0xFFE8940C)
        : const Color(0xFF888888);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isBonus ? const Color(0xFFE8590C) : const Color(0xFFD9A05B),
          width: isBonus ? 3 : 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isBonus
                  ? const Color(0xFFE8590C)
                  : const Color(0xFFF08C1D),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Text(
              isBonus ? 'DAY $dayNumber ★' : 'DAY $dayNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Icon(
                Icons.star_rounded,
                size: isBonus ? 46 : 40,
                color: starColor,
                shadows: [
                  Shadow(
                    color: starShadow,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clips a simple waving-flag triangle shape.
class _FlagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Paints the wooden ribbon-banner shape behind the title text.
class _RibbonPainter extends CustomPainter {
  final Color dark;
  final Color mid;
  final Color light;

  _RibbonPainter({required this.dark, required this.mid, required this.light});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final notch = 16.0;

    final bodyPaint = Paint()..color = mid;
    final borderPaint = Paint()
      ..color = dark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Main ribbon rectangle with a slight ribbon-tail notch on both sides.
    final path = Path()
      ..moveTo(0, notch)
      ..lineTo(20, 0)
      ..lineTo(w - 20, 0)
      ..lineTo(w, notch)
      ..lineTo(w, h - notch)
      ..lineTo(w - 20, h)
      ..lineTo(20, h)
      ..lineTo(0, h - notch)
      ..close();

    canvas.drawShadow(path, Colors.black, 4, false);
    canvas.drawPath(path, bodyPaint);
    canvas.drawPath(path, borderPaint);

    // wood plank lines
    final plankPaint = Paint()
      ..color = light.withOpacity(0.5)
      ..strokeWidth = 1.5;
    for (int i = 1; i < 4; i++) {
      final y = h / 4 * i;
      canvas.drawLine(Offset(10, y), Offset(w - 10, y), plankPaint);
    }

    // little side ribbon triangles (tails)
    final tailPaint = Paint()..color = dark;
    canvas.drawPath(
      Path()
        ..moveTo(0, h - notch)
        ..lineTo(-14, h + 10)
        ..lineTo(20, h)
        ..close(),
      tailPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w, h - notch)
        ..lineTo(w + 14, h + 10)
        ..lineTo(w - 20, h)
        ..close(),
      tailPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
