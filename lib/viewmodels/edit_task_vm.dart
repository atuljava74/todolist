import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../services/database_service.dart'; // Import your updated DatabaseService

class EditTaskViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  bool _isLoading = false;
  String? _errorMessage;

  EditTaskViewModel({required String uid}) : _databaseService = DatabaseService(uid: uid);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Method to update the task in the Firestore collection for the current user
  Future<void> updateTask(String taskId, String title, String description, DateTime date) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      // Call the DatabaseService to update the task
      await _databaseService.updateTaskInfo(taskId, title, description, date);
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to update task: ${e.toString()}');
    }
  }

  // Helper method to manage loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Helper method to manage error messages
  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
