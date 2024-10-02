import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'table_calendar_viewmodel.dart';

class TableCalendarView extends StatefulWidget {
  const TableCalendarView({Key? key}) : super(key: key);

  @override
  _TableCalendarViewState createState() => _TableCalendarViewState();
}

class _TableCalendarViewState extends State<TableCalendarView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TableCalendarViewModel(),
      child: Consumer<TableCalendarViewModel>(
        builder: (context, calendarViewModel, child) {
          return Container(
            color: const Color(0xff272727), // Background color for the entire container
            child: Column(
              children: [
                Container(
                  color: const Color(0xff272727),
                  //padding: EdgeInsets.all(16.0), // Padding for the container
                  child: TableCalendar(
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      todayTextStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: const Color(0xff8687E7),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      defaultTextStyle: const TextStyle(color: Colors.white), // Date color
                      weekendTextStyle: const TextStyle(color: Colors.red), // Weekend date color
                    ),
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w300,
                      ),
                      formatButtonVisible: false,
                      leftChevronIcon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 15),
                      rightChevronIcon: Icon(Icons.chevron_right_outlined, color: Colors.white, size: 20),
                      leftChevronPadding: EdgeInsets.all(0),
                      rightChevronPadding: EdgeInsets.all(0),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.white), // Weekday name color
                      weekendStyle: TextStyle(color: Colors.red), // Weekend name color
                    ),
                    availableCalendarFormats: const {
                      CalendarFormat.month: '',
                      CalendarFormat.twoWeeks: '',
                      CalendarFormat.week: '',
                    },
                    firstDay: DateTime.utc(2023, 1, 1),
                    lastDay: DateTime.utc(2050, 12, 31),
                    focusedDay: calendarViewModel.focusedDay,
                    calendarFormat: calendarViewModel.calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(day, calendarViewModel.selectedDay),
                    onDaySelected: (selectedDay, focusedDay) {
                      calendarViewModel.changeSelectedDay(selectedDay);
                      calendarViewModel.focusedDay = focusedDay; // Update focused day
                    },
                    onFormatChanged: (format) {
                      calendarViewModel.calendarFormat = format; // Update calendar format
                    },
                    onPageChanged: (focusedDay) {
                      calendarViewModel.focusedDay = focusedDay; // Update focused day
                    },
                    // Use calendarBuilders to customize each day
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, events) {
                        final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black38, // Background color for all days
                              borderRadius: BorderRadius.circular(5), // Optional rounded corners
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              date.day.toString(),
                              style: const TextStyle(
                                color: Colors.white, // Set text color to white for all days
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
