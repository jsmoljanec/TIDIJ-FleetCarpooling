import 'package:flutter/material.dart';
import 'colors' as my_defined_colors;

class VehicleController extends StatelessWidget {
  final Function(String) onCommand;
  final selectedMarkerId;

  const VehicleController(
      {super.key, required this.onCommand, this.selectedMarkerId});

  @override
  Widget build(BuildContext context) {
    TextEditingController locationController = TextEditingController();

    return Positioned(
      bottom: 10.0,
      left: 10.0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(19.0),
          topRight: Radius.circular(19.0),
          bottomLeft: Radius.circular(19.0),
          bottomRight: Radius.circular(19.0),
        ),
        child: Container(
          color: my_defined_colors.AppColors.primaryColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 140.0,
                    margin: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        hintText: 'Enter destination',
                        hintStyle: TextStyle(
                            color: my_defined_colors.AppColors.buttonColor),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: my_defined_colors.AppColors.buttonColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      var inputText = locationController.text;
                      if (inputText != "" && inputText.isEmpty == false) {
                        onCommand("set-destination $inputText");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: my_defined_colors.AppColors.buttonColor,
                    ),
                    child: const Icon(
                      Icons.change_circle,
                      color: my_defined_colors.AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => onCommand("start"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: my_defined_colors.AppColors.buttonColor,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: my_defined_colors.AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () => onCommand("stop"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: my_defined_colors.AppColors.buttonColor,
                    ),
                    child: const Icon(
                      Icons.stop,
                      color: my_defined_colors.AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () => onCommand("restart"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: my_defined_colors.AppColors.buttonColor,
                    ),
                    child: const Icon(
                      Icons.restart_alt,
                      color: my_defined_colors.AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () => onCommand("lock"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: my_defined_colors.AppColors.buttonColor,
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: my_defined_colors.AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
