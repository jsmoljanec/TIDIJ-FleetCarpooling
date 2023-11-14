import 'package:flutter/material.dart';
import 'colors' as my_defined_colors;

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final RegExp regex;
  final bool isPassword;

  const MyTextField({
    Key? key,
    required this.controller, required this.regex,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword, 
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(
              color: my_defined_colors.AppColors.buttonColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(
              color: my_defined_colors.AppColors.buttonColor,
            ),
          ),
        ),
      ),
    );
  }
}
