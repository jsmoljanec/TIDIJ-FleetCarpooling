import 'package:flutter/material.dart';
import 'colors' as my_defined_colors;

class MyElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  MyElevatedButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: my_defined_colors
              .AppColors.buttonColor, // Koristi definiranu boju
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

class MyRadioButton extends StatefulWidget {
  final String title;
  final ValueChanged<bool?> onChanged;
  final bool value;

  MyRadioButton(
      {required this.title, required this.onChanged, required this.value});

  @override
  _MyRadioButtonState createState() => _MyRadioButtonState();
}

class _MyRadioButtonState extends State<MyRadioButton> {
  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      activeColor: my_defined_colors.AppColors.buttonColor,
      title: Text(widget.title),
      value: widget.value,
      onChanged: widget.onChanged,
      groupValue: widget.value ? true : null,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
