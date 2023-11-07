import 'package:flutter/material.dart';
import 'colors' as my_defined_colors;

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  MyButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: my_defined_colors.AppColors.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        child: Text(
          label,
          style:
              const TextStyle(color: my_defined_colors.AppColors.primaryColor),
        ),
      ),
    );
  }
}
