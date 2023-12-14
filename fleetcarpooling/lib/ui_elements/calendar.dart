import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'colors' as my_defined_colors;

class MyCalendar extends StatelessWidget {
  const MyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
          width: 300,
          height: 500,
          child: TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle:
                    TextStyle(color: my_defined_colors.AppColors.mainTextColor),
                disabledTextStyle: TextStyle(
                  color: my_defined_colors.AppColors.unavailableColor,
                ),
                defaultTextStyle:
                    TextStyle(color: my_defined_colors.AppColors.activeDays)),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: my_defined_colors.AppColors.mainTextColor),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle:
                  TextStyle(color: my_defined_colors.AppColors.activeDays),
              weekendStyle:
                  TextStyle(color: my_defined_colors.AppColors.activeDays),
            ),
            enabledDayPredicate: (day) {
              return day.isAfter(DateTime.now().subtract(Duration(days: 1)));
            },
          )),
    );
  }
}
