import 'package:flutter/material.dart';
import 'package:lakbay_game/models/user_model.dart';

class LessonOneDayThreeActThreeC extends StatelessWidget {
  final UserModel user;

  const LessonOneDayThreeActThreeC({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('Mission 1'),
        backgroundColor: Colors.green,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'MISSION 1 PAGE',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(
              'Welcome ${user.userName}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('BACK'),
            ),
          ],
        ),
      ),
    );
  }
}
