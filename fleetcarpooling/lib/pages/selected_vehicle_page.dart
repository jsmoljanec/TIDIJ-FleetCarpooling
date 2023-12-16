import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/calendar.dart';
import 'package:fleetcarpooling/ui_elements/colors';
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
    double screenWidth = MediaQuery.of(context).size.width;
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                border: Border.all(
                  color: AppColors.mainTextColor,
                ),
              ),
              child: Column(
                children: [
                  MyCalendar(
                    height: 200,
                    width: screenWidth,
                  ),
                  MyElevatedButton(
                      onPressed: () {}, label: "MAKE A RESERVATION")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
