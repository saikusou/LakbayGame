import 'package:flutter/material.dart';

class Day2Popup extends StatelessWidget {
  final String title;

  const Day2Popup({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),

      child: Container(
        width: 340,
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/day2-bg.png'),
            fit: BoxFit.cover,
          ),

          borderRadius: BorderRadius.circular(24),

          border: Border.all(color: Colors.blue, width: 4),
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

                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            Text(
              title,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 18),

            /// DIFFERENT CONTENT
            const Text(
              "ITO ANG CONTENT NG DAY 2",
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 25),

            /// SAMPLE BUTTON
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),

              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(18),
              ),

              child: const Text(
                "START",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
