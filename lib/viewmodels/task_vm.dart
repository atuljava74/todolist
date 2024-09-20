import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';

class TaskViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Method to select a date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      notifyListeners();
    }
  }

  // Method to add a task (accepting uid dynamically)
  Future<void> addTask(String uid, String title, String description) async {
    _setLoading(true);
    try {
      // Create a new instance of DatabaseService with the uid
      DatabaseService databaseService = DatabaseService(uid: uid);
      await databaseService.addTask(title, description, _selectedDate);
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Error adding task: $e');
    }
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Set error message
  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
