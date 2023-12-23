import 'package:fleetcarpooling/pages/navigation.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ui_elements/custom_slider.dart';
import 'package:flutter/material.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTimeRange? selectedDateRange;
  TimeOfDay pickupTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay returnTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Text(
            "FLEET CARPOOLING",
            style: TextStyle(color: AppColors.mainTextColor),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "WHEN ARE YOU PLANNING TO TRAVEL?",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.mainTextColor, fontSize: 24),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 24.0),
            child: Text(
              "Pick up time",
              style: TextStyle(
                color: AppColors.mainTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Center(
            child: MyCustomSlider(
              min: 7,
              max: 16,
              time: _formatTime(pickupTime),
              initialValue: 7,
              onChanged: (value) {
                setState(() {
                  pickupTime = TimeOfDay(hour: value.toInt(), minute: 00);
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 24.0),
            child: Text(
              "Return time",
              style: TextStyle(
                color: AppColors.mainTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Center(
            child: MyCustomSlider(
              min: 0,
              max: 23,
              time: _formatTime(returnTime),
              initialValue: 7,
              onChanged: (value) {
                setState(() {
                  returnTime = TimeOfDay(hour: value.toInt(), minute: 00);
                });
              },
            ),
          ),
          MyElevatedButton(
            onPressed: () async {
              DateTime date = selectedDateRange!.start;
              TimeOfDay time = pickupTime;

              DateTime date2 = selectedDateRange!.end;
              TimeOfDay time2 = returnTime;

              DateTime pickupDateTime = DateTime(
                  date.year, date.month, date.day, time.hour, time.minute);

              DateTime returnDateTime = DateTime(
                  date2.year, date2.month, date2.day, time2.hour, time2.minute);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationPage(
                    pickupTime: pickupDateTime,
                    returnTime: returnDateTime,
                  ),
                ),
              );

              print(pickupDateTime);
              print(returnDateTime);
            },
            label: "Check",
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }
}
