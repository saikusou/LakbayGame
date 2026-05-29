import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback press;

  const Button({super.key, required this.label, required this.press});

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      label: label,
      icon: Icons.person,
      colors: const [Color(0xFFFFD54F), Color(0xFFF9A825)],
      press: press,
    );
  }
}

class Button1 extends StatelessWidget {
  final String label;
  final VoidCallback press;

  const Button1({super.key, required this.label, required this.press});

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      label: label,
      icon: Icons.login,
      colors: const [Color(0xFF4FC3F7), Color(0xFF1976D2)],
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      press: press,
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback press;
  final EdgeInsetsGeometry margin;

  const GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    required this.press,
    this.margin = const EdgeInsets.symmetric(horizontal: 25),
  });

  double clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fontSize = clampDouble(size.width * 0.038, 12, 16);
    final iconSize = clampDouble(size.width * 0.06, 20, 24);

    return Container(
      margin: margin,
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: TextButton(
        onPressed: press,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: iconSize),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
