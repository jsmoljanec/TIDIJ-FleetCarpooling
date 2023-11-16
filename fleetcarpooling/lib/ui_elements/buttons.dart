import 'package:flutter/material.dart';
import 'colors' as my_defined_colors;

class MyElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const MyElevatedButton(
      {super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 54,
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
                  style: const TextStyle(
                      color: my_defined_colors.AppColors.primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyRadioButton extends StatefulWidget {
  final String title;
  final ValueChanged<bool?> onChanged;
  final bool value;

  const MyRadioButton(
      {super.key,
      required this.title,
      required this.onChanged,
      required this.value});

  @override
  _MyRadioButtonState createState() => _MyRadioButtonState();
}

class _MyRadioButtonState extends State<MyRadioButton> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style:
            const TextStyle(color: my_defined_colors.AppColors.mainTextColor),
      ),
      leading: Radio<bool>(
        fillColor: MaterialStateColor.resolveWith(
          (Set<MaterialState> states) {
            return my_defined_colors.AppColors.buttonColor;
          },
        ),
        value: widget.value,
        groupValue: true,
        onChanged: widget.onChanged,
      ),
    );
  }
}
