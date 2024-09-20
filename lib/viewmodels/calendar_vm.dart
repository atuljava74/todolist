import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/task.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';

class CalendarViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  DateTime selectedDay = DateTime.now();
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<Task> _tasks = [];
  bool _isLoading = false;
  DateTime focusedDay = DateTime.now();

  CalendarViewModel() : _databaseService = DatabaseService(uid: Utils.userId);

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  int? selectedIndex;

  // To get the start of the week from the selected date
  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  // Generate 7 days list starting from the current start of the week
  List<DateTime> getCurrentWeekDays() {
    DateTime startOfWeek = _getStartOfWeek(selectedDay);
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  // Move to previous week
  void goToPreviousWeek() {
    selectedDay = selectedDay.subtract(Duration(days: 7));
    selectedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    fetchTasksForSelectedDate();
    notifyListeners();
  }

  // Move to next week
  void goToNextWeek() {
    selectedDay = selectedDay.add(Duration(days: 7));
    selectedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    fetchTasksForSelectedDate();
    notifyListeners();
  }

  // Change the selected day
  void changeSelectedDay(DateTime day) {
    selectedDay = day;
    selectedDate = DateFormat('yyyy-MM-dd').format(day);
    fetchTasksForSelectedDate();
    notifyListeners();
  }

  // Fetch tasks for the selected date using the getTasksByDate method
  Future<void> fetchTasksForSelectedDate() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("selectedDate ${selectedDate}");
      _tasks = await _databaseService.getTasksByDate(selectedDate);
      notifyListeners();
      print("_tasks ${_tasks}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Select/Unselect a task index
  Future<void> toggleTaskSelection(Task task) async {
    await _databaseService.updateTask(task.id, !task.isCompleted);
    fetchTasksForSelectedDate();
    notifyListeners();
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    await _databaseService.deleteTask(taskId);
    fetchTasksForSelectedDate(); // Refresh tasks after deletion
  }
}
