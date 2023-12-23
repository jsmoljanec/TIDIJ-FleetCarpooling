import 'package:fleetcarpooling/pages/navigation.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ui_elements/custom_slider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTimeRange? selectedDateRange;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTimeRange? _selectedDateRange;
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
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime.now(),
            lastDay: DateTime(2101),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              rangeStartDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
              ),
              rangeHighlightColor: Colors.blue.withOpacity(0.2),
              defaultTextStyle: const TextStyle(
                color: Colors.blue,
              ),
              weekendTextStyle: const TextStyle(
                color: Colors.blue,
              ),
            ),
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue),
              titleTextStyle: TextStyle(color: Colors.blue),
              headerPadding: EdgeInsets.all(8.0),
            ),
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            selectedDayPredicate: (day) {
              return _selectedDateRange != null &&
                  day.isAfter(_selectedDateRange!.start
                      .subtract(const Duration(days: 1))) &&
                  day.isBefore(
                      _selectedDateRange!.end.add(const Duration(days: 1)));
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (_selectedDateRange == null) {
                  _selectedDateRange = DateTimeRange(
                    start: selectedDay,
                    end: selectedDay,
                  );
                } else if (_selectedDateRange!.start ==
                    _selectedDateRange!.end) {
                  final newStart =
                      _selectedDateRange!.start.isBefore(selectedDay)
                          ? _selectedDateRange!.start
                          : selectedDay;
                  final newEnd = _selectedDateRange!.start.isBefore(selectedDay)
                      ? selectedDay
                      : _selectedDateRange!.start;
                  _selectedDateRange = DateTimeRange(
                    start: newStart,
                    end: newEnd,
                  );
                } else {
                  _selectedDateRange = DateTimeRange(
                    start: selectedDay,
                    end: selectedDay,
                  );
                }
                selectedDateRange = _selectedDateRange;
              });
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MyElevatedButton(
                  onPressed: () async {
                    DateTime date = selectedDateRange!.start;
                    TimeOfDay time = pickupTime;

                    DateTime date2 = selectedDateRange!.end;
                    TimeOfDay time2 = returnTime;

                    DateTime pickupDateTime = DateTime(date.year, date.month,
                        date.day, time.hour, time.minute);

                    DateTime returnDateTime = DateTime(date2.year, date2.month,
                        date2.day, time2.hour, time2.minute);

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
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }
}
