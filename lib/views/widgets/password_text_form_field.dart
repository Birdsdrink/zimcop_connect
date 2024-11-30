import 'package:flutter/material.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField(
      {super.key,
      required this.hintText,
      required this.labelText,
      required this.passwordController,
      required this.validator});
  final String hintText, labelText;
  final TextEditingController passwordController;
  final String? Function(String?) validator;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool passToggle = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: passToggle ? false : true,
      style: const TextStyle(color: Colors.white60),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
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
        prefixIcon: const Icon(Icons.lock),
        prefixIconColor: Colors.blue,
        suffixIconColor: Colors.blue,
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              passToggle = !passToggle;
            });
          },
          child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
