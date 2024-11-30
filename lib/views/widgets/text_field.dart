import 'package:flutter/material.dart';

class InputFields extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData icon;

  const InputFields(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 5,
        ),
        height: 35,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white70,
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          style: const TextStyle(fontSize: 15),
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              icon,
              color: Colors.blue,
              size: 20,
            ),
            hintText: hintText,
          ),
        ));
  }
}
