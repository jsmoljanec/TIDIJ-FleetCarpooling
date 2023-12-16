import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'colors' as my_defined_colors;

class MyCalendar extends StatelessWidget {
  final double height;
  final double width;
  final List<DateTime> busyTerms;
  final List<DateTime> freeTerms;

  const MyCalendar({
    Key? key,
    required this.height,
    required this.width,
    required this.busyTerms,
    required this.freeTerms,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: width,
        height: height,
        child: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: my_defined_colors.AppColors.primaryColor,
              ),
              todayTextStyle: TextStyle(
                color: my_defined_colors.AppColors.activeDays,
              ),
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
            weekdayStyle:
                const TextStyle(color: my_defined_colors.AppColors.activeDays),
            weekendStyle:
                const TextStyle(color: my_defined_colors.AppColors.activeDays),
          ),
          enabledDayPredicate: (day) {
            return day
                .isAfter(DateTime.now().subtract(const Duration(days: 1)));
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              if (freeTerms.any((termin) => isSameDay(termin, day))) {
                return Container(
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle().copyWith(
                          color: my_defined_colors.AppColors.activeDays),
                    ),
                  ),
                );
              } else if (busyTerms.any((termin) => isSameDay(termin, day))) {
                return Container(
                  decoration: BoxDecoration(
                    color: my_defined_colors.AppColors.reservedInCalendar,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle().copyWith(
                          color: my_defined_colors.AppColors.mainTextColor),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
          onDaySelected: (selectedDay, focusedDay) {
            _showAvailableHoursAlert(context, selectedDay);
          },
        ),
      ),
    );
  }

  void _showAvailableHoursAlert(BuildContext context, DateTime selectedDay) {
    List<DateTime> availableHours =
        freeTerms.where((termin) => isSameDay(termin, selectedDay)).toList();

    String availableHoursString =
        availableHours.map((hour) => DateFormat.Hm().format(hour)).join(', ');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
              dialogBackgroundColor:
                  my_defined_colors.AppColors.backgroundColor),
          child: AlertDialog(
            content: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Hours on ${DateFormat.yMMMd().format(selectedDay)}\n\nAvailable hours for pick up: $availableHoursString',
                    style: TextStyle(
                      color: my_defined_colors.AppColors.mainTextColor,
                      fontSize: 18,
                    ),
                  ),
                  Expanded(child: Container()),
                  Image.asset(
                    'assets/images/logo_login.png', // Replace with your image asset
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}
