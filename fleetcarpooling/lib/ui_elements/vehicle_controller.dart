import 'package:flutter/material.dart';

class VehicleController extends StatelessWidget {
  final Function(String) onCommand;
  final selectedMarkerId;

  VehicleController({required this.onCommand, this.selectedMarkerId});

  @override
  Widget build(BuildContext context) {
    TextEditingController locationController = TextEditingController();
    
    return Positioned(
      bottom: 16.0,
      left: 16.0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 150.0, // Adjust the width based on your design
                margin: const EdgeInsets.only(right: 8.0),
                child: TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    hintText: 'Enter destination',
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  // onCommand("set-destination ${locationController.text}");
                  var inputText = locationController.text;
                  if(inputText != "" && inputText.isEmpty == false) {
                    onCommand("set-destination $inputText");
                  }
                },
                child: const Icon(Icons.change_circle),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  onCommand("start");
                },
                child: const Icon(Icons.start)
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  onCommand("stop");
                },
                child: const Icon(Icons.stop)
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  onCommand("restart");
                },
                child: const Icon(Icons.restart_alt)
              ),
            ],
          ),
            ],
          ),
    );
  }
}

