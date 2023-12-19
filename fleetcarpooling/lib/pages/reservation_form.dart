import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            'Selected Date Range: ${_formatDate(selectedDateRange?.start)} - ${_formatDate(selectedDateRange?.end)}',
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
          Text('Pickup Time: ${_formatTime(pickupTime)}'),
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
          Text('Return Time: ${_formatTime(returnTime)}'),
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
          ElevatedButton(
            onPressed: () async {
              DateTime date = selectedDateRange!.start;
              TimeOfDay time = pickupTime;

              DateTime date2 = selectedDateRange!.end;
              TimeOfDay time2 = returnTime;

              DateTime pickupDateTime = DateTime(
                  date.year, date.month, date.day, time.hour, time.minute);

              DateTime returnDateTime = DateTime(
                  date2.year, date2.month, date2.day, time2.hour, time2.minute);

              print(pickupDateTime);
              print(returnDateTime);
            },
            child: Text('Check'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd').format(date) : '';
  }

  String _formatTime(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }
}
