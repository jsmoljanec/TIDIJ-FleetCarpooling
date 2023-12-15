import 'package:flutter/material.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTimeRange? selectedDateRange;
  TimeOfDay pickupTime = TimeOfDay.now();
  TimeOfDay returnTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Reservation'),
      ),
      body: Column(
        children: [
          Text(
            'Selected Date Range: ${selectedDateRange?.start} - ${selectedDateRange?.end}',
          ),
          ElevatedButton(
            onPressed: () async {
              DateTimeRange? pickedDateRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (pickedDateRange != null) {
                setState(() {
                  selectedDateRange = pickedDateRange;
                });
              }
            },
            child: Text('Select Date Range'),
          ),
          Text('Pickup Time: ${(pickupTime)}'),
          Slider(
            value: pickupTime.hour.toDouble(),
            min: 0,
            max: 23,
            onChanged: (value) {
              setState(() {
                pickupTime =
                    TimeOfDay(hour: value.toInt(), minute: pickupTime.minute);
              });
            },
          ),
          Text('Return Time: $returnTime'),
          Slider(
            value: returnTime.hour.toDouble(),
            min: 0,
            max: 23,
            onChanged: (value) {
              setState(() {
                returnTime =
                    TimeOfDay(hour: value.toInt(), minute: returnTime.minute);
              });
            },
          ),
        ],
      ),
    );
  }
}
