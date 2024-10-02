import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../utils/utils.dart';
import '../tag_category/tag_category.dart';
import '../task_priority/task_priority.dart';

class BottomSheetViewModel extends ChangeNotifier {
  final TextEditingController addTaskController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedDate = '';
  String selectedTime = '';
  int? selectedFlag;
  String selectedCategory = '';


  BottomSheetViewModel();

  Future<void> addTask(BuildContext context) async {
    final body = {
      'user_id': Utils.userId,
      'title': addTaskController.text,
      'description': descriptionController.text,
      'date_of_completion': selectedDate,
      'time_of_completion': selectedTime,
      'task_category': selectedCategory,
      'priority': selectedFlag.toString(),
    };

    // Send a POST request to your API
    final response = await http.post(
      Uri.parse('$BASE_url/add_task.php'),
      body: body,
    );

    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['error'] == null) {
          // Handle success
          print(responseData['message']);
        } else {
          _showErrorDialog(context, responseData['error']);
        }
      } else {
        _showErrorDialog(context, 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog(context, 'Error: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show Priority Selection Dialog
  showNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskPriorityPage(onSelect: (flag) {
          selectedFlag = flag;
          notifyListeners();
          Navigator.of(context).pop(); // Close the dialog
        });
      },
    );
  }

  showTagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TagCategoryDialog(
          onCategorySelected: (selectedCategory) {
            this.selectedCategory = selectedCategory; // Update the selected category
            notifyListeners(); // Notify listeners to update the UI
          },
        );
      },
    );
  }
}
