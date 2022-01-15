import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.icon,
    required this.hint,
    required this.controller,
    this.inputType,
    this.isTextVisible,
  });
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final TextInputType? inputType;
  final bool? isTextVisible;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          size: 20,
        ),
        border: OutlineInputBorder(),
        hintText: hint,
      ),
      keyboardType: inputType,
      obscureText: isTextVisible ?? false,
    );
  }
}
