import 'package:flutter/material.dart';

class PartialStar extends StatelessWidget {
  final double fill; // 0.0 to 1.0
  final double size;

  const PartialStar({super.key, required this.fill, required this.size});

  @override
  Widget build(BuildContext context) {
    final value = fill.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Empty star
          Icon(Icons.star_border, size: size, color: Colors.orange),

          // Filled portion
          ClipRect(
            clipper: _StarClipper(value),
            child: Icon(Icons.star, size: size, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double fill;

  _StarClipper(this.fill);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * fill, size.height);
  }

  @override
  bool shouldReclip(_StarClipper oldClipper) {
    return fill != oldClipper.fill;
  }
}
