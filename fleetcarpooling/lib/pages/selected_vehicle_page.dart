import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/calendar.dart';
import 'package:flutter/material.dart';

class SelectedVehiclePage extends StatefulWidget {
  final String vin;
  const SelectedVehiclePage({super.key, required this.vin});

  @override
  State<SelectedVehiclePage> createState() => _SelectedVehiclePageState();
}

class _SelectedVehiclePageState extends State<SelectedVehiclePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                CircularIconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(widget.vin),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {},
                      child: Image.asset("assets/icons/chat.png")),
                ),
              ],
            ),
          ),
          MyCalendar(),
        ],
      ),
    );
  }
}
