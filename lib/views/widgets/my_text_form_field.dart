import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  MyTextFormField(
      {super.key,
      required this.hintText,
      required this.labelText,
      required this.passwordController,
      required this.icon,
      required this.textInputType,
      required this.validator});
  final String hintText, labelText;
  final TextEditingController passwordController;
  final IconData icon;
  final TextInputType textInputType;
  final bool passToggle = true;
  final formKey = GlobalKey<FormState>();
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: passwordController,
      keyboardType: textInputType,
      style: const TextStyle(color: Colors.white60),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        isDense: true,
        labelStyle: const TextStyle(color: Colors.white54),
        errorStyle:
            TextStyle(color: Colors.orange.withOpacity(0.8), fontSize: 10),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue.withOpacity(0.7)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue.withOpacity(0.7)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue.withOpacity(0.7)),
        ),
        prefixIcon: Icon(icon),
        prefixIconColor: Colors.blue,
        suffixIconColor: Colors.blue,
      ),
    );
  }
}
