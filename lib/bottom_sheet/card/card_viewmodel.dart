import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants.dart'; // Make sure this is the correct path to constants

class CardViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // A map to track completion status of tasks
  final Map<int, bool> _taskCompletionStatus = {};

  bool isTaskCompleted(int taskId) {
    return _taskCompletionStatus[taskId] ?? false;
  }

  Future<void> markTaskAsComplete(int taskId) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('$BASE_url/complete_task.php'); // Update with your API URL
    final response = await http.post(url, body: {
      'task_id': taskId.toString(),
    });
    print('response : $response');
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('responseBody : $responseBody');
      if (responseBody['message'] == "Task marked as completed") {
        _taskCompletionStatus[taskId] = true; // Mark the task as completed
        print('taskId : $taskId');
      } else {
        // Handle error message
        print("Error: ${responseBody['error']}");
      }
    } else {
      // Handle server error
      print("Error: ${response.statusCode}");
    }

    _isLoading = false;
    notifyListeners();
  }

  void refreshUI() {
    notifyListeners();
  }
}
