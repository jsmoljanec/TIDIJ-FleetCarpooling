import 'package:flutter/material.dart';

class VehicleController extends StatelessWidget {
  final Function(String) onCommand;

  VehicleController({required this.onCommand});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      left: 16.0,
      child: Row(
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
    );
  }
}

