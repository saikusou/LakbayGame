import 'package:flutter/material.dart';

class LessonOneDayThreeActThree extends StatelessWidget {
  const LessonOneDayThreeActThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/lesson-two-day3-act3.png',
              fit: BoxFit.fill,
            ),
          ),

          // Mission Buttons
          Positioned(
            top: MediaQuery.of(context).size.height * 0.49,
            right: 25,
            child: missionButton(
              context,
              onTap: () {
                print('Mission 1');
              },
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.60,
            right: 25,
            child: missionButton(
              context,
              onTap: () {
                print('Mission 2');
              },
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.71,
            right: 25,
            child: missionButton(
              context,
              onTap: () {
                print('Mission 3');
              },
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.82,
            right: 25,
            child: missionButton(
              context,
              onTap: () {
                print('Mission 4');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget missionButton(BuildContext context, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFFB7F300), Color(0xFF5EAE00)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: const Color(0xFF3D7500), width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.25),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Color(0xFF5EAE00),
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'BUKSAN\nANG MISYON',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  height: 1,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
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
