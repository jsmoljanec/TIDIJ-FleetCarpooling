import 'package:flutter/material.dart';
import 'colors' as my_defined_colors;

class MyTextField extends StatelessWidget {
  final TextEditingController controller;

  const MyTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        controller: controller,
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
