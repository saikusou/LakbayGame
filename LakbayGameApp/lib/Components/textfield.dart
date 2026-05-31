import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool passwordInvisible;

  const InputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.passwordInvisible,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: size.width * 0.9,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 248, 248),
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.white, width: 2),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: passwordInvisible,
        style: const TextStyle(
          color: Colors.black, // input text color
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(icon, color: Colors.black),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
