import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class EditCardViewModel extends ChangeNotifier {
  String selectedDate = " ";
  String selectedTime = " ";
  var showProgressbar = false;


  refreshUI() {
    notifyListeners();
  }





  // Future<void> updateTask(
  //     BuildContext context,
  //     String taskId,
  //     String title,
  //     String description,
  //     String date,
  //     String time,
  //     String category,
  //     String priority,
  //     ) async {
  //   // Build the request body
  //   final body = {
  //     'task_id': taskId,
  //     'user_id': '1', // Assuming user_id is constant for now
  //     'title': title,
  //     'description': description,
  //     'date_of_completion': date,
  //     'time_of_completion': time,
  //     'task_category': category,
  //     'priority': priority.toString(),
  //   };
  //
  //   print(body);
  //
  //   bool toastShown = false; // Flag to prevent multiple toast messages
  //
  //   try {
  //     // Send the POST request with the body data
  //     final response = await http.post(
  //       Uri.parse('$BASE_url/edit_task.php'),
  //       body: body,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       print(responseData); // Debug response
  //
  //       if (responseData['error'] == null && !toastShown) {
  //         // Task was successfully updated, show a success snackbar
  //         Fluttertoast.showToast(
  //           msg: "Task updated successfully",
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 2,
  //           backgroundColor: Colors.black,
  //           textColor: Colors.white,
  //           fontSize: 16.0,
  //         );
  //         toastShown = true; // Set flag to true after showing toast
  //
  //         Navigator.pop(context, true);
  //       } else if (!toastShown) {
  //         // Show error message from response
  //         Fluttertoast.showToast(
  //           msg: "Failed to update task",
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 2,
  //           backgroundColor: Colors.black,
  //           textColor: Colors.white,
  //           fontSize: 16.0,
  //         );
  //         toastShown = true;
  //       }
  //     } else {
  //       _showErrorDialog(context, 'Server error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     _showErrorDialog(context, 'Network error: $e');
  //     print('Network error: $e');
  //   }
  //   refreshUI();
  // }
  //
  //
  //
  //
  //
  //
  //
  // void _showErrorDialog(BuildContext context, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Error'),
  //         content: Text(message),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void showDatePickerAndTime(BuildContext context) async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //
  //   if (pickedDate != null) {
  //     selectedDate = pickedDate.toLocal().toString().split(' ')[0];
  //     notifyListeners();
  //     _showTimePicker(context); // Show TimePicker after selecting the date
  //   }
  // }

  // Show TimePicker
  // void _showTimePicker(BuildContext context) async {
  //   TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //
  //   if (pickedTime != null) {
  //     selectedTime = pickedTime.format(context);
  //     notifyListeners();
  //   }
  // }


}
