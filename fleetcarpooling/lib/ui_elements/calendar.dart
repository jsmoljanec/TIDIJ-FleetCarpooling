import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'colors' as my_defined_colors;

class MyCalendar extends StatelessWidget {
  final double height;
  final double width;
  const MyCalendar({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
          width: width,
          height: height,
          child: TableCalendar(
            rowHeight: 35,
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
                selectedTextStyle: TextStyle(
                  color: my_defined_colors.AppColors.activeDays,
                ),
                defaultTextStyle:
                    TextStyle(color: my_defined_colors.AppColors.activeDays)),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: my_defined_colors.AppColors.mainTextColor),
              leftChevronIcon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: my_defined_colors.AppColors.mainTextColor),
              rightChevronIcon: Transform.rotate(
                angle: 3.141592,
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: my_defined_colors.AppColors.mainTextColor),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (day, locale) {
                final weekdayFormat = DateFormat('E', locale);
                final formattedDay = weekdayFormat.format(day);
                switch (formattedDay) {
                  case 'Mon':
                    return 'M';
                  case 'Tue':
                    return 'T';
                  case 'Wed':
                    return 'W';
                  case 'Thu':
                    return 'T';
                  case 'Fri':
                    return 'F';
                  case 'Sat':
                    return 'S';
                  case 'Sun':
                    return 'S';
                  default:
                    return formattedDay;
                }
              },
              weekdayStyle: const TextStyle(
                  color: my_defined_colors.AppColors.activeDays),
              weekendStyle: const TextStyle(
                  color: my_defined_colors.AppColors.activeDays),
            ),
            enabledDayPredicate: (day) {
              return day
                  .isAfter(DateTime.now().subtract(const Duration(days: 1)));
            },
          )),
    );
  }
}
