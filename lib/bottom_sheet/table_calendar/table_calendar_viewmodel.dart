import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalendarViewModel extends ChangeNotifier {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.week; // Default calendar format

  // Generate 7 days list starting from the current start of the week
  List<DateTime> getCurrentWeekDays() {
    DateTime startOfWeek = selectedDay.subtract(Duration(days: selectedDay.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  // Change the selected day
  void changeSelectedDay(DateTime day) {
    selectedDay = day;
    notifyListeners();
  }

  // Move to previous week
  void goToPreviousWeek() {
    selectedDay = selectedDay.subtract(Duration(days: 7));
    notifyListeners();
  }

  // Move to next week
  void goToNextWeek() {
    selectedDay = selectedDay.add(Duration(days: 7));
    notifyListeners();
  }
}
