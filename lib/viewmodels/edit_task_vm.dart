import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTaskViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> updateTask(String taskId, String title, String description, DateTime date) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
      });
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Failed to update task: ${e.toString()}');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
